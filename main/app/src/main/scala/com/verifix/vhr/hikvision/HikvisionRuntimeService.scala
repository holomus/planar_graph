package com.verifix.vhr.hikvision

import com.verifix.vhr.ImgUtil
import org.json.JSONObject
import uz.greenwhite.biruni.service.runtimeservice.{ErrorRuntimeResult, RuntimeResult, RuntimeService, SuccessRuntimeResult}

import java.net.{HttpURLConnection, URI}
import java.nio.charset.StandardCharsets
import java.util.Base64
import scala.io.{Codec, Source}

class HikvisionRuntimeService extends RuntimeService {
  private val RESPONSE_SUCCESS:String = "0"

  override def run(detail: Map[String, Any], data: String): RuntimeResult = {
    val partnerKey = detail.getOrElse("partner_key", "").asInstanceOf[String]
    val partnerSecret = detail.getOrElse("partner_secret", "").asInstanceOf[String]
    val hostUrl = detail.getOrElse("host_url", "").asInstanceOf[String]
    val requestPath = detail.getOrElse("request_path", "").asInstanceOf[String]
    val requestData = new JSONObject(data)

    var conn: HttpURLConnection = null

    val url = URI.create(hostUrl + requestPath).toURL
    conn = HikvisionConnection.getHttpsConnection(url, requestPath, partnerKey, partnerSecret)

    val out = conn.getOutputStream
    out.write(requestData.toString.getBytes(StandardCharsets.UTF_8))
    out.flush()
    out.close()

    if (conn.getResponseCode == HttpURLConnection.HTTP_OK) {
      if (conn.getContentType == ImgUtil.CONTENT_TYPE_IMAGE_JPEG) {
        val imgBase64 = Source.fromInputStream(conn.getInputStream)(Codec.UTF8).mkString.split(",")(1)
        val imgBytes = Base64.getDecoder.decode(imgBase64)

        SuccessRuntimeResult(ImgUtil.uploadImageFromByteArray(imgBytes))
      }
      else {
        val response = new JSONObject(Source.fromInputStream(conn.getInputStream)(Codec.UTF8).mkString)
        if (response.getString("code") == RESPONSE_SUCCESS) {
          SuccessRuntimeResult(response.optJSONObject("data", new JSONObject()).toString)
        } else
          ErrorRuntimeResult("Hikvision error description:" + response.getString("msg"))
      }
    } else {
      if (conn.getErrorStream != null) {
        ErrorRuntimeResult(Source.fromInputStream(conn.getErrorStream)(Codec.UTF8).mkString)
      } else {
        ErrorRuntimeResult("Hikvision response error status code = " + conn.getResponseCode)
      }
    }
  }
}
