package com.verifix.vhr.hikvision

import uz.greenwhite.biruni.crypto.HMAC
import uz.greenwhite.biruni.http.TrustAllCerts

import java.net.{HttpURLConnection, URL}
import java.security.{InvalidKeyException, NoSuchAlgorithmException}
import javax.net.ssl.HttpsURLConnection

object HikvisionConnection {
  private def generateCASignature(requestPath: String, partnerKey: String, partnerSecret: String): String = {
    var message = "POST\n"
    message += "*/*\n"
    message += "application/json\n"
    message += "x-ca-key:" + partnerKey + "\n"
    message += requestPath
    try HMAC.computeHash(message, partnerSecret)
    catch {
      case e@(_: NoSuchAlgorithmException | _: InvalidKeyException) =>
        throw new RuntimeException(e)
    }
  }

  def getHttpsConnection(url: URL, requestPath: String, partnerKey: String, partnerSecret: String): HttpURLConnection = {
    var conn: HttpURLConnection = null
    val protocol = url.getProtocol

    if ("https".equals(protocol)) {
      val trustAllCerts = new TrustAllCerts
      trustAllCerts.trust()
      conn = url.openConnection().asInstanceOf[HttpsURLConnection]
    } else if ("http".equals(protocol)) conn = url.openConnection().asInstanceOf[HttpURLConnection]

    if (conn != null) {
      conn.setDoInput(true)
      conn.setDoOutput(true)
      conn.setConnectTimeout(5000)
      conn.setRequestMethod("POST")

      conn.setRequestProperty("x-ca-key", partnerKey)
      conn.setRequestProperty("x-ca-signature", generateCASignature(requestPath, partnerKey, partnerSecret))
      conn.setRequestProperty("x-ca-signature-headers", "x-ca-key")
      conn.setRequestProperty("Content-Type", "application/json")
      conn.setRequestProperty("Accept", "*/*")
    }

    conn
  }
}