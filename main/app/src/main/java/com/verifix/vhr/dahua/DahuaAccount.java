package com.verifix.vhr.dahua;

public class DahuaAccount {
    public final String accountHash;
    public final String hostUrl;
    public final String username;
    public final String password;

    public DahuaAccount(String hostUrl, String username, String password) {
        this.hostUrl = hostUrl;
        this.username = username;
        this.password = password;
        this.accountHash = hostUrl + "-" + username + "-" + password;
    }
}
