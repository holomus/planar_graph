package com.verifix.vhr.dahua;

import oracle.jdbc.OracleConnection;
import org.json.JSONArray;
import org.json.JSONObject;
import uz.greenwhite.biruni.connection.DBConnection;

import java.security.*;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;

public class DahuaService {
    private static DahuaService instance;
    private final HashMap<String, ArrayList<DahuaToken>> accountTokens;
    private final HashMap<String, DahuaPushNotification> accountNotifications;
    private String publicKey;
    private String privateKey;

    DahuaService() {
        this.accountTokens = new HashMap<>();
        this.accountNotifications = new HashMap<>();

        this.generateKeys();
    }

    public static synchronized void init() {
        if (instance == null) {
            instance = new DahuaService();
        }
    }

    private static void checkInitialization() {
        if (instance == null) throw new RuntimeException("Dahua Integration Service is not initialized");
    }

    public static void startMQ() {
        checkInitialization();
        instance.startNotifications();
    }

    public static void stopMQ() {
        checkInitialization();
        instance.stopNotifications();
    }

    public static DahuaToken getToken(String host, String username, String password) {
        checkInitialization();
        DahuaAccount account = new DahuaAccount(host, username, password);

        return instance.getTokenByAccount(account);
    }

    public static JSONObject getAccountNotifications() {
        checkInitialization();
        JSONObject obj = new JSONObject();

        instance.accountNotifications.keySet().forEach(key -> {
            obj.put(key, instance.accountNotifications.get(key).getInfo());
        });

        return obj;
    }

    public static JSONArray getAccountTokens() {
        checkInitialization();
        JSONArray obj = new JSONArray();
        instance.accountTokens.keySet().forEach(key -> {
            for (DahuaToken token : instance.accountTokens.get(key)) {
                obj.put(token.getInfo());
            }
        });

        return obj;
    }

    private DahuaToken registerToken(DahuaAccount account) {
        DahuaToken token = new DahuaToken(account, publicKey, privateKey);

        if (!token.isInvalid()) {
            this.accountTokens.get(account.accountHash).add(token);
        }

        return token;
    }

    private KeyPair getRsaKeys() throws Exception {
        Provider provider = Security.getProvider("SunRsaSign");
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA", provider);
        keyPairGen.initialize(2048, new SecureRandom());
        KeyPair keyPair = keyPairGen.generateKeyPair();
        return keyPair;
    }

    private void generateKeys() {
        try {
            KeyPair keyPair = getRsaKeys();

            PublicKey publicKey = keyPair.getPublic();
            PrivateKey privateKey = keyPair.getPrivate();

            this.publicKey = Base64.getEncoder().encodeToString(publicKey.getEncoded());
            this.privateKey = Base64.getEncoder().encodeToString(privateKey.getEncoded());
        } catch (Exception e) {
            this.publicKey = null;
            this.privateKey = null;
        }
    }

    private ArrayList<DahuaToken> getTokens(String accountHash) {
        ArrayList<DahuaToken> tokens;

        if (this.accountTokens.containsKey(accountHash)) {
            tokens = this.accountTokens.get(accountHash);
        } else {
            tokens = new ArrayList<>();
            this.accountTokens.put(accountHash, tokens);
        }
        return tokens;
    }

    private DahuaToken getTokenByAccount(DahuaAccount account) {
        synchronized (DahuaService.class + account.accountHash) {
            ArrayList<DahuaToken> tokens = getTokens(account.accountHash);
            long now = (new Date()).getTime();

            DahuaToken result = null;

            for (int i = tokens.size() - 1; i >= 0; i--) {
                DahuaToken token = tokens.get(i);

                if (token.isInvalid() || token.getTokenExpiryTime() < now) {
                    tokens.remove(i);
                } else {
                    result = token;
                }
            }

            if (result != null) {
                return result;
            }

            return registerToken(account);
        }
    }

    private String synchKeyNotification() {
        return DahuaService.class + "notificationChange";
    }

    private void stopNotifications() {
        synchronized (synchKeyNotification()) {
            ArrayList<String> keys = new ArrayList<>();
            keys.addAll(accountNotifications.keySet());

            for (String key : keys) {
                try {
                    accountNotifications.get(key).stopListener();
                } catch (Exception e) {
                    System.out.println("Dahua service stop notification change key:" + key + " message: " + e.getMessage());
                } finally {
                    accountNotifications.remove(key);
                }
            }
        }
    }

    private ArrayList<DahuaAccount> getDahuaAccounts() {
        ArrayList<DahuaAccount> result = new ArrayList<>();

        OracleConnection conn;
        try {
            conn = DBConnection.getSingletonConnection();
            Statement cs = conn.createStatement();
            ResultSet rs = cs.executeQuery("select host_url, username, password from hac_dahua_servers_view");

            while (rs.next()) {
                result.add(new DahuaAccount(rs.getString("host_url"), rs.getString("username"), rs.getString("password")));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            return result;
        }
    }

    private void startNotifications() {
        synchronized (synchKeyNotification()) {
            try {
                ArrayList<DahuaAccount> accounts = getDahuaAccounts();

                ArrayList<String> keys = new ArrayList<>();
                keys.addAll(accountNotifications.keySet());

                keys.forEach(key -> {
                    boolean exist = false;
                    for (DahuaAccount acc : accounts) {
                        if (acc.accountHash.equals(key)) {
                            exist = true;
                            break;
                        }
                    }
                    if (!exist) {
                        try {
                            accountNotifications.get(key).stopListener();
                        } catch (Exception e) {
                            System.out.println("Dahua service restart notifications, account stop listeren key=" + key);
                        } finally {
                            accountNotifications.remove(key);
                        }
                    }
                });
                for (DahuaAccount acc : accounts) {
                    if (!accountNotifications.containsKey(acc.accountHash)) {
                        DahuaPushNotification push = new DahuaPushNotification();
                        try {
                            push.startListener(getTokenByAccount(acc));
                            accountNotifications.put(acc.accountHash, push);
                        } catch (Exception e) {
                            System.out.println("Dahua service restart notifications, account start listeren key=" + acc.accountHash);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
