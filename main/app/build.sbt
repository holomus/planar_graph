name := "vhr"
organization := "com.verifix"
organizationName := "Verifix HR"
version := "3.0.1"
scalaVersion := "2.12.18"
publishMavenStyle := false
scalacOptions ++= Seq("-feature", "-release:20", "-deprecation")

libraryDependencies ++= Seq(
  // used for JSON Web Token generation
  "com.pauldijou" %% "jwt-core" % "5.0.0",

  // used for MQ event notifications
  "org.apache.activemq" % "activemq-client-jakarta" % "5.18.2",

  // used for MQ event notifications
  "jakarta.jms" % "jakarta.jms-api" % "3.1.0",

  // used for FTPClient connection
  "commons-net" % "commons-net" % "3.9.0"
)

lazy val build = taskKey[Unit]("build vhr")
def buildCommand = Def.task {
  val vhrJar = (Compile / packageBin).value
  val root = target.value.getParentFile.getParentFile / "lib"

  IO.copyFile(vhrJar, root / "vhr.jar")
}

build := (buildCommand dependsOn clean).value