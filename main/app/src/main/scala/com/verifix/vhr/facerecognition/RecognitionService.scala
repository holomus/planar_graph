package com.verifix.vhr.facerecognition

import com.verifix.vhr.ImgUtil
import org.json.{JSONArray, JSONObject}
import uz.greenwhite.biruni.http.TrustAllCerts

import java.net.{HttpURLConnection, URI}
import java.nio.charset.StandardCharsets
import java.util.Base64
import javax.net.ssl.HttpsURLConnection
import scala.io.Source

object RecognitionService {
  private def getConnection(uri: String, method: String, username: String, password: String, data: JSONObject): HttpURLConnection = {
    val url = URI.create(uri).toURL

    var conn: HttpURLConnection = null
    val protocol = url.getProtocol
    val encodedUserpass = Base64.getEncoder.encodeToString((username + ":" + password).getBytes(StandardCharsets.UTF_8))

    if ("https" == protocol) {
      val trustAllCerts = new TrustAllCerts
      trustAllCerts.trust()
      conn = url.openConnection.asInstanceOf[HttpsURLConnection]
    }
    else if ("http" == protocol) conn = url.openConnection.asInstanceOf[HttpURLConnection]

    if (conn == null) throw new Exception("Couldn't establish connection")

    conn.setRequestMethod(method)
    conn.setRequestProperty("Content-Type", "application/json; utf-8")
    conn.setDoOutput(true)
    conn.setConnectTimeout(5000)
    conn.setRequestProperty("Authorization", "Basic " + encodedUserpass)

    if (data != null) {
      val out = conn.getOutputStream
      out.write(data.toString.getBytes(StandardCharsets.UTF_8))
      out.flush()
      out.close()
    }

    conn
  }

  def calcPhotoVector(url: String,
                      method: String,
                      username: String,
                      password: String,
                      photoSha: String): JSONObject = {
    var conn: HttpURLConnection = null

    try {
      val data = new JSONObject()

      data.put("image", "data:image/jpeg;base64," + ImgUtil.loadBase64EncodedImage(photoSha))

      conn = getConnection(url, method, username, password, data)

      if (conn.getResponseCode == HttpURLConnection.HTTP_OK) {
        val response = new JSONObject(Source.fromInputStream(conn.getInputStream)(StandardCharsets.UTF_8).mkString)

        response
      } else {
        if (conn.getErrorStream != null) throw new Exception(Source.fromInputStream(conn.getErrorStream)(StandardCharsets.UTF_8).mkString)
        else throw new Exception("Calc photo vector response error status code = " + conn.getResponseCode)
      }
    } finally {
      if (conn != null) conn.disconnect()
    }
  }
}
