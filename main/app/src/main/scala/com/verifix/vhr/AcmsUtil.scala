package com.verifix.vhr

import oracle.jdbc.OracleCallableStatement
import uz.greenwhite.biruni.connection.DBConnection

object AcmsUtil {
  def gatherChunks(value: Array[String]): String = {
    value.foldLeft(new StringBuilder()) {
      (sb, line) =>
        if (line != null) sb.append(line)
        sb
    }.toString
  }

  def splitChunks(value: String): Array[String] = {
    if (value.length > 10000) value.grouped(10000).toArray
    else Array(value)
  }

  def saveLog(inputParams: String, errorMessage: String): Unit = {
    var conn = DBConnection.getPoolConnection
    var cs: OracleCallableStatement = null

    try {
      val query = "BEGIN HAC_CORE.SAVE_ERROR_LOG(?, ?); COMMIT; END;"
      cs = conn.prepareCall(query).asInstanceOf[OracleCallableStatement]

      cs.setString(1, inputParams)
      cs.setString(2, errorMessage.slice(0, 3000))

      cs.execute
    } catch {
      case ex: Exception => println(ex.getMessage)
    } finally {
      if (cs != null) cs.close()
      conn.close()
      conn = null
    }
  }
}
