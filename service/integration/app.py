import argparse
import json
import ssl

from flask import Flask, Response, request
from waitress import serve

import const
import util
from apps import Hik, Verifix
from database import Database

ssl._create_default_https_context = ssl._create_unverified_context

app = Flask(__name__)

db = Database("{}/integration.db".format(const.DATABASE_PATH))
db.connect()

app_port = const.APP_PORT

verifix: Verifix = Verifix(database=db)
hik: Hik = Hik(database=db)


@app.route('/terminal_track', methods=['POST'])
def terminal_track():
    global db

    device_code = request.args.get("device_code")
    try:
        device = db.take_device(device_code=device_code)
        if not device:
            print("device not found")
            return

        data = json.loads(request.form.get("event_log"))

        event_time = data["dateTime"] if data.__contains__("dateTime") else None
        if data['eventType'] != 'AccessControllerEvent' and not data.__contains__('AccessControllerEvent'):
            return
        event = data["AccessControllerEvent"]
        if event['majorEventType'] != const.MAJOR_EVENT or \
                event['subEventType'] not in [const.FACE_PASS, const.FINGERPRINT_PASS]:
            return

        hik.track_by_event(device_code=device_code, event=event, event_time=event_time,
                           event_minor=event['subEventType'])
        hik.sync_task_post(device_code=device_code)
    except Exception as e:
        util.print_exception("terminal_track -> {}\n".format(str(e)))
    finally:
        return Response(response=str("OK"), status=200)


if __name__ == '__main__':
    parser = argparse.ArgumentParser("Hikvision integration")
    parser.add_argument('-port', type=int, help='Server port', default=const.APP_PORT)
    parser.add_argument('-release', type=int, help='Is Release', default=0)
    args = parser.parse_args()

    app_port = args.port
    arg_release = args.release == 1

    hik.run(callback=verifix.send_device_track)
    verifix.run(app_port=app_port, hik=hik)

    if arg_release:
        serve(app, host='0.0.0.0', port=app_port)
    else:
        app.run(host='0.0.0.0', port=app_port)
