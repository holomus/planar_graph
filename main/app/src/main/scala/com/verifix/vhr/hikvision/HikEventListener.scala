package com.verifix.vhr.hikvision

import com.verifix.vhr.AcmsUtil.{saveLog, splitChunks}
import com.verifix.vhr.ImgUtil
import jakarta.servlet.http.{HttpServlet, HttpServletRequest, HttpServletResponse}
import oracle.jdbc.{OracleCallableStatement, OracleConnection, OracleTypes}
import org.apache.tomcat.util.http.fileupload.MultipartStream
import uz.greenwhite.biruni.connection.DBConnection

import java.io.ByteArrayOutputStream
import java.net.HttpURLConnection
import java.nio.charset.StandardCharsets

class HikEventListener extends HttpServlet {
  private val PROCEDURE_RECEIVE_EVENT = "BEGIN HAC_CORE.RECEIVE_HIK_DEVICE_LISTENER_EVENT(?,?,?); COMMIT; END;"
  private val PROCEDURE_LOAD_DEVICE_SETTINGS = "BEGIN HAC_CORE.LOAD_LISTENING_DEVICE_SETTINGS(?,?,?); END;"

  private def setBadRequest(errortext: String, resp: HttpServletResponse): Unit = {
    resp.setStatus(HttpURLConnection.HTTP_BAD_REQUEST)
    resp.setCharacterEncoding(StandardCharsets.UTF_8.name)
    resp.setContentType("text/plain; charset=UTF-8")
    resp.getWriter.append(errortext)
  }

  private def saveTrack(token: String, data: String, picSha: String): Unit = {
    var conn: OracleConnection = null
    var cs: OracleCallableStatement = null

    try {
      conn = DBConnection.getPoolConnection
      cs = conn.prepareCall(PROCEDURE_RECEIVE_EVENT).asInstanceOf[OracleCallableStatement]
      cs.setString(1, token)
      cs.setString(2, picSha)
      cs.setArray(3, conn.createOracleArray("PUBLIC.ARRAY_VARCHAR2", splitChunks(data)))

      cs.execute()
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
        saveLog(data, ex.getMessage)
        throw ex
    } finally {
      if (cs != null) cs.close()
      if (conn != null) conn.close()
    }
  }

  private def loadDeviceSettings(deviceToken: String): (Boolean, Boolean) = {
    var conn: OracleConnection = null
    var cs: OracleCallableStatement = null

    try {
      conn = DBConnection.getPoolConnection
      cs = conn.prepareCall(PROCEDURE_LOAD_DEVICE_SETTINGS).asInstanceOf[OracleCallableStatement]
      cs.setString(1, deviceToken)
      cs.registerOutParameter(2, OracleTypes.VARCHAR)
      cs.registerOutParameter(3, OracleTypes.VARCHAR)

      cs.execute()

      val deviceExists = cs.getString(2) == "Y"
      val ignoreImages = cs.getString(3) == "Y"

      (deviceExists, ignoreImages)
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
        saveLog("HikvisionServlet->loadDeviceSettings: deviceToken:" + deviceToken, ex.getMessage)
        (false, true)
    } finally {
      if (cs != null) cs.close()
      if (conn != null) conn.close()
    }
  }

  override def doPost(req: HttpServletRequest, resp: HttpServletResponse): Unit = {
    var token = ""

    try {
      token = req.getParameter("token")

      val (deviceExists, ignoreImages) = loadDeviceSettings(token)

      if (!deviceExists)
        throw new Exception("Device with given token doesn't exist")

      val boundary = "MIME_boundary".getBytes
      val m = new MultipartStream(req.getInputStream, boundary, null)
      var nextPart = m.skipPreamble
      var body = ""
      var picSha = ""

      while (nextPart) {
        val header = m.readHeaders
        val bout = new ByteArrayOutputStream

        m.readBodyData(bout)

        nextPart = m.readBoundary()
        if (header.contains("name=\"event_log\"")) {
          body = bout.toString(StandardCharsets.UTF_8)
          if (picSha.nonEmpty || ignoreImages) nextPart = false
        } else if (header.contains("name=\"Picture\"") && !ignoreImages) {
          val pictureBytes = bout.toByteArray
          picSha = ImgUtil.uploadImageFromByteArray(pictureBytes)
          if (body.nonEmpty) nextPart = false
        }
      }

      saveTrack(token, body, picSha)

      resp.setStatus(HttpURLConnection.HTTP_OK)
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
        saveLog("HikEventListener: token=" + token, ex.getMessage)
        setBadRequest(ex.getMessage, resp)
    }
  }
}
