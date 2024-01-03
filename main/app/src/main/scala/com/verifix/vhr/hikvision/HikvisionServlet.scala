package com.verifix.vhr.hikvision

import com.verifix.vhr.AcmsUtil.{saveLog, splitChunks}
import com.verifix.vhr.ImgUtil
import jakarta.servlet.http.{HttpServlet, HttpServletRequest, HttpServletResponse}
import oracle.jdbc.{OracleCallableStatement, OracleConnection, OracleTypes}
import org.json.JSONObject
import uz.greenwhite.biruni.connection.DBConnection
import uz.greenwhite.biruni.json.JSON

import java.net.{HttpURLConnection, URI, URL}
import java.nio.charset.StandardCharsets
import java.io.PrintWriter
import java.io.StringWriter
import java.util.Base64
import scala.io.{Codec, Source}

class HikvisionServlet extends HttpServlet {
  private val HIKVISION_GET_ENCODED_PICTURE_FROM_URL = "/artemis/api/frs/v1/application/picture"
  private val PROCEDURE_AUTHENTICATE_HIK_SERVLET = "BEGIN HAC_CORE.AUTHENTICATE_HIK_SERVLET(?, ?, ?, ?, ?); END;"
  private val PROCEDURE_RECEIVE_EVENT = "BEGIN HAC_CORE.RECEIVE_EVENT(?); COMMIT; END;"
  private val PROCEDURE_LOAD_DEVICE_SETTINGS = "BEGIN HAC_CORE.LOAD_DEVICE_SETTINGS(?,?,?,?,?); END;"

  private def sendHikvisionRequest(url: URL, requestPath: String, partnerKey: String, partnerSecret: String, requestData: JSONObject): String = {
    var conn: HttpURLConnection = null

    try {
      conn = HikvisionConnection.getHttpsConnection(url, requestPath, partnerKey, partnerSecret)

      val out = conn.getOutputStream
      out.write(requestData.toString.getBytes(StandardCharsets.UTF_8))
      out.flush()
      out.close()

      if (conn.getResponseCode == HttpURLConnection.HTTP_OK) {
        Source.fromInputStream(conn.getInputStream)(Codec.UTF8).mkString
      }
      else {
        if (conn.getErrorStream != null) {
          throw new RuntimeException(Source.fromInputStream(conn.getErrorStream)(Codec.UTF8).mkString)
        } else {
          throw new RuntimeException("Hikvision response error status code = " + conn.getResponseCode)
        }
      }
    }
    finally {
      if (conn != null) conn.disconnect()
    }
  }

  private def authenticateHikServlet(token: String): (String, String, String, String) = {
    var conn: OracleConnection = null
    var cs: OracleCallableStatement = null
    var serverId = ""
    var hostUrl = ""
    var partnerKey = ""
    var partnerSecret = ""

    try {
      conn = DBConnection.getPoolConnection
      cs = conn.prepareCall(PROCEDURE_AUTHENTICATE_HIK_SERVLET).asInstanceOf[OracleCallableStatement]
      cs.setString(1, token)
      cs.registerOutParameter(2, OracleTypes.NUMBER)
      cs.registerOutParameter(3, OracleTypes.VARCHAR)
      cs.registerOutParameter(4, OracleTypes.VARCHAR)
      cs.registerOutParameter(5, OracleTypes.VARCHAR)

      cs.execute()
      serverId = cs.getString(2)
      hostUrl = cs.getString(3)
      partnerKey = cs.getString(4)
      partnerSecret = cs.getString(5)
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
        saveLog("HikvisionServlet -> authenticateHikServlet: token -> " + token, ex.getMessage)
        return (serverId, hostUrl, partnerKey, partnerSecret)
    } finally {
      if (cs != null) cs.close()
      if (conn != null) conn.close()
    }

    (serverId, hostUrl, partnerKey, partnerSecret)
  }

  private def sendEvent(requestBody: JSONObject): Unit = {
    var conn: OracleConnection = null
    var cs: OracleCallableStatement = null

    try {
      conn = DBConnection.getPoolConnection
      cs = conn.prepareCall(PROCEDURE_RECEIVE_EVENT).asInstanceOf[OracleCallableStatement]
      cs.setArray(1, conn.createOracleArray("PUBLIC.ARRAY_VARCHAR2", splitChunks(requestBody.toString)))

      cs.execute()
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
        saveLog(JSON.stringify(requestBody), ex.getMessage)
    } finally {
      if (cs != null) cs.close()
      if (conn != null) conn.close()
    }
  }

  private def loadImage(picUri: String, hostUrl: String, partnerKey: String, partnerSecret: String): String = {
    if (picUri.isEmpty) return ""

    var picSha = ""

    try {
      val requestData = new JSONObject().put("url", picUri)
      val url = URI.create(hostUrl + HIKVISION_GET_ENCODED_PICTURE_FROM_URL).toURL
      val getPictureResponse: String = sendHikvisionRequest(url, HIKVISION_GET_ENCODED_PICTURE_FROM_URL, partnerKey, partnerSecret, requestData)

      val pictureBase64Data = getPictureResponse.split(",")(1)
      val pictureBytes = Base64.getDecoder.decode(pictureBase64Data)

      picSha = ImgUtil.uploadImageFromByteArray(pictureBytes)
    } catch {
      case ex: Exception =>
        val sw = new StringWriter
        val pw = new PrintWriter(sw)
        ex.printStackTrace(pw)
        saveLog("HikvisionServlet -> doPost: picUri -> " + picUri, ex.getMessage + "\n" + sw.toString)
        picSha = ""
    }

    picSha
  }

  private def loadDeviceSettings(serverId: String, doorCode: String): (Boolean, Boolean, Boolean) = {
    var conn: OracleConnection = null
    var cs: OracleCallableStatement = null

    try {
      conn = DBConnection.getPoolConnection
      cs = conn.prepareCall(PROCEDURE_LOAD_DEVICE_SETTINGS).asInstanceOf[OracleCallableStatement]
      cs.setString(1, serverId)
      cs.setString(2, doorCode)
      cs.registerOutParameter(3, OracleTypes.VARCHAR)
      cs.registerOutParameter(4, OracleTypes.VARCHAR)
      cs.registerOutParameter(5, OracleTypes.VARCHAR)

      cs.execute()

      val deviceExists = cs.getString(3) == "Y"
      val ignoreTracks = cs.getString(4) == "Y"
      val ignoreImages = cs.getString(5) == "Y"

      (deviceExists, ignoreTracks, ignoreImages)
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
        saveLog("HikvisionServlet->loadDeviceSettings: serverId:" + serverId + ", doorCode:" + doorCode, ex.getMessage)
        (false, true, true)
    } finally {
      if (cs != null) cs.close()
      if (conn != null) conn.close()
    }
  }

  override def doPost(req: HttpServletRequest, resp: HttpServletResponse): Unit = {
    try {
      val token = req.getHeader("token")
      val (serverId, hostUrl, partnerKey, partnerSecret) = authenticateHikServlet(token)

      if (serverId.nonEmpty) {
        val requestBody = new JSONObject(Source.fromInputStream(req.getInputStream).mkString)
        val events = requestBody.getJSONObject("params").getJSONArray("events")

        for (i <- 0 until events.length()) {
          val event = events.getJSONObject(i)
          val eventExtraData = event.getJSONObject("data")
          val picUri = eventExtraData.getString("picUri")

          val (deviceExists, ignoreTracks, ignoreImages) = loadDeviceSettings(serverId, event.optString("srcIndex", ""))

          if (picUri.nonEmpty && !ignoreImages) {
            val picSha = loadImage(picUri, hostUrl, partnerKey, partnerSecret)

            eventExtraData.put("picSha", picSha)
          }

          if (deviceExists && !ignoreTracks) {
            event.put("serverId", serverId)
            sendEvent(event)
          }
        }
      }
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
        saveLog("HikvisionServlet -> doPost", ex.getMessage)
    }
  }

}