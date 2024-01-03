package com.verifix.vhr.facerecognition

import org.json.JSONObject
import uz.greenwhite.biruni.json.JSON
import uz.greenwhite.biruni.service.runtimeservice.{ErrorRuntimeResult, RuntimeResult, RuntimeService, SuccessRuntimeResult}

import java.net.ConnectException

class RecognitionRuntimeService extends RuntimeService {
  private val CONNECTION_FAILURE_ERROR_CODE = "CF0001"
  private val ACTION_ADD_JOB = "ADD_JOB"
  private val ACTION_CHECK_JOB = "CHECK_JOB"
  private val ACTION_CALCULATE_VECTOR = "CALCULATE_VECTOR"

  private def addJob(companyId: Int, photoShas: List[String],
                     url: String, method: String,
                     username: String, password: String): RuntimeResult = {
    RecognitionJobController.addRecognitionJob(companyId, photoShas, url, method, username, password)
    SuccessRuntimeResult("success")
  }

  private def checkJob(companyId: Int): RuntimeResult = {
    val runningState = if (RecognitionJobController.jobRunning(companyId)) "Y" else "N"
    SuccessRuntimeResult(runningState)
  }

  private def calculateVector(url: String, method: String, username: String, password: String, photoShas: List[String]): RuntimeResult = {
    val data = new JSONObject()

    try {
      for {
        sha <- photoShas
        if sha != null && sha.nonEmpty
      } {

          val responseMap = RecognitionService.calcPhotoVector(url, method, username, password, sha)
          val vector = responseMap.optJSONArray("data")
          val error = responseMap.optString("error_code")

          if (vector != null && !vector.isEmpty) data.put(sha, vector)
          if (error != null && error.nonEmpty) data.put("error_code", error)
      }
    } catch {
      case _: ConnectException =>
        data.put("error_code", CONNECTION_FAILURE_ERROR_CODE)
    }

    SuccessRuntimeResult(data.toString)
  }

  override def run(detail: Map[String, Any], data: String): RuntimeResult = {
    try {
      val url = detail.getOrElse("url", "").asInstanceOf[String]
      val method = detail.getOrElse("method", "POST").asInstanceOf[String]
      val action = detail.getOrElse("action", "").asInstanceOf[String]

      val username = detail.getOrElse("username", "").asInstanceOf[String]
      val password = detail.getOrElse("password", "").asInstanceOf[String]

      val companyData = JSON.parseForce(data)

      val companyId = companyData.getOrElse("company_id", "").asInstanceOf[String]
      val photoShas = companyData.getOrElse("photo_shas", List.empty).asInstanceOf[List[String]]

      if (url.isEmpty) throw new RuntimeException("recognition url not provided")
      if (method.isEmpty) throw new RuntimeException("recognition http method not provided")
      if (action.isEmpty) throw new RuntimeException("recognition action not provided")

      if (username.isEmpty) throw new RuntimeException("recognition username not provided")
      if (password.isEmpty) throw new RuntimeException("recognition password not provided")

      if (companyId.isEmpty) throw new RuntimeException("recognition companyId not provided")

      action match {
        case ACTION_ADD_JOB if photoShas.nonEmpty =>
          addJob(companyId.toInt, photoShas, url, method, username, password)
        case ACTION_CHECK_JOB =>
          checkJob(companyId.toInt)
        case ACTION_CALCULATE_VECTOR if photoShas.nonEmpty =>
          calculateVector(url, method, username, password, photoShas)
        case _ => throw new RuntimeException("Unregistered recognition action")
      }
    } catch {
      case ex: Exception =>
        ErrorRuntimeResult(ex.getMessage)
    }
  }
}
