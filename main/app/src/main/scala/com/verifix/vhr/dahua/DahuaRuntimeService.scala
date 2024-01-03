package com.verifix.vhr.dahua

import com.verifix.vhr.ImgUtil
import org.json.{JSONArray, JSONObject}
import uz.greenwhite.biruni.service.runtimeservice.{ErrorRuntimeResult, RuntimeResult, RuntimeService, SuccessRuntimeResult}

import java.net.HttpURLConnection
import scala.io.{Codec, Source}

class DahuaRuntimeService extends RuntimeService {

  private val RESPONSE_SUCCESS = 1000
  private val PERSON_CREATE_URI = "/obms/api/v1.1/acs/person"

  private def getAuthToken(hostUrl: String, username: String, password: String): String = {
    val authResult = DahuaService.getToken(hostUrl, username, password)

    if (authResult.isInvalid)
      throw new RuntimeException("Dahua auth failed")

    authResult.getToken
  }

  override def run(detail: Map[String, Any], data: String): RuntimeResult = {
    var conn: HttpURLConnection = null
    try {
      val serviceAction = detail.getOrElse("dahua_service_action", "").asInstanceOf[String]

      if (serviceAction.nonEmpty) {
        if (serviceAction.equals("start_notification")) {
          DahuaService.startMQ()
          return SuccessRuntimeResult(DahuaService.getAccountNotifications.toString)
        }
        if (serviceAction.equals("get_account_tokens")) {
          return SuccessRuntimeResult(DahuaService.getAccountTokens.toString)
        }
        if (serviceAction.equals("stop_notification")) {
          DahuaService.stopMQ()
          return SuccessRuntimeResult("")
        }
        return ErrorRuntimeResult("Unregistered service action: " + serviceAction)
      }

      var requestData = new JSONObject(data)
      val hostUrl = detail.getOrElse("host_url", "").asInstanceOf[String]
      val method = detail.getOrElse("method", "POST").asInstanceOf[String]
      val apiUri = detail.getOrElse("api_uri", "").asInstanceOf[String]
      val resourceUri = detail.getOrElse("resource_uri", "").asInstanceOf[String]
      val facePictureSha = detail.getOrElse("face_picture_sha", "").asInstanceOf[String]
      var queryParams = detail.getOrElse("query_params", "").asInstanceOf[String]
      var objectId = detail.getOrElse("object_id", "").asInstanceOf[String]
      val authDetails = detail.getOrElse("auth_details", Map.empty).asInstanceOf[Map[String, String]]
      val username = authDetails.getOrElse("username", "")
      val password = authDetails.getOrElse("password", "")

      if (hostUrl.isEmpty)
        throw new RuntimeException("host_url should be defined for request")
      if (apiUri.isEmpty)
        throw new RuntimeException("api_uri should be defined for request")

      if (queryParams.nonEmpty)
        queryParams = "?" + queryParams
      if (objectId.nonEmpty)
        objectId = "/" + objectId

      val token = getAuthToken(hostUrl, username, password)
      val url = hostUrl + apiUri + objectId + resourceUri + queryParams

      if (!requestData.isEmpty) {
        if (url == hostUrl + PERSON_CREATE_URI) {
          val baseInfo = requestData.getJSONObject("baseInfo")
          val facePictures = new JSONArray()

          if (facePictureSha.nonEmpty)
            facePictures.put(ImgUtil.loadBase64EncodedCroppedImage(facePictureSha))

          baseInfo.put("facePictures", facePictures)
          requestData.put("baseInfo", baseInfo)
        }
      } else requestData = null

      conn = DahuaUtil.getConnection(url, method, token, requestData)

      if (conn.getResponseCode == HttpURLConnection.HTTP_OK) {
        if (conn.getContentType == ImgUtil.CONTENT_TYPE_IMAGE_JPEG) {
          SuccessRuntimeResult(ImgUtil.uploadImage(conn.getInputStream))
        }
        else {
          val response = new JSONObject(Source.fromInputStream(conn.getInputStream)(Codec.UTF8).mkString)
          if (response.getInt("code") == RESPONSE_SUCCESS) {
            SuccessRuntimeResult(response.optJSONObject("data", new JSONObject()).toString)
          } else
            ErrorRuntimeResult("Dahua error description:" + response.getString("desc"))
        }
      } else {
        if (conn.getErrorStream != null) {
          ErrorRuntimeResult(Source.fromInputStream(conn.getErrorStream)(Codec.UTF8).mkString)
        } else {
          ErrorRuntimeResult("Dahua response error status code = " + conn.getResponseCode)
        }
      }
    }
    catch {
      case ex: Exception =>
        ErrorRuntimeResult(ex.getMessage)
    }
    finally {
      if (conn != null) conn.disconnect()
    }
  }
}