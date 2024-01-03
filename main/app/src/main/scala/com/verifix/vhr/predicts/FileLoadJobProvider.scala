package com.verifix.vhr.predicts

import org.json.{JSONArray, JSONObject}
import uz.greenwhite.biruni.jobs.{JobProvider, JobResult}
import uz.greenwhite.biruni.json.JSON

class FileLoadJobProvider extends JobProvider {
  override def run(requestData: String): JobResult = {
    if (requestData == null || requestData.isEmpty) return JobResult(400, "FileLoadJobProvider: Request data is empty")

    try {
      val arr = JSON.parseSeqForce(requestData)
      val ftpService = new FtpFileLoadService()
      val resultList = new JSONArray()

      arr.foreach(
        x => {
          val obj = x.asInstanceOf[Map[String, Any]]
          val ftpResult = ftpService.run(obj("detail").asInstanceOf[Map[String, Any]], JSON.stringify(obj("request_data")))
          val result = new JSONObject()

          result.put("review_data", new JSONObject(ftpResult.reviewData))
          result.put("files", new JSONArray(ftpResult.output))

          resultList.put(result)
        }
      )

      JobResult(200, resultList.toString)
    } catch {
      case e: Exception =>
        e.printStackTrace()
        JobResult(500, "FileLoadJobProvider: " + e.getMessage)
    }
  }
}
