package com.verifix.vhr.listener

import com.verifix.vhr.dahua.DahuaService
import jakarta.servlet.{ServletContextEvent, ServletContextListener}

class VerifixContextListener extends ServletContextListener {
  override def contextInitialized(sce: ServletContextEvent): Unit = {
    DahuaService.init()
    DahuaService.startMQ()
  }

  override def contextDestroyed(sce: ServletContextEvent): Unit = {
    DahuaService.stopMQ()
  }
}
