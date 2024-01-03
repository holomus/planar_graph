package com.verifix.vhr.facerecognition

import scala.collection.mutable

object RecognitionJobController {
  private val runningJobs: mutable.HashMap[Int, RecognitionJob] = new mutable.HashMap[Int, RecognitionJob]()

  def jobRunning(companyId: Int): Boolean = {
    runningJobs.contains(companyId) && runningJobs(companyId).isAlive
  }

  def addRecognitionJob(companyId: Int, photoShas: List[String],
                        url: String, method: String,
                        username: String, password: String): Unit = {
    if (jobRunning(companyId)) return

    val job = RecognitionJob(companyId, photoShas, url, method, username, password)

    if (job.isValid)
      runningJobs(companyId) = job
  }

  def removeRecognitionJob(companyId: Int): Unit = {
    if (!jobRunning(companyId)) runningJobs.remove(companyId).foreach{ x => x.close() }
  }
}
