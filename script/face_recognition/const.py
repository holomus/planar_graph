from werkzeug.security import generate_password_hash

APP_NAME = "FACE_RECOGNITION"
APP_HOST = '0.0.0.0'
APP_PORT = 5000

NO_FACE_ERROR_MESSAGE = "Face could not be detected. Please confirm that the picture is a face photo or consider to set enforce_detection param to False."

NO_FACE_ERROR_CODE = "DF0001"

users = {
  'admin': generate_password_hash('admin')
}