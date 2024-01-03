import argparse
import const
import util
import pandas as pd

import models.model_prophet as model

from flask import Flask, request
from waitress import serve

app = Flask(const.APP_NAME)

import pprint
class LoggingMiddleware(object):
  def __init__(self, app):
    self._app = app

  def __call__(self, env, resp):
    errorlog = env['wsgi.errors']
    pprint.pprint(('REQUEST', env), stream=errorlog)

    def log_response(status, headers, *args):
      pprint.pprint(('RESPONSE', status, headers), stream=errorlog)
      return resp(status, headers, *args)

    return self._app(env, log_response)

@app.route("/predict", methods=["POST"])
def predict():
  try:
    data = request.json
    df = pd.DataFrame(data["train_data"])

    response = {
      "desc": "success",
      "code": 200,
      "data": model.predict(df, data["predict_type"])
    }

    return response, 200
  except Exception as e:
    util.print_exception("predict_exception -> {}\n".format(str(e)))
    return {
      "desc": str(e),
      "code": 400
    }, 400

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('-port', type=int, help='Server port', default=const.APP_PORT)
  parser.add_argument('-release', type=int, help='Is Release', default=0)
  args = parser.parse_args()

  app_port = args.port
  arg_release = args.release == 1

  if arg_release:
    serve(app, host='0.0.0.0', port=app_port)
  else:
    # app.wsgi_app = LoggingMiddleware(app.wsgi_app)
    app.run(host='0.0.0.0', port=app_port)