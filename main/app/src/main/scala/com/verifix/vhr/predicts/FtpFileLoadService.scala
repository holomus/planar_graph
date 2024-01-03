package com.verifix.vhr.predicts

import org.apache.commons.net.ftp.{FTP, FTPClient, FTPReply}
import org.json.JSONArray
import uz.greenwhite.biruni.Provider
import uz.greenwhite.biruni.json.JSON
import uz.greenwhite.biruni.service.runtimeservice.{ErrorRuntimeResult, RuntimeResult, RuntimeService, SuccessRuntimeResult}

import java.io.{ByteArrayInputStream, ByteArrayOutputStream}
import java.time.Duration

class FtpFileLoadService extends RuntimeService {
  private val ACTION_LOAD_FILES = "LOAD_FILES"
  private val ACTION_LIST_FILES = "LIST_FILES"
  private val VALID_FILE_EXTENSIONS: Array[String] = Array[String]("xls", "xlsx")

  private def InvalidExtension(filename: String): Boolean = {
    val begin = filename.lastIndexOf(".")
    if (begin == -1) return false
    val extension = filename.substring(begin + 1)
    !VALID_FILE_EXTENSIONS.contains(extension)
  }

  private def fileExists(ftp: FTPClient ,filename: String): Boolean = {
    ftp.listFiles(filename).length == 1
  }

  def splitChunks(value: String): Array[String] = {
    if (value.length > 10000) value.grouped(10000).toArray
    else Array(value)
  }

  /**
  * loads Excel file from given ftp server
  * */
  private def loadFiles(server: String, username: String, password: String, filenames: List[String]): String = {
    val ftp = new FTPClient

    try {
      if (filenames.exists(InvalidExtension))
        throw new Exception("Currently works only with .xls and .xlsx files")

      ftp.setControlKeepAliveTimeout(Duration.ofMinutes(5))
      ftp.connect(server)
      ftp.enterLocalPassiveMode()
      ftp.login(username, password)
      ftp.setFileType(FTP.BINARY_FILE_TYPE)

      // After connection attempt, you should check the reply code to verify success.
      val reply = ftp.getReplyCode

      if (!FTPReply.isPositiveCompletion(reply)) {
        ftp.disconnect()
        throw new Exception("FTP server refused connection.")
      }

      val byteArray = new ByteArrayOutputStream()
      val filesList = new JSONArray

      for {
        fn <- filenames
        if fileExists(ftp, fn)
      } {
        ftp.retrieveFile(fn, byteArray)

        val excelFile = Provider.readExcelBook(new ByteArrayInputStream(byteArray.toByteArray)).toString

        filesList.put(new JSONArray(splitChunks(excelFile)))

        byteArray.reset()
      }

      ftp.logout

      filesList.toString
    } catch {
      case ex: Exception =>
        throw new RuntimeException(ex.getMessage)
    } finally {
      if(ftp.isConnected) {
        try {
          ftp.disconnect()
        } catch {
          case ex: Exception =>
            ex.printStackTrace()
        }
      }
    }
  }

  private def listFiles(server: String, username: String, password: String): Array[String] = {
    val ftp = new FTPClient

    try {
      ftp.setControlKeepAliveTimeout(Duration.ofMinutes(5))
      ftp.connect(server)
      ftp.enterLocalPassiveMode()
      ftp.login(username, password)
      ftp.setFileType(FTP.BINARY_FILE_TYPE)

      // After connection attempt, you should check the reply code to verify success.
      val reply = ftp.getReplyCode

      if (!FTPReply.isPositiveCompletion(reply)) {
        ftp.disconnect()
        throw new Exception("FTP server refused connection.")
      }

      ftp.listFiles().filter(x => x != null && x.isFile).map(_.getName)
    } catch {
      case ex: Exception =>
        throw new RuntimeException(ex.getMessage)
    } finally {
      if (ftp.isConnected) {
        try {
          ftp.disconnect()
        } catch {
          case ex: Exception =>
            ex.printStackTrace()
        }
      }
    }
  }

  override def run(detail: Map[String, Any], data: String): RuntimeResult = {
    try {
      val requestData = JSON.parseForce(data)

      val action = detail.getOrElse("action", ACTION_LOAD_FILES).asInstanceOf[String]

      val serverUrl = detail.getOrElse("server_url", "").asInstanceOf[String]
      val username = detail.getOrElse("username", "").asInstanceOf[String]
      val password = detail.getOrElse("password", "").asInstanceOf[String]

      val filenames = requestData.getOrElse("filenames", List.empty).asInstanceOf[List[String]]

      action match {
        case ACTION_LOAD_FILES =>
          SuccessRuntimeResult(JSON.stringify(detail), loadFiles(serverUrl, username, password, filenames))
        case ACTION_LIST_FILES =>
          SuccessRuntimeResult(JSON.stringify(detail), JSON.stringify(listFiles(serverUrl, username, password)))
        case _ => throw new RuntimeException("Unregistered ftp action")
      }
    }
    catch {
      case ex: Exception =>
        ErrorRuntimeResult(ex.getMessage)
    }
  }
}
