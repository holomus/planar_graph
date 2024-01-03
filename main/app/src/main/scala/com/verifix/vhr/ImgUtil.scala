package com.verifix.vhr

import javax.imageio.ImageIO
import net.coobird.thumbnailator.Thumbnails
import oracle.jdbc.OracleCallableStatement
import uz.greenwhite.biruni.connection.DBConnection
import uz.greenwhite.biruni.filemanager.FileManager.{loadFile, uploadFileEntity}
import uz.greenwhite.biruni.util.FileUtil

import java.io.{ByteArrayInputStream, ByteArrayOutputStream, InputStream}
import java.util.Base64

object ImgUtil {
  private val DEFAULT_IMG_NAME = "VERIFIX_IMAGE"
  val CONTENT_TYPE_IMAGE_JPEG = "image/jpeg"

  private def saveBiruniFiles(sha: String, fileSize: String, storeKind: String): Unit = {
    var conn = DBConnection.getPoolConnection
    var cs: OracleCallableStatement = null

    try {
      conn.setAutoCommit(false)

      val query = "BEGIN Hac_Core.Save_File(?,?,?,?,?); END;"
      cs = conn.prepareCall(query).asInstanceOf[OracleCallableStatement]
      cs.setString(1, sha)
      cs.setString(2, fileSize)
      cs.setString(3, DEFAULT_IMG_NAME)
      cs.setString(4, CONTENT_TYPE_IMAGE_JPEG) // contentType
      cs.setString(5, storeKind)
      cs.execute

      conn.commit()
    } catch {
      case ex: Exception =>
        conn.rollback()
        println("Biruni file upload error. Error message " + ex.getMessage)
        throw ex
    } finally {
      if (cs != null) cs.close()
      conn.close()
      conn = null
    }
  }

  private def loadCroppedImage(sha: String): Array[Byte] = {
    val MAX_HEIGHT = 600
    val MAX_WIDTH = 600
    val MAX_FILE_SIZE = 100 // in kilobytes

    val imgBytes = loadFile(sha)

    val img_height = 500
    val img_width = 500
    val img_format = "JPEG"
    val img_quality = 0.5


    val buf = new ByteArrayInputStream(imgBytes)
    val image = ImageIO.read(buf)
    val byteArray = new ByteArrayOutputStream()

    if (imgBytes.length / 1024 < MAX_FILE_SIZE && image.getHeight < MAX_HEIGHT && image.getWidth < MAX_WIDTH) {
      byteArray.write(imgBytes)
      byteArray.flush()
    }
    else
      Thumbnails.of(image)
        .size(img_width, img_height)
        .outputFormat(img_format)
        .outputQuality(img_quality)
        .toOutputStream(byteArray)

    byteArray.toByteArray
  }

  def loadBase64EncodedCroppedImage(sha: String): String = {
    val img = loadCroppedImage(sha)

    Base64.getEncoder.encodeToString(img)
  }

  def loadBase64EncodedImage(sha: String): String = {
    val img = loadFile(sha)

    Base64.getEncoder.encodeToString(img)
  }

  def uploadImageFromByteArray(imgData: Array[Byte]): String = {
    var imgSha = ""

    try {
      if (imgData.length > 0) {
        imgSha = uploadFileEntity(imgData, CONTENT_TYPE_IMAGE_JPEG)

        saveBiruniFiles(imgSha, imgData.length.toString, FileUtil.getFileStoreKind)
      }
    }
    catch {
      case ex: Exception =>
        println(ex.getMessage)
        imgSha = ""
    }

    imgSha
  }

  def uploadImage(imageStream: InputStream): String = {
    var imgSha = ""

    try {
      val bytes = FileUtil.readInputStream(imageStream)
      imgSha = uploadImageFromByteArray(bytes)
    }
    catch {
      case ex: Exception =>
        println(ex.getMessage)
        imgSha = ""
    }

    imgSha
  }
}
