package com.verifix.vhr

import uz.greenwhite.biruni.json.JSON
import uz.greenwhite.biruni.service.runtimeservice.{ErrorRuntimeResult, RuntimeResult, RuntimeService, SuccessRuntimeResult}

import java.net.{HttpURLConnection, URI, URL}
import pdi.jwt.{Jwt, JwtAlgorithm, JwtClaim}

import scala.io.{Codec, Source}

class BillzRuntimeService extends RuntimeService {
  private val JWT_TIME_LEEWAY = 180 // in seconds, added for clock skew

  /** generates JSON Web Token
   * subject and secretKey are provided by Billz and saved in Verifix
   * */
  private def generateToken(subject: String, secretKey: String): String = {
    val currentTime = System.currentTimeMillis() / 1000L - JWT_TIME_LEEWAY
    val claim = JwtClaim(
      expiration = Some(currentTime + 3600), // expire in 1 hour
      issuedAt = Some(currentTime),
      subject = Some(subject)
    )
    val token = Jwt.encode(claim, secretKey, JwtAlgorithm.HS256)
    token
  }

  //noinspection SameParameterValue
  private def getHttpConnection(url: URL, method: String, headers: Map[String, String]): HttpURLConnection = {
    val conn: HttpURLConnection = url.openConnection.asInstanceOf[HttpURLConnection]

    if (conn != null) {
      conn.setDoInput(true)
      conn.setDoOutput(true)
      conn.setConnectTimeout(5000)
      conn.setRequestMethod(method)

      for ((key, value) <- headers) {
        conn.setRequestProperty(key, value)
      }
    }
    conn
  }

  /** initializes an HTTP connection with the Billz server and sends a post request */
  private def post(url: String, headers: Map[String, String], requestBody: String): RuntimeResult = {
    var conn: HttpURLConnection = null

    try {
      conn = getHttpConnection(URI.create(url).toURL, "POST", headers)

      val out = conn.getOutputStream
      out.write(requestBody.getBytes("UTF-8"))
      out.flush()
      out.close()

      if (conn.getResponseCode == HttpURLConnection.HTTP_OK) {
        SuccessRuntimeResult(Source.fromInputStream(conn.getInputStream)(Codec.UTF8).mkString)
      } else {
        if (conn.getErrorStream != null) {
          ErrorRuntimeResult(Source.fromInputStream(conn.getErrorStream)(Codec.UTF8).mkString)
        } else {
          ErrorRuntimeResult("Billz response error status code = " + conn.getResponseCode)
        }
      }
    } catch {
      case ex: Exception =>
        ErrorRuntimeResult("connection fail with Billz server " + ex.getMessage)
    } finally {
      if (conn != null) conn.disconnect()
    }
  }

  override def run(detail: Map[String, Any], requestData: String): RuntimeResult = {
    /** fetch request variables from detail map */
    val url: String = detail.getOrElse("url", "").asInstanceOf[String]
    val method: String = detail.getOrElse("method", "").asInstanceOf[String]
    val id: String = detail.getOrElse("id", "").asInstanceOf[String]
    val subject: String = detail.getOrElse("subject", "").asInstanceOf[String]
    val secretKey: String = detail.getOrElse("secret_key", "").asInstanceOf[String]
    val dateBegin: String = detail.getOrElse("date_begin", "").asInstanceOf[String]
    val dateEnd: String = detail.getOrElse("date_end", "").asInstanceOf[String]
    val currency: String = detail.getOrElse("currency", "").asInstanceOf[String]

    var headers: Map[String, String] = detail.getOrElse("headers", Map.empty).asInstanceOf[Map[String, String]]

    val accessToken = "Bearer " + generateToken(subject, secretKey)

    headers = headers.updated("Authorization", accessToken)
                     .updated("content-type", "application/json")

    /** check if all the request variables are non-empty */
    if (url.isEmpty) {
      return ErrorRuntimeResult("url is required")
    }

    if (method.isEmpty) {
      return ErrorRuntimeResult("method is required")
    }

    if (id.isEmpty) {
      return ErrorRuntimeResult("id is required")
    }

    if (subject.isEmpty) {
      return ErrorRuntimeResult("subject is required")
    }

    if (dateBegin.isEmpty) {
      return ErrorRuntimeResult("dateBegin is required")
    }

    if (dateEnd.isEmpty) {
      return ErrorRuntimeResult("dateBegin is required")
    }

    if (currency.isEmpty) {
      return ErrorRuntimeResult("currency is required")
    }

    /** collect the request body */
    val requestBody = JSON.stringify(Map("jsonrpc" -> "2.0",
      "method" -> method,
      "params" -> Map("dateBegin" -> dateBegin, "dateEnd" -> dateEnd,"currency" -> currency),
      "id" -> id))

    val r = post(url, headers, requestBody)
    r
  }
}
