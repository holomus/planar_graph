package com.verifix.vhr

import com.verifix.vhr.AcmsUtil.{saveLog, splitChunks}
import com.verifix.vhr.dahua.DahuaRuntimeService
import com.verifix.vhr.hikvision.HikvisionRuntimeService
import org.json.{JSONArray, JSONObject}
import uz.greenwhite.biruni.jobs.{JobProvider, JobResult}
import uz.greenwhite.biruni.json.JSON
import uz.greenwhite.biruni.connection.DBConnection
import oracle.jdbc.{OracleCallableStatement, OracleConnection}
import uz.greenwhite.biruni.service.runtimeservice.RuntimeService

import java.net.HttpURLConnection

class DeviceUpdateJobProvider extends JobProvider {
  private val QUERY_PARAMS = "page=$1&pageSize=500&orderDirection=1"
  private val HIK_NUMBER = 1;
  private val DSS_NUMBER = 2;

  private def nonEmpty(jsonArr: JSONArray): Boolean = jsonArr != null && !jsonArr.isEmpty

  private def paginatedRequest(companyData: JSONObject,
                               iteratorKey: String,
                               deviceKey: String,
                               deviceService: RuntimeService,
                               deviceNumber: Int): JSONArray = {
    val devices = new JSONArray()

    try {
      val detail = new JSONObject(companyData.getJSONObject("detail").toString)
      val data = companyData.getJSONObject("request_data")

      var maxLoop = 1000
      var itemCount = 1
      var page = 1

      while (maxLoop > 0 && itemCount > 0) {
        if (deviceNumber == DSS_NUMBER) {
          detail.put("query_params", QUERY_PARAMS.replace("$1", page.toString))
        }

        val deviceResult = deviceService.run(JSON.parseForce(detail.toString), data.toString)
        if (deviceResult.isSuccess) {
          val resultOutput = new JSONObject(deviceResult.output)
          val resultDevices = resultOutput.optJSONArray(deviceKey)

          if (nonEmpty(resultDevices)) {
            devices.putAll(resultDevices)
            itemCount = resultDevices.length()
          } else itemCount = -1

          if (deviceNumber == HIK_NUMBER) {
            data.increment(iteratorKey)
          } else {
            page += 1
          }

          maxLoop -= 1
        } else throw new Exception(deviceResult.output)
      }
    } catch {
      case e: Exception =>
        e.printStackTrace()
        saveLog("DeviceUpdateJobProvider:paginatedRequest", e.getMessage)
    }

    devices
  }

  private def updateDevices(procedureName: String, companyData: JSONObject): Unit = {
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
        saveLog("DeviceUpdateJobProvider:updateDevices", ex.getMessage)
    } finally {
      if (cs != null) cs.close()
      if (conn != null) conn.close()
    }
  }

  private def loadDevices(procedureName: String, companyList: JSONArray, deviceService: RuntimeService, deviceNumber: Int): Unit = {
    var i = 0

    while (i < companyList.length) {
      val companyData = companyList.getJSONObject(i)

      val hostUrl = companyData.getString("host_url")
      val serverId = companyData.getString("server_id")
      val iteratorKey = companyData.getString("iterator_key")
      val deviceKey = companyData.getString("device_key")

      val companyResult = new JSONObject()
      val companyDevices = paginatedRequest(companyData, iteratorKey, deviceKey, deviceService, deviceNumber)

      if (nonEmpty(companyDevices)) {
        companyResult.put("host_url", hostUrl)
        companyResult.put("server_id", serverId)
        companyResult.put("devices", companyDevices)

        updateDevices(procedureName, companyResult)
      }
      i += 1
    }
  }

  override def run(requestData: String): JobResult = {
    if (requestData == null || requestData.isEmpty) return JobResult(HttpURLConnection.HTTP_BAD_REQUEST, "DeviceUpdateJobProvider: Request data is empty")

    try {
      val data = new JSONObject(requestData)
      val dahuaData = data.optJSONArray("dahua")
      val hikData = data.optJSONArray("hik")
      val dahuaProcedure = data.optString("dahua_procedure", "")
      val hikProcedure = data.optString("hik_procedure", "")

      if (nonEmpty(hikData)) loadDevices(hikProcedure, hikData, new HikvisionRuntimeService(), HIK_NUMBER)
      if (nonEmpty(dahuaData)) loadDevices(dahuaProcedure, dahuaData, new DahuaRuntimeService(), DSS_NUMBER)

      JobResult(HttpURLConnection.HTTP_OK, "")
    } catch {
      case e: Exception =>
        e.printStackTrace()
        JobResult(HttpURLConnection.HTTP_INTERNAL_ERROR, "DeviceUpdateJobProvider: " + e.getMessage)
    }
  }
}

