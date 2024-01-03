package com.verifix.vhr.dahua;

import com.google.errorprone.annotations.DoNotCall;
import org.json.JSONObject;
import scala.io.Codec;
import scala.io.Source;

import java.net.HttpURLConnection;
import java.util.Date;

public class DahuaToken {
    private static final String AUTH_URI = "/brms/api/v1.0/accounts/authorize";
    private static final String KEEP_ALIVE_URL = "/brms/api/v1.0/accounts/keepalive";
    private static final String UPDATE_TOKEN_URL = "/brms/api/v1.0/accounts/updateToken";
    private static final String SUCCESS_CODE = "1000";
    private static final String DEFAULT_CLIENT_TYPE = "WINPC_V2";
    private static final String DEFAULT_ENCRYPT_TYPE = "MD5";
    private static final int USER_TYPE_SYSTEM = 0;
    private static final int USER_TYPE_DOMAIN = 1;
    public final DahuaAccount account;
    public final String publicKey;
    public final String privateKey;
    private boolean invalid;
    private long duration;
    private String token;
    private String userId;
    private long tokenRate;
    private String secretKeyWithRsa;
    private String secretVectorWithRsa;
    private long tokenCreateTime;
    private long tokenExpiryTime;
    private long tokenHardExpiryTime;
    private String signatureTmp;
    private String dssPublicKey;
    private String invalidMessage;
    private Thread th;

    public DahuaToken(DahuaAccount account, String publicKey, String privateKey) {
        this.account = account;
        this.publicKey = publicKey;
        this.privateKey = privateKey;

        generate();

        if (!this.invalid) {
            th = new Thread(new KeepAlive());
            th.start();
        }
    }

    public void destroy() {
        this.invalid = true;
        if (this.th.isAlive() && !this.th.isInterrupted()) {
            this.th.interrupt();
        }
    }

    private void generate() {
        HttpURLConnection conn = null;
        try {
            JSONObject data = new JSONObject();
            String uri = account.hostUrl + AUTH_URI;

            if (account.username.isEmpty() || account.password.isEmpty())
                throw new RuntimeException("username and password should be defined for authorization");

            // First Login
            data.put("userName", account.username);
            data.put("ipAddress", "");
            data.put("clientType", DEFAULT_CLIENT_TYPE);

            conn = DahuaUtil.getConnection(uri, "POST", "", data);

            if (conn.getResponseCode() != HttpURLConnection.HTTP_UNAUTHORIZED)
                throw new RuntimeException("SHOULD HAVE GOTTEN 401");

            JSONObject response = new JSONObject(Source.fromInputStream(conn.getErrorStream(), Codec.UTF8()).mkString());

            String realm = response.getString("realm");
            String randomKey = response.getString("randomKey");

            this.dssPublicKey = response.getString("publickey");
            this.signatureTmp = DahuaUtil.signature(account.username, account.password, realm);

            data.put("signature", DahuaUtil.signature(signatureTmp, randomKey));
            data.put("randomKey", randomKey);
            data.put("publicKey", publicKey);
            data.put("encryptType", DEFAULT_ENCRYPT_TYPE);
            data.put("userType", USER_TYPE_SYSTEM);

            // Second Login
            conn = DahuaUtil.getConnection(uri, "POST", "", data);

            if (conn.getResponseCode() != HttpURLConnection.HTTP_OK) {
                if (conn.getErrorStream() != null) {
                    throw new RuntimeException(Source.fromInputStream(conn.getErrorStream(), Codec.UTF8()).mkString());
                } else {
                    throw new RuntimeException("Connection error status code = " + conn.getResponseCode());
                }
            }

            response = new JSONObject(Source.fromInputStream(conn.getInputStream(), Codec.UTF8()).mkString());

            this.invalid = false;
            this.duration = response.getInt("duration");
            this.tokenRate = response.getInt("tokenRate");

            // recommended value of duration and tokenRate 3/4 of origin
            this.duration = this.duration * 3000l / 4;
            this.tokenRate = this.tokenRate * 3000l / 4;

            this.userId = response.getString("userId");
            this.secretKeyWithRsa = response.getString("secretKey");
            this.secretVectorWithRsa = response.getString("secretVector");

            setToken(response.getString("token"));
        } catch (Exception e) {
            this.invalid = true;
            this.duration = 0;
            this.token = null;
            this.userId = null;
            this.tokenRate = 0;
            this.secretKeyWithRsa = null;
            this.secretVectorWithRsa = null;
            this.signatureTmp = null;
            this.dssPublicKey = null;
            this.tokenCreateTime = 0;
            this.tokenExpiryTime = 0;
            this.tokenHardExpiryTime = 0;
            invalidMessage = e.getMessage();
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    public boolean isInvalid() {
        return invalid;
    }

    public String getToken() {
        return token;
    }

    private void setToken(String token) {
        Date d = new Date();
        this.token = token;
        this.tokenCreateTime = d.getTime();
        this.tokenExpiryTime = d.getTime() + this.duration;
        this.tokenHardExpiryTime = d.getTime() + this.tokenRate;
    }

    public String getUserId() {
        return userId;
    }

    public long getTokenExpiryTime() {
        return tokenExpiryTime;
    }

    public String getInvalidMessage() {
        return invalidMessage;
    }

    public String getSecretKeyWithRsa() {
        return secretKeyWithRsa;
    }

    public String getSecretVectorWithRsa() {
        return secretVectorWithRsa;
    }

    public JSONObject getInfo() {
        JSONObject obj = new JSONObject();

        obj.put("invalid", invalid);
        obj.put("host", account.hostUrl);
        obj.put("username", account.username);
        obj.put("password", account.password);
        obj.put("token", token);
        obj.put("userId", userId);
        obj.put("tokenCreateTime", tokenCreateTime);
        obj.put("tokenExpiryTime", tokenExpiryTime);
        obj.put("tokenHardExpiryTime", tokenHardExpiryTime);
        obj.put("invalidMessage", invalidMessage);

        return obj;
    }

    private class KeepAlive implements Runnable {

        @DoNotCall
        private void updateToken() {
            JSONObject param = new JSONObject();
            param.put("token", token);
            param.put("signature", DahuaUtil.signature(signatureTmp, token));

            HttpURLConnection conn = null;
            try {
                conn = DahuaUtil.getConnection(account.hostUrl + UPDATE_TOKEN_URL, "POST", token, param);

                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    String response = Source.fromInputStream(conn.getInputStream(), Codec.UTF8()).mkString();
                    JSONObject data = new JSONObject(response);
                    if (SUCCESS_CODE.equals(data.get("code").toString())) {
                        setToken(data.getString("token"));
                    } else {
                        new RuntimeException("inner code not success: " + response);
                    }
                } else {
                    throw new RuntimeException("request gets wrong status: " + Source.fromInputStream(conn.getErrorStream(), Codec.UTF8()).mkString());
                }
            } catch (Exception e) {
                throw new RuntimeException("KeepAlive->updateToken: " + e.getMessage());
            } finally {
                if (conn != null) conn.disconnect();
            }
        }

        private void heartbeatToken() {
            HttpURLConnection conn = null;
            try {
                JSONObject param = new JSONObject();
                param.put("token", token);

                conn = DahuaUtil.getConnection(account.hostUrl + KEEP_ALIVE_URL, "PUT", token, param);


                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    String response = Source.fromInputStream(conn.getInputStream(), Codec.UTF8()).mkString();
                    JSONObject data = new JSONObject(response);

                    if (SUCCESS_CODE.equals(data.get("code").toString())) {
                        Date d = new Date();
                        tokenExpiryTime = d.getTime() + duration;
                    }
                } else {
                    throw new RuntimeException("request gets wrong status" + Source.fromInputStream(conn.getErrorStream(), Codec.UTF8()).mkString());
                }
            } catch (Exception e) {
                throw new RuntimeException("KeepAlive->hearbeatToken: " + e.getMessage());
            } finally {
                if (conn != null) {
                    conn.disconnect();
                }
            }
        }

        @Override
        public void run() {
            try {
                while (true) {
                    Date d = new Date();
                    if (Thread.currentThread().isInterrupted()) {
                        break;
                    }
                    if (d.getTime() > tokenHardExpiryTime) {
                        // restore token
                        break;
//                        updateToken();
//                        continue;
                    }

                    Thread.sleep(duration);

                    heartbeatToken();
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            } finally {
                if (Thread.currentThread().isAlive() && !Thread.currentThread().isInterrupted()) {
                    Thread.currentThread().interrupt();
                }
            }
        }
    }
}

