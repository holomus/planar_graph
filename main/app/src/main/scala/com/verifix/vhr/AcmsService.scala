package com.verifix.vhr

import com.verifix.vhr.AcmsUtil.{gatherChunks, saveLog}
import com.verifix.vhr.ImgUtil.loadBase64EncodedCroppedImage
import com.verifix.vhr.dahua.{DahuaService, DahuaUtil}
import com.verifix.vhr.hikvision.HikvisionConnection
import oracle.jdbc.{OracleCallableStatement, OracleConnection, OracleTypes}
import org.json.{JSONArray, JSONObject}
import uz.greenwhite.biruni.connection.DBConnection
import uz.greenwhite.biruni.json.JSON

import java.net.{HttpURLConnection, URI, URL}
import java.nio.charset.StandardCharsets
import scala.io.{Codec, Source}

class AcmsService {
  private val DAHUA_RESPONSE_SUCCESS = 1000
  private val HIKVISION_RESPONSE_SUCCESS = "0"
  private val HIKVISION_RESPONSE_PERSON_NOT_EXISTS = "128"
  private val DAHUA_PERSON_API_URI = "/obms/api/v1.1/acs/person"
  private val DAHUA_PERSON_ATTACH_URI = "/obms/api/v1.1/acs/access-group/person/authorize"
  private val DAHUA_PERSON_DETACH_URI = "/obms/api/v1.1/acs/access-group/person/unauthorize"
  private val HIKVISION_PERSON_GET_PERSON_INFO = "/artemis/api/resource/v1/person/personCode/personInfo"
  private val HIKVISION_PERSON_ADD_URI = "/artemis/api/resource/v1/person/single/add"
  private val HIKVISION_PERSON_UPDATE_URI = "/artemis/api/resource/v1/person/single/update"
  private val HIKVISION_PERSON_UPDATE_FACE_PICTURE_URI = "/artemis/api/resource/v1/person/face/update"
  private val HIKVISION_PERSON_ATTACH_URI = "/artemis/api/acs/v1/privilege/group/single/addPersons"
  private val HIKVISION_PERSON_DETACH_URI = "/artemis/api/acs/v1/privilege/group/single/deletePersons"
  private val HIKVISION_APPLY_CHANGES_TO_DEVICES = "/artemis/api/visitor/v1/auth/reapplication"
  private val LOCK_PERSON_INFO = "BEGIN HAC_CORE.LOCK_PERSON_INFO(?,?,?, ?); END;"
  private val UPDATE_PERSON_INFO = "BEGIN HAC_CORE.UPDATE_PERSON_INFO(?,?,?,?,?,?,?,?,?); END;"
  private val DEVICE_PERSONS_ATTACH = "BEGIN HAC_CORE.DEVICE_PERSONS_ATTACH(?,?,?,?); END;"
  private val DEVICE_PERSONS_DETACH = "BEGIN HAC_CORE.DEVICE_PERSONS_DETACH(?,?,?,?); END;"
  private val ANALYZE_PERSON_INFO_STATEMENT = "BEGIN HAC_CORE.ANALYZE_PERSON_INFO(?,?,?); END;"
  private val ANALYZE_ATTACHMENT_INFO_STATEMENT = "BEGIN HAC_CORE.ANALYZE_ATTACHMENT_INFO(?,?,?); END;"

  private case class Company(companyId: Int, personIds: List[String])

  private def parseCompaniesList(requestData: Any): List[Company] = {
    val companies = requestData.asInstanceOf[List[Map[String, Any]]]

    companies.map(x => {
      Company(
        Integer.parseInt(x.getOrElse("company_id", null).asInstanceOf[String]),
        x.getOrElse("person_ids", List.empty).asInstanceOf[List[String]]
      )
    })
  }

  private def getAuthToken(hostUrl: String, username: String, password: String): String = {
    val authResult = DahuaService.getToken(hostUrl, username, password)

    if (authResult.isInvalid)
      throw new RuntimeException("Dahua auth failed")

    authResult.getToken
  }

  private def runAttachmentProcedure(conn: OracleConnection, attachmentProcedure: String, attachmentData: Map[String, Any]): Unit = {
    var cs: OracleCallableStatement = null
    try {
      val personIds = attachmentData.getOrElse("person_ids", List.empty).asInstanceOf[List[String]]
      cs = conn.prepareCall(attachmentProcedure).asInstanceOf[OracleCallableStatement]

      cs.setInt(1, Integer.parseInt(attachmentData.getOrElse("server_id", "").asInstanceOf[String]))
      cs.setInt(2, Integer.parseInt(attachmentData.getOrElse("company_id", "").asInstanceOf[String]))
      cs.setInt(3, Integer.parseInt(attachmentData.getOrElse("device_id", "").asInstanceOf[String]))
      cs.setArray(4, conn.createOracleArray("PUBLIC.ARRAY_VARCHAR2", personIds.toArray))

      cs.execute()
    }
    finally {
      if (cs != null) cs.close()
    }
  }

  private def runPersonInfoProcedure(conn: OracleConnection,
                                     personInfoProcedure: String,
                                     personResponses: Map[String, String],
                                     externalCode: String,
                                     requestData: Map[String, Any] = Map.empty,
                                     personCode: String = ""): Unit = {
    var cs: OracleCallableStatement = null

    try {
      cs = conn.prepareCall(personInfoProcedure).asInstanceOf[OracleCallableStatement]

      cs.setInt(1, Integer.parseInt(personResponses.getOrElse("server_id", "")))
      cs.setInt(2, Integer.parseInt(personResponses.getOrElse("company_id", "")))
      cs.setInt(3, Integer.parseInt(personResponses.getOrElse("person_id", "")))
      cs.setString(4, externalCode)

      if (personInfoProcedure == UPDATE_PERSON_INFO) {
        cs.setString(5, requestData.getOrElse("first_name", "").asInstanceOf[String])
        cs.setString(6, requestData.getOrElse("last_name", "").asInstanceOf[String])
        cs.setString(7, requestData.getOrElse("photo_sha", "").asInstanceOf[String])
        cs.setString(8, requestData.getOrElse("rfid_code", "").asInstanceOf[String])
        cs.setString(9, personCode)
      }

      cs.execute()
    }
    finally {
      if (cs != null) cs.close()
    }
  }

  private def runAnalyzeProcedure(conn: OracleConnection, procedureStatement: String, companyId: Int, personIds: List[String]): Map[String, Any] = {
    var cs: OracleCallableStatement = null
    try {
      cs = conn.prepareCall(procedureStatement).asInstanceOf[OracleCallableStatement]

      cs.setInt(1, companyId)
      cs.setArray(2, conn.createOracleArray("PUBLIC.ARRAY_VARCHAR2", personIds.toArray))

      cs.registerOutParameter(3, OracleTypes.ARRAY, "PUBLIC.ARRAY_VARCHAR2")

      cs.execute()

      JSON.parseForce(gatherChunks(cs.getArray(3).getArray.asInstanceOf[Array[String]]))
    }
    finally {
      if (cs != null) cs.close()
    }
  }

  private def sendDahuaRequest(url: String, method: String, token: String, requestData: JSONObject): JSONObject = {
    var conn: HttpURLConnection = null

    try {
      conn = DahuaUtil.getConnection(
        url, method, token, requestData)

      if (conn.getResponseCode == HttpURLConnection.HTTP_OK) {
        val response = new JSONObject(Source.fromInputStream(conn.getInputStream)(Codec.UTF8).mkString)
        if (response.getInt("code") == DAHUA_RESPONSE_SUCCESS) {
          response
        }
        else {
          throw new RuntimeException("Dahua error description:" + response.getString("desc"))
        }
      }
      else {
        if (conn.getErrorStream != null) {
          throw new RuntimeException(Source.fromInputStream(conn.getErrorStream)(Codec.UTF8).mkString)
        } else {
          throw new RuntimeException("Dahua response error status code = " + conn.getResponseCode)
        }
      }
    }
    finally {
      if (conn != null) conn.disconnect()
    }
  }

  private def sendHikvisionRequest(url: URL, requestPath: String, partnerKey: String, partnerSecret: String, requestData: JSONObject): JSONObject = {
    var conn: HttpURLConnection = null

    try {
      conn = HikvisionConnection.getHttpsConnection(url, requestPath, partnerKey, partnerSecret)

      val out = conn.getOutputStream
      out.write(requestData.toString.getBytes(StandardCharsets.UTF_8))
      out.flush()
      out.close()

      if (conn.getResponseCode == HttpURLConnection.HTTP_OK) {
        val response = new JSONObject(Source.fromInputStream(conn.getInputStream)(Codec.UTF8).mkString)
        if (response.getString("code") == HIKVISION_RESPONSE_SUCCESS || response.getString("code") == HIKVISION_RESPONSE_PERSON_NOT_EXISTS) {
          response
        }
        else {
          throw new RuntimeException("Hikvision error description:" + response.getString("msg"))
        }
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

  private def syncPersonDahua(dbConn: OracleConnection, hostUrl: String, token: String, personData: Map[String, Any]): Unit = {
    def buildRequestData(personData: Map[String, Any]): JSONObject = {
      val requestData = new JSONObject()
      var infos = new JSONObject()

      val photoSha = personData.getOrElse("photo_sha", "").asInstanceOf[String]
      val facePictures = new JSONArray()

      val accessGroups = personData.getOrElse("access_groups", List.empty).asInstanceOf[List[String]]

      if (photoSha.nonEmpty)
        facePictures.put(loadBase64EncodedCroppedImage(photoSha))

      infos.put("personId", personData.getOrElse("person_id", "").asInstanceOf[String])
      infos.put("firstName", personData.getOrElse("first_name", "").asInstanceOf[String])
      infos.put("lastName", personData.getOrElse("last_name", "").asInstanceOf[String])
      infos.put("orgCode", personData.getOrElse("person_group_code", "").asInstanceOf[String])
      infos.put("gender", 0)
      infos.put("email", "")
      infos.put("tel", "")
      infos.put("remark", "")
      infos.put("source", 0)
      infos.put("facePictures", facePictures)

      requestData.put("baseInfo", infos)

      infos = new JSONObject()
      infos.put("enableParkingSpace", 0)
      infos.put("enableEntranceGroup", 0)
      infos.put("parkingSpaceNum", 0)

      requestData.put("entranceInfo", infos)

      infos = new JSONObject()
      infos.put("allowLoginDevice", 0)
      infos.put("enableAccessGroup", if (accessGroups.nonEmpty) 1 else 0)
      if (accessGroups.nonEmpty)
        infos.put("accessGroupIds", accessGroups.toArray)

      requestData.put("accessInfo", infos)

      infos = new JSONObject()
      infos.put("enableFaceComparisonGroup", 0)

      requestData.put("faceComparisonInfo", infos)

      infos = new JSONObject()

      infos.put("startTime", personData.getOrElse("start_time", "").asInstanceOf[String])
      infos.put("endTime", personData.getOrElse("end_time", "").asInstanceOf[String])

      val cards = new JSONArray()
      val rfidCode = personData.getOrElse("rfid_code", "").asInstanceOf[String]

      if (rfidCode.nonEmpty) {
        val card = new JSONObject()

        card.put("cardNo", rfidCode)
        card.put("mainFlag", 1)
        card.put("duressFlag", 0)

        cards.put(card)
      }

      infos.put("cards", cards)

      requestData.put("authenticationInfo", infos)

      infos = new JSONObject()
      infos.put("enableLiftPermission", 0)

      requestData.put("liftInfo", infos)
    }

    def dahuaPersonExists(personCode: String): Boolean = {
      try {
        if (personCode.isEmpty) return false
        val url = hostUrl + DAHUA_PERSON_API_URI + "/" + personCode
        val method = "GET"

        sendDahuaRequest(url, method, token, null)

        true
      } catch {
        case _: Exception =>
          false
      }
    }

    try {
      val personCode = personData.getOrElse("person_code", "").asInstanceOf[String]
      val personId = personData.getOrElse("person_id", "").asInstanceOf[String]
      val personExists = dahuaPersonExists(personCode)
      val method = if (!personExists) "POST" else "PUT"
      val objectId = if (!personExists) "" else "/" + personCode
      val url = hostUrl + DAHUA_PERSON_API_URI + objectId
      val requestData = buildRequestData(personData)

      runPersonInfoProcedure(dbConn, LOCK_PERSON_INFO, personData.getOrElse("response_data", Map.empty).asInstanceOf[Map[String, String]], "")

      sendDahuaRequest(url, method, token, requestData)

      runPersonInfoProcedure(dbConn, UPDATE_PERSON_INFO, personData.getOrElse("response_data", Map.empty).asInstanceOf[Map[String, String]], "", personData, personId)

      dbConn.commit()
    }
    catch {
      case ex: Exception =>
        dbConn.rollback()
        ex.printStackTrace()
        saveLog(JSON.stringify(personData), ex.getMessage)
    }
  }

  private def syncPersonHikvision(dbConn: OracleConnection, hostUrl: String, partnerKey: String, partnerSecret: String, personData: Map[String, Any]): Unit = {
    var personCode = personData.getOrElse("person_code", "").asInstanceOf[String]
    val externalCode = personData.getOrElse("external_code", "").asInstanceOf[String]
    val photoSha = personData.getOrElse("photo_sha", "").asInstanceOf[String]
    var personExists = false

    def buildCheckExternalCodeData(): JSONObject = {
      val requestData = new JSONObject()
      requestData.put("personCode", externalCode)
      requestData
    }

    def buildAddUpdateRequestData(personData: Map[String, Any]): JSONObject = {
      val requestData = new JSONObject()
      val cards = new JSONArray()
      val rfidCode = personData.getOrElse("rfid_code", "").asInstanceOf[String]

      requestData.put("personId", personCode)
      requestData.put("personCode", externalCode)
      requestData.put("personGivenName", personData.getOrElse("first_name", "").asInstanceOf[String])
      requestData.put("personFamilyName", personData.getOrElse("last_name", "").asInstanceOf[String])

      if (rfidCode.nonEmpty) {
        val card = new JSONObject()

        card.put("cardNo", rfidCode)

        cards.put(card)
      }

      requestData.put("cards", cards)

      if (!personExists) {
        val faces = new JSONArray()
        val face0 = new JSONObject()

        if (photoSha.nonEmpty)
          face0.put("faceData", loadBase64EncodedCroppedImage(photoSha))
        faces.put(face0)
        requestData.put("faces", faces)

        requestData.put("orgIndexCode", personData.getOrElse("organization_code", "").asInstanceOf[String])
        requestData.put("beginTime", personData.getOrElse("begin_time", "").asInstanceOf[String])
        requestData.put("endTime", personData.getOrElse("end_time", "").asInstanceOf[String])
      }

      requestData
    }

    def buildUpdateFacePictureRequestData(photoSha: String): JSONObject = {
      val requestData = new JSONObject()

      requestData.put("personId", personCode)

      if (photoSha.nonEmpty)
        requestData.put("faceData", loadBase64EncodedCroppedImage(photoSha))

      requestData
    }

    try {
      val requestPath = HIKVISION_PERSON_GET_PERSON_INFO
      val url = URI.create(hostUrl + requestPath).toURL
      val requestData = buildCheckExternalCodeData()

      val checkExternalCodeResponse = sendHikvisionRequest(url, requestPath, partnerKey, partnerSecret, requestData)

      if (checkExternalCodeResponse.getString("code") != HIKVISION_RESPONSE_PERSON_NOT_EXISTS) {
        personExists = true
        personCode = checkExternalCodeResponse.getJSONObject("data").getString("personId")
      }

      runPersonInfoProcedure(dbConn, LOCK_PERSON_INFO, personData.getOrElse("response_data", Map.empty).asInstanceOf[Map[String, String]], externalCode)

      if (personExists) {
        val requestPath = HIKVISION_PERSON_UPDATE_URI
        var url = URI.create(hostUrl + requestPath).toURL
        var requestData = buildAddUpdateRequestData(personData)

        sendHikvisionRequest(url, requestPath, partnerKey, partnerSecret, requestData)

        if (photoSha.nonEmpty) {
          requestData = buildUpdateFacePictureRequestData(photoSha)
          url = URI.create(hostUrl + HIKVISION_PERSON_UPDATE_FACE_PICTURE_URI).toURL
          sendHikvisionRequest(url, HIKVISION_PERSON_UPDATE_FACE_PICTURE_URI, partnerKey, partnerSecret, requestData)
        }
      } else {
        val requestPath = HIKVISION_PERSON_ADD_URI
        val url = URI.create(hostUrl + requestPath).toURL
        val requestData = buildAddUpdateRequestData(personData)

        val addResponse = sendHikvisionRequest(url, requestPath, partnerKey, partnerSecret, requestData)
        personCode = addResponse.getString("data")
      }

      runPersonInfoProcedure(dbConn, UPDATE_PERSON_INFO, personData.getOrElse("response_data", Map.empty).asInstanceOf[Map[String, String]], externalCode, personData, personCode)

      dbConn.commit()
    }
    catch {
      case ex: Exception =>
        dbConn.rollback()
        ex.printStackTrace()
        saveLog(JSON.stringify(personData), ex.getMessage)
    }
  }

  private def syncPersonsDahua(conn: OracleConnection, dahuaData: Map[String, Any]): Unit = {
    val hostUrl = dahuaData.getOrElse("host_url", "").asInstanceOf[String]
    val username = dahuaData.getOrElse("username", "").asInstanceOf[String]
    val password = dahuaData.getOrElse("password", "").asInstanceOf[String]
    val personInfos = dahuaData.getOrElse("persons", List.empty).asInstanceOf[List[Map[String, String]]]

    if (hostUrl.isEmpty || username.isEmpty || password.isEmpty)
      return

    val token = getAuthToken(hostUrl, username, password)

    for {
      personInfo <- personInfos
    } syncPersonDahua(conn, hostUrl, token, personInfo)
  }

  private def syncPersonsHikvision(conn: OracleConnection, hikvisionData: Map[String, Any]): Unit = {
    val hostUrl = hikvisionData.getOrElse("host_url", "").asInstanceOf[String]
    val partnerKey = hikvisionData.getOrElse("partner_key", "").asInstanceOf[String]
    val partnerSecret = hikvisionData.getOrElse("partner_secret", "").asInstanceOf[String]
    val personInfos = hikvisionData.getOrElse("persons", List.empty).asInstanceOf[List[Map[String, Any]]]

    if (hostUrl.isEmpty || partnerKey.isEmpty || partnerSecret.isEmpty)
      return

    for {
      personInfo <- personInfos
    } syncPersonHikvision(conn, hostUrl, partnerKey, partnerSecret, personInfo)
  }

  private def attachPersonsDahua(dbConn: OracleConnection, hostUrl: String, token: String, attachmentData: Map[String, Any], isAttachment: Boolean): Unit = {
    try {
      val attachmentUri = if (isAttachment) DAHUA_PERSON_ATTACH_URI else DAHUA_PERSON_DETACH_URI
      val attachmentProcedure = if (isAttachment) DEVICE_PERSONS_ATTACH else DEVICE_PERSONS_DETACH
      val url = hostUrl + attachmentUri
      val requestData = new JSONObject()

      requestData.put("accessGroupId", attachmentData.getOrElse("access_group_code", "").asInstanceOf[String])
      requestData.put("personIds", attachmentData.getOrElse("person_codes", List.empty).asInstanceOf[List[String]].toArray)

      if (isAttachment)
        requestData.put("personOrgCodes", Array.empty)

      runAttachmentProcedure(dbConn, attachmentProcedure, attachmentData.getOrElse("response_data", Map.empty).asInstanceOf[Map[String, Any]])

      sendDahuaRequest(url, "POST", token, requestData)

      dbConn.commit()
    }
    catch {
      case ex: Exception =>
        dbConn.rollback()
        saveLog(JSON.stringify(attachmentData), ex.getMessage)
    }
  }

  private def attachPersonsHikvision(dbConn: OracleConnection, hostUrl: String, partnerKey: String, partnerSecret: String, attachmentData: Map[String, Any], isAttachment: Boolean): Unit = {
    try {
      val attachmentUri = if (isAttachment) HIKVISION_PERSON_ATTACH_URI else HIKVISION_PERSON_DETACH_URI
      val url = URI.create(hostUrl + attachmentUri).toURL
      val attachmentProcedure = if (isAttachment) DEVICE_PERSONS_ATTACH else DEVICE_PERSONS_DETACH
      val requestData = new JSONObject()
      val ACCESS_LEVEL_TYPE = 1

      requestData.put("privilegeGroupId", attachmentData.getOrElse("access_level_code", "").asInstanceOf[String])
      requestData.put("type", ACCESS_LEVEL_TYPE)

      val personCodes = attachmentData.getOrElse("person_codes", List.empty).asInstanceOf[List[String]].toArray
      val personsJSONArray = personCodes.map(personCode => {
        val result = new JSONObject()
        result.put("id", personCode)
        result
      })
      requestData.put("list", personsJSONArray)

      runAttachmentProcedure(dbConn, attachmentProcedure, attachmentData.getOrElse("response_data", Map.empty).asInstanceOf[Map[String, Any]])

      sendHikvisionRequest(url, attachmentUri, partnerKey, partnerSecret, requestData)

      dbConn.commit()
    }
    catch
    {
      case ex: Exception =>
        dbConn.rollback()
        saveLog(JSON.stringify(attachmentData), ex.getMessage)
    }
  }

  private def applyChangesToDevicesHikvision(hostUrl: String, partnerKey: String, partnerSecret: String): Unit = {
    val url = URI.create(hostUrl + HIKVISION_APPLY_CHANGES_TO_DEVICES).toURL
    val requestData = new JSONObject()
    sendHikvisionRequest(url, HIKVISION_APPLY_CHANGES_TO_DEVICES, partnerKey, partnerSecret, requestData)
  }

  private def syncAttachmentsDahua(dbConn: OracleConnection, dahuaData: Map[String, Any]): Unit = {
    val hostUrl = dahuaData.getOrElse("host_url", "").asInstanceOf[String]
    val username = dahuaData.getOrElse("username", "").asInstanceOf[String]
    val password = dahuaData.getOrElse("password", "").asInstanceOf[String]
    val attachment_groups = dahuaData.getOrElse("attachment_info", List.empty).asInstanceOf[List[Map[String, Any]]]
    val detachment_groups = dahuaData.getOrElse("detachment_info", List.empty).asInstanceOf[List[Map[String, Any]]]

    if (hostUrl.isEmpty || username.isEmpty || password.isEmpty)
      return

    val token = getAuthToken(hostUrl, username, password)

    for {
      group <- attachment_groups
    } attachPersonsDahua(dbConn, hostUrl, token, group, isAttachment = true)
    for {
      group <- detachment_groups
    } attachPersonsDahua(dbConn, hostUrl, token, group, isAttachment = false)
  }

  private def syncAttachmentsHikvision(dbConn: OracleConnection, hikvisionData: Map[String, Any]): Unit = {
    val hostUrl = hikvisionData.getOrElse("host_url", "").asInstanceOf[String]
    val partnerKey = hikvisionData.getOrElse("partner_key", "").asInstanceOf[String]
    val partnerSecret = hikvisionData.getOrElse("partner_secret", "").asInstanceOf[String]
    val attachment_groups = hikvisionData.getOrElse("attachment_info", List.empty).asInstanceOf[List[Map[String, Any]]]
    val detachment_groups = hikvisionData.getOrElse("detachment_info", List.empty).asInstanceOf[List[Map[String, Any]]]

    if (hostUrl.isEmpty || partnerKey.isEmpty || partnerSecret.isEmpty)
      return

    for {
      group <- attachment_groups
    } attachPersonsHikvision(dbConn, hostUrl, partnerKey, partnerSecret, group, isAttachment = true)
    for {
      group <- detachment_groups
    } attachPersonsHikvision(dbConn, hostUrl, partnerKey, partnerSecret, group, isAttachment = false)

    applyChangesToDevicesHikvision(hostUrl, partnerKey, partnerSecret)
  }

  private def syncPersons(companyId: Int, personIds: List[String]): Unit = {
    val conn: OracleConnection = DBConnection.getPoolConnection

    try {
      conn.setAutoCommit(false)

      val personRequestData = runAnalyzeProcedure(conn, ANALYZE_PERSON_INFO_STATEMENT, companyId, personIds)

      var dahuaData = personRequestData.getOrElse("dahua_data", Map.empty).asInstanceOf[Map[String, Any]]
      var hikvisionData = personRequestData.getOrElse("hikvision_data", Map.empty).asInstanceOf[Map[String, Any]]

      syncPersonsDahua(conn, dahuaData)
      syncPersonsHikvision(conn, hikvisionData)

      val attachmentRequestData = runAnalyzeProcedure(conn, ANALYZE_ATTACHMENT_INFO_STATEMENT, companyId, personIds)

      dahuaData = attachmentRequestData.getOrElse("dahua_data", Map.empty).asInstanceOf[Map[String, Any]]
      hikvisionData = attachmentRequestData.getOrElse("hikvision_data", Map.empty).asInstanceOf[Map[String, Any]]

      if (dahuaData.nonEmpty)
        syncAttachmentsDahua(conn, dahuaData)
      if (hikvisionData.nonEmpty)
        syncAttachmentsHikvision(conn, hikvisionData)

      conn.commit()
    }
    catch {
      case ex: Exception =>
        conn.rollback()
        saveLog("AcmsFinalService.syncPersons", ex.getMessage)
        throw ex
    }
    finally {
      conn.close()
    }
  }

  def run(data: Seq[Any]): Unit = {
    val companies = data.flatMap(parseCompaniesList)

    for {
      company <- companies
      if company.companyId > 0
    } syncPersons(company.companyId, company.personIds)
  }
}
