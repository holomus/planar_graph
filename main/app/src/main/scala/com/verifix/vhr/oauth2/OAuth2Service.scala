package com.verifix.vhr.oauth2

import oracle.jdbc.OracleCallableStatement
import org.json.JSONObject
import uz.greenwhite.biruni.connection.DBConnection
import uz.greenwhite.biruni.http.TrustAllCerts

import java.net.{HttpURLConnection, URI}
import java.nio.charset.StandardCharsets
import javax.net.ssl.HttpsURLConnection
import scala.io.Source

object OAuth2Service {
  private val APPLICATION_JSON = "application/json"
  private val APPLICATION_FORM_URLENCODED = "application/x-www-form-urlencoded"
  private val GRANT_TYPE_AUTH_CODE = "authorization_code"
  private val GRANT_TYPE_REFRESH_TOKEN = "refresh_token"
  private val TOKEN_TYPE = "bearer"

  /** turns JSONObject into x-www-form-urlencoded string
   *
   * data: JSONObject must be json object containing only strings */
  private def encodeBody(data: JSONObject): String = {
    val encodedData = new StringBuilder()
    val keys = data.keys()

    while (keys.hasNext) {
      val key = keys.next()
      if (encodedData.nonEmpty) encodedData.append("&")
      encodedData.append(key + "=" + data.getString(key))
    }

    encodedData.mkString
  }

  private def getConnection(authUrl: String, contentType: String): HttpURLConnection = {
    var conn: HttpURLConnection = null
    val url = URI.create(authUrl).toURL
    val protocol = url.getProtocol

    if ("https".equals(protocol)) {
      val trustAllCerts = new TrustAllCerts
      trustAllCerts.trust()
      conn = url.openConnection().asInstanceOf[HttpsURLConnection]
    } else if ("http".equals(protocol)) conn = url.openConnection().asInstanceOf[HttpURLConnection]

    if (conn == null) throw new Exception("Couldn't establish connection")

    conn.setDoInput(true)
    conn.setDoOutput(true)
    conn.setConnectTimeout(5000)
    conn.setRequestMethod("POST")
    conn.setRequestProperty("Content-Type", contentType)
    conn.setRequestProperty("Accept", "application/json")

    conn
  }

  private def saveAccessToken(companyId: Int,
                              userId: Int,
                              providerId: Int,
                              accessToken: String,
                              refreshToken: String,
                              expiresIn: Int): Unit = {
    var conn = DBConnection.getPoolConnection
    var cs: OracleCallableStatement = null

    try {
      conn.setAutoCommit(false)

      val query = "BEGIN Hes_Core.Save_Access_Token(?,?,?,?,?,?); END;"
      cs = conn.prepareCall(query).asInstanceOf[OracleCallableStatement]
      cs.setInt(1, companyId)
      cs.setInt(2, userId)
      cs.setInt(3, providerId)
      cs.setString(4, accessToken)
      cs.setString(5, refreshToken)
      cs.setInt(6, expiresIn)
      cs.execute

      conn.commit()
    } catch {
      case ex: Exception =>
        conn.rollback()
        println("Save access token error. Error message " + ex.getMessage)
        throw ex
    } finally {
      if (cs != null) cs.close()
      conn.close()
      conn = null
    }
  }

  private def processAuthResponse(companyId: Int,
                                  userId: Int,
                                  providerId: Int,
                                  conn: HttpURLConnection): String = {
    if (conn.getResponseCode == HttpURLConnection.HTTP_OK) {
      val response = new JSONObject(Source.fromInputStream(conn.getInputStream)(StandardCharsets.UTF_8).mkString)

      if (response.getString("token_type") != TOKEN_TYPE) throw new Exception("Not a bearer token")

      val accessToken = response.getString("access_token")
      val refreshToken = response.optString("refresh_token")
      val expiresIn = response.optInt("expires_in")

      saveAccessToken(companyId,
                      userId,
                      providerId,
                      accessToken,
                      refreshToken,
                      expiresIn)

      accessToken
    } else {
      if (conn.getErrorStream != null) throw new Exception(Source.fromInputStream(conn.getErrorStream)(StandardCharsets.UTF_8).mkString)
      else throw new Exception("Oauth response error status code = " + conn.getResponseCode)
    }
  }

  def getAccessToken(authUrl: String,
                     contentType: String,
                     authCode: String,
                     clientId: String,
                     clientSecret: String,
                     scope: String,
                     companyId: Int,
                     userId: Int,
                     providerId: Int): String = {
    var conn: HttpURLConnection = null

    try {
      conn = getConnection(authUrl, contentType)

      val requestData = new JSONObject()

      requestData.put("client_id", clientId)
      requestData.put("client_secret", clientSecret)
      requestData.put("grant_type", GRANT_TYPE_AUTH_CODE)
      requestData.put("code", authCode)

      if (scope != null && scope.nonEmpty) requestData.put("scope", scope)

      val output = contentType match {
        case APPLICATION_JSON => requestData.toString
        case APPLICATION_FORM_URLENCODED => encodeBody(requestData)
        case _ => throw new Exception("not supported MediaType")
      }

      val out = conn.getOutputStream
      out.write(output.getBytes(StandardCharsets.UTF_8))
      out.flush()
      out.close()

      processAuthResponse(companyId, userId, providerId, conn)
    } finally {
      if (conn != null) conn.disconnect()
    }
  }

  def refreshAccessToken(authUrl: String,
                         contentType: String,
                         clientId: String,
                         clientSecret: String,
                         refreshToken: String,
                         scope: String,
                         companyId: Int,
                         userId: Int,
                         providerId: Int): String = {
    var conn: HttpURLConnection = null

    try {
      conn = getConnection(authUrl, contentType)

      val requestData = new JSONObject()

      requestData.put("client_id", clientId)
      requestData.put("client_secret", clientSecret)
      requestData.put("grant_type", GRANT_TYPE_REFRESH_TOKEN)
      requestData.put("refresh_token", refreshToken)

      if (scope != null && scope.nonEmpty) requestData.put("scope", scope)

      val output = contentType match {
        case APPLICATION_JSON => requestData.toString
        case APPLICATION_FORM_URLENCODED => encodeBody(requestData)
        case _ => throw new Exception("not supported MediaType")
      }

      val out = conn.getOutputStream
      out.write(output.getBytes(StandardCharsets.UTF_8))
      out.flush()
      out.close()

      processAuthResponse(companyId, userId, providerId, conn)
    } finally {
     if (conn != null) conn.disconnect()
    }
  }
}
