package com.verifix.vhr.facerecognition

import oracle.jdbc.OracleCallableStatement
import org.json.JSONArray
import uz.greenwhite.biruni.connection.DBConnection

import scala.collection.JavaConverters.asScalaBufferConverter

class RecognitionJob {
  private var companyId: Int = -1
  private var photoShas: List[String] = _
  private var url: String = ""
  private var method: String = ""
  private var username: String = ""
  private var password: String = ""
  private var invalid: Boolean = true
  private var th: Thread = _

  private def evalInvalid(): Unit = {
    invalid = companyId < 0 || photoShas == null || photoShas.isEmpty ||
              url.isEmpty || method.isEmpty || username.isEmpty || password.isEmpty
  }

  private def start(): Unit = {
    th = new Thread(new JobRun())
    th.start()
  }

  private def savePhotoVectorCalculated(companyId: Int,
                                        photoSha: String,
                                        photoVector: JSONArray): Unit = {
    var conn = DBConnection.getPoolConnection
    var cs: OracleCallableStatement = null

    try {
      val vectorArray = photoVector.toList.asScala.toArray.map(_.toString)

      val vector = conn.createOracleArray("PUBLIC.ARRAY_VARCHAR2", vectorArray)

      conn.setAutoCommit(false)

      val query = "BEGIN Hface_Core.Save_Photo_Vector_Calculated(?,?,?); END;"
      cs = conn.prepareCall(query).asInstanceOf[OracleCallableStatement]
      cs.setInt(1, companyId)
      cs.setString(2, photoSha)
      cs.setArray(3, vector)
      cs.execute

      conn.commit()
    } catch {
      case ex: Exception =>
        conn.rollback()
        println("Calculated vector save error. Error message " + ex.getMessage)
        throw ex
    } finally {
      if (cs != null) cs.close()
      conn.close()
      conn = null
    }
  }

  private def matchPhotos(): Unit = {
    var conn = DBConnection.getPoolConnection
    var cs: OracleCallableStatement = null

    try {
      conn.setAutoCommit(false)

      val query = "BEGIN Hface_Core.Match_Photos(?); END;"
      cs = conn.prepareCall(query).asInstanceOf[OracleCallableStatement]
      cs.setInt(1, companyId)
      cs.execute

      conn.commit()
    } catch {
      case ex: Exception =>
        conn.rollback()
        println("Match photos error. Error message " + ex.getMessage)
        throw ex
    } finally {
      if (cs != null) cs.close()
      conn.close()
      conn = null
    }
  }

  private class JobRun extends Runnable {
    override def run(): Unit = {
      try  {
        for {
          sha <- photoShas
          if sha != null && sha.nonEmpty
        } {
          try {
            val data = RecognitionService.calcPhotoVector(url, method, username, password, sha)

            val vector = data.optJSONArray("data")

            if (vector != null && !vector.isEmpty) savePhotoVectorCalculated(companyId, sha, vector)
          } catch {
            case ex: Exception =>
              println(ex.getMessage)
          }
        }
        matchPhotos()
      }
      catch {
        case ex: Exception =>
          println(ex.getMessage)
      } finally {
        if (Thread.currentThread.isAlive && !Thread.currentThread.isInterrupted)
          Thread.currentThread.interrupt()
        RecognitionJobController.removeRecognitionJob(companyId)
      }
    }
  }

  def isAlive: Boolean = {
    th != null && th.isAlive && !th.isInterrupted
  }

  def isValid: Boolean = !invalid

  def close(): Unit = {
    if (th.isAlive && !th.isInterrupted) th.interrupt()

    companyId = -1
    photoShas = List.empty
    url = ""
    method = ""
    username = ""
    password = ""

    evalInvalid()
  }
}

object RecognitionJob {
  def apply(companyId: Int, photoShas: List[String],
            url: String, method: String,
            username: String, password: String): RecognitionJob = {
    val job = new RecognitionJob()

    job.companyId = companyId
    job.photoShas = photoShas

    job.url = url
    job.method = method

    job.username = username
    job.password = password

    job.evalInvalid()

    if (job.invalid)
      return job

    job.start()

    job
  }
}