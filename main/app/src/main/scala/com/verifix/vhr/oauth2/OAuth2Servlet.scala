package com.verifix.vhr.oauth2

import com.verifix.vhr.oauth2.OAuth2Service.getAccessToken
import jakarta.servlet.http.{HttpServlet, HttpServletRequest, HttpServletResponse}
import oracle.jdbc.{OracleCallableStatement, OracleTypes}
import uz.greenwhite.biruni.connection.DBConnection
import uz.greenwhite.biruni.json.JSON

import java.net.HttpURLConnection
import java.nio.charset.StandardCharsets

class OAuth2Servlet extends HttpServlet {
  private val SESSION_NAME = "SESSION"

  private def isEmpty(x: String): Boolean = x == null || x.isEmpty

  private def setBadRequest(errortext: String, resp: HttpServletResponse): Unit = {
    resp.setStatus(HttpURLConnection.HTTP_BAD_REQUEST)
    resp.setCharacterEncoding(StandardCharsets.UTF_8.name)
    resp.setContentType("text/plain; charset=UTF-8")
    resp.getWriter.append(errortext)
  }

  private def setSuccessResponse(resp: HttpServletResponse): Unit = {
    resp.setStatus(HttpURLConnection.HTTP_OK)
    resp.getWriter.println("<script> window.close(); </script>")
  }

  private def loadProviderInfo(sessionVal: String, redirectUri: String, state: String): Map[String, String] = {
    var conn = DBConnection.getPoolConnection
    var cs: OracleCallableStatement = null

    try {
      val query = "BEGIN Hes_Core.Load_Provider_Info(?,?,?,?); END;"
      cs = conn.prepareCall(query).asInstanceOf[OracleCallableStatement]
      cs.setString(1, sessionVal)
      cs.setString(2, redirectUri)
      cs.setString(3, state)
      cs.registerOutParameter(4, OracleTypes.VARCHAR)
      cs.execute()

      val output = cs.getString(4)

      JSON.parseForce(output).asInstanceOf[Map[String, String]]
    } finally {
      if (cs != null) cs.close()
      conn.close()
      conn = null
    }
  }

  override def doGet(req: HttpServletRequest, resp: HttpServletResponse): Unit = {
    try {
      val session = req.getSession(false)

      if (session == null) throw new Exception("No session found")

      val sessionVal = session.getAttribute(SESSION_NAME).asInstanceOf[String]

      val state = req.getParameter("state")
      val code  = req.getParameter("code")

      val providerInfo = loadProviderInfo(sessionVal, req.getRequestURI, state)

      val companyId  = providerInfo.getOrElse("company_id", "").toInt
      val userId     = providerInfo.getOrElse("user_id", "").toInt
      val providerId = providerInfo.getOrElse("provider_id", "").toInt

      val clientId     = providerInfo.getOrElse("client_id", "")
      val clientSecret = providerInfo.getOrElse("client_secret", "")

      val authUrl     = providerInfo.getOrElse("token_url", "")
      val contentType = providerInfo.getOrElse("content_type", "")
      val scope       = providerInfo.getOrElse("scope", "")

      if (isEmpty(code)) throw new Exception("couldn't get authentication code")

      if (isEmpty(clientId)) throw new Exception("provide clientId")
      if (isEmpty(clientSecret)) throw new Exception("provide clientSecret")

      if (isEmpty(authUrl)) throw new Exception("provide authUrl")
      if (isEmpty(contentType)) throw new Exception("provide contentType")

      getAccessToken(authUrl,
                     contentType,
                     code,
                     clientId,
                     clientSecret,
                     scope,
                     companyId,
                     userId,
                     providerId)

      setSuccessResponse(resp)
    } catch {
      case ex: Exception =>
        ex.printStackTrace()
        setBadRequest(ex.getMessage, resp)
    }
  }
}
