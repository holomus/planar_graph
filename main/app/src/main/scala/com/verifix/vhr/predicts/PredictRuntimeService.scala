package com.verifix.vhr.predicts

import org.json.{JSONArray, JSONObject}
import uz.greenwhite.biruni.json.JSON
import uz.greenwhite.biruni.service.runtimeservice.{ErrorRuntimeResult, RuntimeResult, RuntimeService, SuccessRuntimeResult}

import java.net.{HttpURLConnection, URI, URL}
import java.nio.charset.StandardCharsets
import scala.io.{Codec, Source}

class PredictRuntimeService extends RuntimeService {

  private def getHttpConnection(url: URL, method: String, headers: Map[String, String]): HttpURLConnection = {
    val conn: HttpURLConnection = url.openConnection.asInstanceOf[HttpURLConnection]

    if (conn != null) {
      conn.setDoInput(true)
      conn.setDoOutput(true)
      conn.setConnectTimeout(5000)
      conn.setRequestMethod(method)
      conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8")
      conn.setRequestProperty("Accept", "application/json")

      for ((key, value) <- headers) {
        conn.setRequestProperty(key, value)
      }
    }
    conn
  }

  private def predictCategory(url: URL, method: String, category: Map[String, String], predictBegin: String, predictEnd: String, predictType: String): JSONObject = {
    val response = new JSONObject()
    var conn: HttpURLConnection = null

    response.put("area_id", category.getOrElse("area_id", ""))
    response.put("driver_id", category.getOrElse("driver_id", ""))

    try {
      conn = getHttpConnection(url, method, Map.empty)

      val requestData = new JSONObject()

      requestData.put("train_data", new JSONArray(category.getOrElse("facts", "[]")))
      requestData.put("predict_begin", predictBegin)
      requestData.put("predict_end", predictEnd)
      requestData.put("predict_type", predictType)

      if (!requestData.isEmpty) {
        val out = conn.getOutputStream
        out.write(requestData.toString.getBytes(StandardCharsets.UTF_8))
        out.flush()
        out.close()
      }

      if (conn.getResponseCode == HttpURLConnection.HTTP_OK) {
        val responseData = new JSONObject(Source.fromInputStream(conn.getInputStream)(Codec.UTF8).mkString)
        if (responseData.getInt("code") == HttpURLConnection.HTTP_OK) {
          response.put("predicted", responseData.getString("data"))
        } else
          response.put("error_message", response.getString("desc"))
      } else {
        if (conn.getErrorStream != null) {
          response.put("error_message", Source.fromInputStream(conn.getErrorStream)(Codec.UTF8).mkString)
        } else {
          response.put("error_message", conn.getResponseCode)
        }
      }
    }
    catch {
      case ex: Exception =>
        response.put("error_message", ex.getMessage)
    }
    finally {
      if (conn != null) conn.disconnect()
    }

    response
  }

  override def run(detail: Map[String, Any], data: String): RuntimeResult = {
    try {
      val requestData = JSON.parseForce(data)

      val hostUrl = detail.getOrElse("host_url", "").asInstanceOf[String]
      val method = detail.getOrElse("method", "POST").asInstanceOf[String]
      val apiUri = detail.getOrElse("api_uri", "").asInstanceOf[String]

      val url = URI.create(hostUrl + apiUri).toURL

      val categories = requestData.getOrElse("categories", List.empty).asInstanceOf[List[Map[String, String]]]
      val predictBegin = requestData.getOrElse("predict_begin", "").asInstanceOf[String]
      val predictEnd = requestData.getOrElse("predict_end", "").asInstanceOf[String]
      val predictType = requestData.getOrElse("predict_type", "").asInstanceOf[String]

      val response = new JSONObject()
      val categoryResponses = new JSONArray()

      response.put("predict_type", predictType)

      for {
        category <- categories
      } {
        categoryResponses.put(predictCategory(url, method, category, predictBegin, predictEnd, predictType))
      }

      response.put("categories", categoryResponses)

      SuccessRuntimeResult(response.toString)
    }
    catch {
      case ex: Exception =>
        ErrorRuntimeResult(ex.getMessage)
    }
  }
}
