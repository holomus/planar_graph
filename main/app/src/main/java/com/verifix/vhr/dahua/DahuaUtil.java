package com.verifix.vhr.dahua;

import com.verifix.vhr.ImgUtil;
import org.apache.commons.codec.digest.DigestUtils;
import org.json.JSONObject;
import scala.io.Codec;
import scala.io.Source;
import uz.greenwhite.biruni.http.TrustAllCerts;

import javax.net.ssl.HttpsURLConnection;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class DahuaUtil {
    public static String signature(String username, String password, String realm) {
        String temp1 = DigestUtils.md5Hex(password);
        String temp2 = DigestUtils.md5Hex(username + temp1);
        String temp3 = DigestUtils.md5Hex(temp2);
        return DigestUtils.md5Hex(username + ":" + realm + ":" + temp3);
    }

    public static String signature(String signatureTmp, String randomKey) {
        return DigestUtils.md5Hex(signatureTmp + ":" + randomKey);
    }

    public static HttpURLConnection getConnection(String uri, String method, String xSubjectToken, JSONObject data) throws Exception {
        URL url = URI.create(uri).toURL();
        HttpURLConnection conn = null;
        String protocol = url.getProtocol();

        if ("https".equals(protocol)) {
            TrustAllCerts trustAllCerts = new TrustAllCerts();
            trustAllCerts.trust();
            conn = (HttpsURLConnection) url.openConnection();
        } else if ("http".equals(protocol)) {
            conn = (HttpURLConnection) url.openConnection();
        }

        conn.setRequestMethod(method);
        conn.setRequestProperty("Content-Type", "application/json; utf-8");
        conn.setDoOutput(true);
        conn.setConnectTimeout(5000);

        if (!xSubjectToken.isEmpty()) {
            conn.setRequestProperty("X-Subject-Token", xSubjectToken);
        }

        if (data != null) {
            OutputStream out = conn.getOutputStream();
            out.write(data.toString().getBytes(StandardCharsets.UTF_8));
            out.flush();
            out.close();
        }

        return conn;
    }

    public static String getImage(String imageUrl, String host, String username, String password) {
        HttpURLConnection conn = null;
        try {
            DahuaToken token = DahuaService.getToken(host, username, password);
            conn = DahuaUtil.getConnection(imageUrl + "?token=" + token.getToken(), "GET", "", null);
            if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                return ImgUtil.uploadImage(conn.getInputStream());
            } else {
                throw new RuntimeException("Dahua image load status error: " + Source.fromInputStream(conn.getErrorStream(), Codec.UTF8()).mkString());
            }
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        } finally {
            if (conn != null) conn.disconnect();
        }
    }
}
