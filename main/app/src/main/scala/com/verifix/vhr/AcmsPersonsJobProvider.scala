package com.verifix.vhr

import uz.greenwhite.biruni.jobs.{JobProvider, JobResult}
import uz.greenwhite.biruni.json.JSON

import java.net.HttpURLConnection

class AcmsPersonsJobProvider extends JobProvider {
  override def run(requestData: String): JobResult = {
    if (requestData == null || requestData.isEmpty) return JobResult(HttpURLConnection.HTTP_BAD_REQUEST, "AcmsPersonsJobProvider: Request data is empty")

    try {
      val data = JSON.parseSeqForce(requestData)
      val service = new AcmsService()

      service.run(data)

      JobResult(HttpURLConnection.HTTP_OK, "")
    } catch {
      case e: Exception =>
        e.printStackTrace()
        JobResult(HttpURLConnection.HTTP_INTERNAL_ERROR, "AcmsPersonsJobProvider: " + e.getMessage)
    }
  }
}
