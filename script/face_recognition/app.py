from deepface import DeepFace

from flask import Flask, request
from flask_httpauth import HTTPBasicAuth
from werkzeug.security import check_password_hash
import argparse
import const

app = Flask(const.APP_NAME)
auth = HTTPBasicAuth()

@auth.verify_password
def verify_password(username, password):
  if username in const.users:
    return check_password_hash(const.users.get(username), password)
  return False

@app.route('/embed', methods=['POST'])
@auth.login_required
def embed():
  try:
    data = request.get_json()
    
    rp = DeepFace.represent(
      img_path = data['image'], 
      model_name='SFace', 
      detector_backend='mtcnn'
    )

    return {
      'data': rp[0]["embedding"]
    }
  except Exception as ex:
    message = str(ex)

    if message == const.NO_FACE_ERROR_MESSAGE:
      response = {
       'error_code': const.NO_FACE_ERROR_CODE
      }
      code = 200
    else:
      response = message
      code = 400

    return response, code

if __name__ == '__main__':
  parser = argparse.ArgumentParser("Face recognition")
  parser.add_argument('-host', type=str, help='Server host', default=const.APP_HOST)
  parser.add_argument('-port', type=int, help='Server port', default=const.APP_PORT)
  parser.add_argument('-release', type=int, help='Is Release (1/0)', default=0)
  args = parser.parse_args()

  app_host = args.host
  app_port = args.port
  arg_release = args.release == 0

  app.run(host=app_host, debug=arg_release, port=app_port)