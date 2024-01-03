package com.verifix.vhr

import jakarta.servlet.http.HttpServletRequest
import uz.greenwhite.biruni.service.finalservice.FinalService

class AcmsFinalService extends FinalService {
  override def run(request: HttpServletRequest, data: Seq[Any]): Unit = {
    val service = new AcmsService()
    service.run(data)
  }
}
