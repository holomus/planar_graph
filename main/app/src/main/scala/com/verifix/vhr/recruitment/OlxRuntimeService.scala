package com.verifix.vhr.recruitment

import com.verifix.vhr.oauth2.OAuth2Service
import org.json.JSONObject
import uz.greenwhite.biruni.service.runtimeservice.{ErrorRuntimeResult, RuntimeResult, RuntimeService, SuccessRuntimeResult}

import java.net.{HttpURLConnection, URI, URL}
import java.nio.charset.StandardCharsets
import scala.io.{Codec, Source}

class OlxRuntimeService extends RuntimeService {
  private def isEmpty(x: String): Boolean = x == null || x.isEmpty

  private def prepareConnection(url: URL, method: String, headers: Map[String, String]): HttpURLConnection = {
    val conn: HttpURLConnection = url.openConnection.asInstanceOf[HttpURLConnection]

    if (conn != null) {
      conn.setDoOutput(true)
      conn.setConnectTimeout(5000)
      conn.setRequestMethod(method)

      for ((key, value) <- headers) {
        conn.setRequestProperty(key, value)
      }
    }
    conn
  }

  private def setHttpConnection(url: URL, method: String, headers: Map[String, String], requestData: JSONObject): RuntimeResult = {
    var conn: HttpURLConnection = null

    try {
      conn = prepareConnection(url, method, headers)

      if (!requestData.isEmpty) {
        val out = conn.getOutputStream
        out.write(requestData.toString.getBytes(StandardCharsets.UTF_8))
        out.flush()
        out.close()
      }

      if (conn.getResponseCode == HttpURLConnection.HTTP_OK || conn.getResponseCode == HttpURLConnection.HTTP_NO_CONTENT) {
        SuccessRuntimeResult(Source.fromInputStream(conn.getInputStream)(Codec.UTF8).mkString)
      } else {
        if (conn.getErrorStream != null) {
          SuccessRuntimeResult(Source.fromInputStream(conn.getErrorStream)(Codec.UTF8).mkString)
        } else {
          ErrorRuntimeResult("Olx response error status code = " + conn.getResponseCode)
        }
      }
    } catch {
      case ex: Exception =>
        ErrorRuntimeResult("connection fail with Olx server " + ex.getMessage)
    } finally {
      if (conn != null) conn.disconnect()
    }
  }

  private def refreshAccessToken(refreshToken: String, data: Map[String, Any]): String = {
    val companyId = data.getOrElse("company_id", "").asInstanceOf[String].toInt
    val userId = data.getOrElse("user_id", "").asInstanceOf[String].toInt
    val providerId = data.getOrElse("provider_id", "").asInstanceOf[String].toInt

    val clientId = data.getOrElse("client_id", "").asInstanceOf[String]
    val clientSecret = data.getOrElse("client_secret", "").asInstanceOf[String]

    val authUrl = data.getOrElse("token_url", "").asInstanceOf[String]
    val contentType = data.getOrElse("content_type", "").asInstanceOf[String]
    val scope = data.getOrElse("scope", "").asInstanceOf[String]

    if (isEmpty(clientId)) throw new Exception("provide clientId")
    if (isEmpty(clientSecret)) throw new Exception("provide clientSecret")

    if (isEmpty(authUrl)) throw new Exception("provide authUrl")
    if (isEmpty(contentType)) throw new Exception("provide contentType")

    OAuth2Service.refreshAccessToken(authUrl,
      contentType,
      clientId,
      clientSecret,
      refreshToken,
      scope,
      companyId,
      userId,
      providerId)
  }

  override def run(detail: Map[String, Any], data: String): RuntimeResult = {
    val refreshToken = detail.getOrElse("refresh_token", "").asInstanceOf[String]
    var accessToken = detail.getOrElse("token", "").asInstanceOf[String]

    if (!isEmpty(refreshToken)) {
      accessToken = refreshAccessToken(refreshToken, detail)
    }

    val method = detail.getOrElse("method", "").asInstanceOf[String]
    val hostUrl = detail.getOrElse("host", "").asInstanceOf[String]
    val requestPath = detail.getOrElse("request_path", "").asInstanceOf[String]
    val requestData = new JSONObject(data)
    val headers = Map("content-type" -> "application/json", "Authorization" -> ("Bearer " + accessToken), "Version" -> "2.0")

    setHttpConnection(URI.create(hostUrl + requestPath).toURL, method, headers, requestData)
  }
}