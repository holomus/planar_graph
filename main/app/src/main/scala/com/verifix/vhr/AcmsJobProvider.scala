package com.verifix.vhr

import com.verifix.vhr.AcmsUtil.{saveLog, splitChunks}
import com.verifix.vhr.dahua.DahuaRuntimeService
import com.verifix.vhr.hikvision.HikvisionRuntimeService
import oracle.jdbc.{OracleCallableStatement, OracleConnection}
import org.json.{JSONArray, JSONObject}
import uz.greenwhite.biruni.connection.DBConnection
import uz.greenwhite.biruni.jobs.{JobProvider, JobResult}
import uz.greenwhite.biruni.json.JSON
import uz.greenwhite.biruni.service.runtimeservice.RuntimeService

import java.net.HttpURLConnection

class AcmsJobProvider extends JobProvider {
  private def nonEmpty(jsonArr: JSONArray): Boolean = jsonArr != null && !jsonArr.isEmpty

  private def saveTracks(companyId: Int, procedureName: String, companyData: JSONObject): Unit = {
    var conn: OracleConnection = null
    var cs: OracleCallableStatement = null

    try {
      val statement = "BEGIN " + procedureName + "(?); COMMIT; END;"
      conn = DBConnection.getPoolConnection
      cs = conn.prepareCall(statement).asInstanceOf[OracleCallableStatement]
      cs.setArray(1, conn.createOracleArray("PUBLIC.ARRAY_VARCHAR2", splitChunks(companyData.toString)))

      cs.execute()
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
        saveLog("AcmsJobProvider:companyId:" + companyId + ":saveTracks", ex.getMessage)
    } finally {
      if (cs != null) cs.close()
      if (conn != null) conn.close()
    }
  }

  private def paginatedRequest(companyId: Int,
                               companyData: JSONObject,
                               iteratorKey: String,
                               tracksKey: String,
                               acmsService: RuntimeService): JSONArray = {
    val tracks = new JSONArray()

    try {
      val detail = JSON.parseForce(companyData.getJSONObject("detail").toString)
      val data = companyData.getJSONObject("request_data")

      var maxLoop = 1000
      var itemCount = 1

      while (maxLoop > 0 && itemCount > 0) {
        val acmsResult = acmsService.run(detail, data.toString)
        if (acmsResult.isSuccess) {
          val resultOutput = new JSONObject(acmsResult.output)
          val resultTracks = resultOutput.optJSONArray(tracksKey)

          if (nonEmpty(resultTracks)) {
            tracks.putAll(resultTracks)
            itemCount = resultTracks.length()
          } else itemCount = -1

          data.increment(iteratorKey)
          maxLoop -= 1
        } else throw new Exception(acmsResult.output)
      }
    } catch {
      case e: Exception =>
        e.printStackTrace()
        saveLog("AcmsJobProvider:companyId:" + companyId + ":paginatedRequest", e.getMessage)
    }

    tracks
  }

  private def loadTracks(procedureName: String, companyList: JSONArray, acmsService: RuntimeService): Unit = {
    var i = 0
    while (i < companyList.length) {
      val companyData = companyList.getJSONObject(i)

      val hostUrl = companyData.getString("host_url")
      val serverId = companyData.getString("server_id")
      val companyId = companyData.getInt("company_id")
      val iteratorKey = companyData.getString("iterator_key")
      val tracksKey = companyData.getString("tracks_key")

      val companyResult = new JSONObject()
      val companyTracks = paginatedRequest(companyId, companyData, iteratorKey, tracksKey, acmsService)

      if (nonEmpty(companyTracks)) {
        companyResult.put("host_url", hostUrl)
        companyResult.put("server_id", serverId)
        companyResult.put("tracks", companyTracks)

        saveTracks(companyId, procedureName, companyResult)
      }
      i += 1
    }
  }

  override def run(requestData: String): JobResult = {
    if (requestData == null || requestData.isEmpty) return JobResult(HttpURLConnection.HTTP_BAD_REQUEST, "AcmsJobProvider: Request data is empty")

    try {
      val data = new JSONObject(requestData)
      val dahuaData = data.optJSONArray("dahua")
      val hikData = data.optJSONArray("hik")
      val dahuaProcedure = data.optString("dahua_procedure", "")
      val hikProcedure = data.optString("hik_procedure", "")

      if (nonEmpty(dahuaData) && nonEmpty(hikData)) throw new Exception("cannot execute dahua and hikvision simultaneously")

      if (nonEmpty(dahuaData)) loadTracks(dahuaProcedure, dahuaData, new DahuaRuntimeService())
      if (nonEmpty(hikData)) loadTracks(hikProcedure, hikData, new HikvisionRuntimeService())

      JobResult(HttpURLConnection.HTTP_OK, "")
    } catch {
      case e: Exception =>
        e.printStackTrace()
        JobResult(HttpURLConnection.HTTP_INTERNAL_ERROR, "AcmsJobProvider: " + e.getMessage)
    }
  }
}
