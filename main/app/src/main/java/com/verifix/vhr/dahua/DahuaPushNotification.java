package com.verifix.vhr.dahua;

import jakarta.jms.*;
import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleConnection;
import oracle.jdbc.OracleTypes;
import org.apache.activemq.ActiveMQSslConnectionFactory;
import org.apache.activemq.command.ActiveMQTopic;
import org.json.JSONArray;
import org.json.JSONObject;
import scala.io.Codec;
import scala.io.Source;
import uz.greenwhite.biruni.connection.DBConnection;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509ExtendedTrustManager;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.security.Key;
import java.security.KeyFactory;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.security.spec.PKCS8EncodedKeySpec;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Base64;
import java.util.Objects;

import static com.verifix.vhr.dahua.DahuaUtil.getImage;

public class DahuaPushNotification {
    static final String MQ_URL_PREF = "ssl://%s";
    static final String MQ_CONFIG_URI = "/brms/api/v1.0/BRM/Config/GetMqConfig";
    private Connection connection;
    private boolean started;
    private String errorText;

    private static class DeviceSettings {
        final boolean deviceExists;
        final boolean imageIgnored;

        public DeviceSettings(boolean deviceExists, boolean ignoreImages) {
            this.deviceExists = deviceExists;
            this.imageIgnored = ignoreImages;
        }
    }

    /**
     * RSA private key is pkcs8 format.
     *
     * @param text
     * @param privateKeyEncoded : RSA privateKey
     * @return
     * @throws Exception
     */
    static String decryptRSAByPrivateKey(String text, byte[] privateKeyEncoded) throws Exception {
        byte[] data = Base64.getDecoder().decode(text);
        PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(privateKeyEncoded);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        Key privateKey = keyFactory.generatePrivate(pkcs8KeySpec);
        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] result = null;
        for (int i = 0; i < data.length; i += 256) {
            int to = (i + 256) < data.length ? (i + 256) : data.length;
            byte[] temp = cipher.doFinal(Arrays.copyOfRange(data, i, to));
            result = sumBytes(result, temp);
        }
        return new String(result, "UTF-8");
    }

    static byte[] sumBytes(byte[] bytes1, byte[] bytes2) {
        byte[] result = null;
        int len1 = 0;
        int len2 = 0;
        if (null != bytes1) {
            len1 = bytes1.length;
        }
        if (null != bytes2) {
            len2 = bytes2.length;
        }
        if (len1 + len2 > 0) {
            result = new byte[len1 + len2];
        }
        if (len1 > 0) {
            System.arraycopy(bytes1, 0, result, 0, len1);
        }
        if (len2 > 0) {
            System.arraycopy(bytes2, 0, result, len1, len2);
        }
        return result;
    }

    /**
     * AES encryption mode is CBC, and the filling mode is pkcs7padding.
     *
     * @param text
     * @param aesKey
     * @param aesVector
     * @return
     * @throws Exception
     */
    static String decryptWithAES7(String text, String aesKey, String aesVector) throws Exception {
        SecretKey keySpec = new SecretKeySpec(aesKey.getBytes("UTF-8"), "AES");
        //If your program run with an exception :"Cannot find any provider
        // supporting AES/CBC/PKCS7Padding",you can replace "PKCS7Padding" with "PKCS5Padding".
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        IvParameterSpec iv = new IvParameterSpec(aesVector.getBytes("UTF-8"));
        cipher.init(Cipher.DECRYPT_MODE, keySpec, iv);
        byte[] encrypted = parseHexStr2Byte(text);
        byte[] originalPassByte = cipher.doFinal(encrypted);
        return new String(originalPassByte, "UTF-8");
    }

    static byte[] parseHexStr2Byte(String hexStr) {
        if (hexStr.length() < 1) {
            return null;
        }
        byte[] result = new byte[hexStr.length() / 2];
        for (int i = 0; i < hexStr.length() / 2; i++) {
            int high = Integer.parseInt(hexStr.substring(i * 2, i * 2 + 1), 16);
            int low = Integer.parseInt(hexStr.substring(i * 2 + 1, i * 2 + 2), 16);
            result[i] = (byte) (high * 16 + low);
        }
        return result;
    }

    private static JSONObject getConfig(String hostUrl, String token) {
        HttpURLConnection conn = null;
        try {
            conn = DahuaUtil.getConnection(hostUrl + MQ_CONFIG_URI, "POST", token, new JSONObject("{}"));
            if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                InputStream in = conn.getInputStream();
                JSONObject r = new JSONObject(Source.fromInputStream(in, Codec.UTF8()).mkString());

                if (r.getInt("code") == 1000) {
                    return r.getJSONObject("data");
                } else {
                    throw new RuntimeException("mqConfig get error" + r.getString("desc"));
                }
            } else {
                throw new RuntimeException("mqConfig status error: " + Source.fromInputStream(conn.getErrorStream(), Codec.UTF8()).mkString());
            }
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    public JSONObject getInfo() {
        JSONObject obj = new JSONObject();
        obj.put("started", started);
        obj.put("error", errorText);

        return obj;
    }

    public void startListener(DahuaToken token) {
        if (token.isInvalid()) {
            started = false;
            errorText = "token is invalid: " + token.getInvalidMessage();
            return;
        }
        try {
            started = false;
            byte[] privateKeyBytes = Base64.getDecoder().decode(token.privateKey);
            //Decrypt "SecretKey" and "SecretVector".
            String secretKey = decryptRSAByPrivateKey(token.getSecretKeyWithRsa(), privateKeyBytes);
            String secretVector = decryptRSAByPrivateKey(token.getSecretVectorWithRsa(), privateKeyBytes);

            JSONObject mqConfigResponse = getConfig(token.account.hostUrl, token.getToken());

            //Now,this password is encrypted by AES.Decrypt it with the "SecretKey"and "SecretVector" we have got in Step1.
            String userName = mqConfigResponse.getString("userName");
            String userPasswordWithAes = mqConfigResponse.getString("password");
            String mqUrlAddr = mqConfigResponse.getString("addr");
            String userPassword = decryptWithAES7(userPasswordWithAes, secretKey, secretVector);

            CustomerMqFactory factory = new CustomerMqFactory();
            factory.setUserName(userName);
            factory.setTrustStore("");
            factory.setPassword(userPassword);
            factory.setBrokerURL(String.format(MQ_URL_PREF, mqUrlAddr));

            connection = factory.createConnection();
            connection.start();

            Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            MessageConsumer consumer;

            consumer = session.createConsumer(new ActiveMQTopic("mq.event.msg.topic." + token.getUserId()));
            System.out.println("Start listening...");
            consumer.setMessageListener((message) -> {
                TextMessage textMessage = (TextMessage) message;
                try {
                    String messageTextJson = textMessage.getText();
                    JSONObject obj = new JSONObject(messageTextJson);
                    if ("brms.notifyAcsEvents".equals(obj.getString("method").trim())) {
                        JSONArray arr = obj.getJSONArray("info");
                        for (int i = 0; i < arr.length(); i++) {
                            JSONObject info = (JSONObject) arr.get(i);
                            saveTrack(token.account, info);
                        }
                    }
                } catch (JMSException | SQLException e) {
                    e.printStackTrace();
                }
            });
            started = true;
            errorText = null;
        } catch (Exception e) {
            started = false;
            errorText = e.getMessage();
            e.printStackTrace();
        }
    }

    public void stopListener() throws JMSException {
        if (connection != null) {
            connection.stop();
            connection.close();
            connection = null;
        }
    }

    private DeviceSettings loadDeviceSettings(DahuaAccount account, String channelCode) {
        try (OracleConnection conn = DBConnection.getPoolConnection();
             OracleCallableStatement cs = (OracleCallableStatement) conn.prepareCall("BEGIN HAC_CORE.LOAD_DAHUA_DEVICE_SETTINGS(?,?,?,?); END;")) {
            cs.setString(1, account.hostUrl);
            cs.setString(2, channelCode);
            cs.registerOutParameter(3, OracleTypes.VARCHAR);
            cs.registerOutParameter(4, OracleTypes.VARCHAR);

            cs.execute();

            boolean deviceExists = Objects.equals(cs.getString(3), "Y");
            boolean ignoreImages = Objects.equals(cs.getString(4), "Y");

            return new DeviceSettings(deviceExists, ignoreImages);
        } catch (Exception ex) {
            System.out.println("Load device setting error. Error message " + ex.getMessage());
            return new DeviceSettings(false, true);
        }
    }

    private OracleCallableStatement getStatement(OracleConnection conn) throws SQLException {
        String query = "BEGIN HAC_CORE.DAHUA_MQ_NOTIFICATION(?,?,?,?,?,?,?,?); END;";
        return (OracleCallableStatement) conn.prepareCall(query);
    }

    private void saveTrack(DahuaAccount account, JSONObject info) throws SQLException {
        String personID = info.getString("personId");
        String channelCode = info.getString("channelCode");
        String swipDate = info.getString("swipDate");
        String photoUrl = info.optString("picture1", "");
        String eventType = info.optString("eventType", "");
        String photoSha = "";

        DeviceSettings settings = loadDeviceSettings(account, channelCode);

        if (!settings.deviceExists)
            return;

        OracleConnection conn = DBConnection.getPoolConnection();
        OracleCallableStatement cs = null;

        try {
            if (!photoUrl.isEmpty() && !settings.imageIgnored)
                photoSha = getImage(photoUrl, account.hostUrl, account.username, account.password);

            cs = getStatement(conn);
            cs.setString(1, account.hostUrl);
            cs.setString(2, personID);
            cs.setString(3, channelCode);
            cs.setString(4, swipDate);
            cs.setString(5, photoUrl);
            cs.setString(6, photoSha);
            cs.setString(7, eventType);
            cs.setString(8, info.toString());
            cs.execute();
        } catch (Exception ex) {
            System.out.println("Track save error. Error message " + ex.getMessage());
        } finally {
            if (cs != null) cs.close();
            conn.close();
            conn = null;
        }
    }

    static class CustomerMqFactory extends ActiveMQSslConnectionFactory {
        @Override
        protected TrustManager[] createTrustManager() {
            return new TrustManager[]{
                    new X509ExtendedTrustManager() {

                        @Override
                        public void checkClientTrusted(X509Certificate[] x509Certificates, String s) throws CertificateException {

                        }

                        @Override
                        public void checkServerTrusted(X509Certificate[] x509Certificates, String s) throws CertificateException {

                        }

                        @Override
                        public X509Certificate[] getAcceptedIssuers() {
                            return new X509Certificate[0];
                        }

                        @Override
                        public void checkClientTrusted(X509Certificate[] x509Certificates, String s, Socket socket) throws CertificateException {

                        }

                        @Override
                        public void checkServerTrusted(X509Certificate[] x509Certificates, String s, Socket socket) throws CertificateException {

                        }

                        @Override
                        public void checkClientTrusted(X509Certificate[] x509Certificates, String s, SSLEngine sslEngine) throws CertificateException {

                        }

                        @Override
                        public void checkServerTrusted(X509Certificate[] x509Certificates, String s, SSLEngine sslEngine) throws CertificateException {

                        }
                    }
            };
        }
    }
}
