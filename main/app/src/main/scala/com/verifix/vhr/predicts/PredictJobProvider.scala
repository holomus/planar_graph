package com.verifix.vhr.predicts

import com.verifix.vhr.AcmsUtil.{gatherChunks, splitChunks}
import oracle.jdbc.{OracleCallableStatement, OracleConnection, OracleTypes}
import uz.greenwhite.biruni.connection.DBConnection
import uz.greenwhite.biruni.jobs.{JobProvider, JobResult}
import uz.greenwhite.biruni.json.JSON

class PredictJobProvider extends JobProvider {
  private def loadFacts(companyId: Int, filialId: Int, objectId: Int, predictType: String): String = {
    var conn: OracleConnection = null
    var cs: OracleCallableStatement = null

    try {
      val statement = "BEGIN HSC_JOB.LOAD_OBJECT_FACTS(?,?,?,?,?); COMMIT; END;"
      conn = DBConnection.getPoolConnection
      cs = conn.prepareCall(statement).asInstanceOf[OracleCallableStatement]
      cs.setInt(1, companyId)
      cs.setInt(2, filialId)
      cs.setInt(3, objectId)
      cs.setString(4, predictType)
      cs.registerOutParameter(5, OracleTypes.ARRAY, "PUBLIC.ARRAY_VARCHAR2")
      cs.execute()

      gatherChunks(cs.getArray(5).getArray.asInstanceOf[Array[String]])
    } finally {
      if (cs != null) cs.close()
      if (conn != null) conn.close()
    }
  }

  private def savePredicts(companyId: Int, filialId: Int, objectId: Int, predictData: String): Unit = {
    var conn: OracleConnection = null
    var cs: OracleCallableStatement = null

    try {
      val statement = "BEGIN HSC_JOB.SAVE_OBJECT_FACTS(?,?,?,?); COMMIT; END;"
      conn = DBConnection.getPoolConnection
      cs = conn.prepareCall(statement).asInstanceOf[OracleCallableStatement]
      cs.setInt(1, companyId)
      cs.setInt(2, filialId)
      cs.setInt(3, objectId)
      cs.setArray(4, conn.createOracleArray("PUBLIC.ARRAY_VARCHAR2", splitChunks(predictData)))
      cs.execute()
    } finally {
      if (cs != null) cs.close()
      if (conn != null) conn.close()
    }
  }

  private def predictObject(companyId: Int,
                            filialId: Int,
                            objectId: Int,
                            predictType: String,
                            details: Map[String, Any],
                            service: PredictRuntimeService): Unit = {
    try {
      val facts = loadFacts(companyId, filialId, objectId, predictType)

      val result = service.run(details, facts)

      if (!result.isSuccess) throw new Exception(result.output)

      savePredicts(companyId, filialId, objectId, result.output)
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
    }
  }

  override def run(requestData: String): JobResult = {
    if (requestData == null || requestData.isEmpty) return JobResult(400, "PredictJobProvider: Request data is empty")

    try {
      val arr = JSON.parseSeqForce(requestData)
      val predictService = new PredictRuntimeService()

      arr.foreach(
        x => {
          val companyData = x.asInstanceOf[Map[String, Any]]
          val objects = companyData("object_ids").asInstanceOf[List[String]]
          val companyId = companyData("company_id").asInstanceOf[String].toInt
          val filialId = companyData("filial_id").asInstanceOf[String].toInt
          val predictType = companyData("predict_type").asInstanceOf[String]
          val details = companyData("detail").asInstanceOf[Map[String, Any]]

          objects.foreach(
            id => {
              predictObject(companyId, filialId, id.toInt, predictType, details, predictService)
            }
          )
        }
      )

      JobResult(200, "")
    } catch {
      case e: Exception =>
        e.printStackTrace()
        JobResult(500, "PredictJobProvider: " + e.getMessage)
    }
  }
}
