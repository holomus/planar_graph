import json
import threading

from hikvision import get_session
from util import print_exception


class HikNotify:
    def __init__(self, host, login, password, callback):
        self._host = host
        self._login = login
        self._password = password
        self._callback = callback
        self._response = None
        self._session = None
        self._start_thread = False

    def start(self):
        x = threading.Thread(target=self._start_listen_events, )
        x.daemon = True
        x.start()

    def is_stop(self):
        return self._start_thread is False

    def stop(self):
        if self._session:
            self._session.close()

        if self._response:
            self._response.close()

        print('hik_notify.close')

    def _start_listen_events(self):
        try:
            self._start_thread = True

            path = '/ISAPI/Event/notification/alertStream?format=json'
            self._session = get_session(host=self._host, login=self._login, password=self._password)
            self._response = self._session.get(path, timeout=(5.0, 4000.0,), stream=True)
            self._response.raise_for_status()

            in_header = False  # are we parsing headers at the moment
            grabbing_response = False  # are we grabbing the response at the moment
            response_size = 0  # the response size that we take from Content-Length
            response_buffer = ""  # where we keep the response bytes
            start_image = False

            for chunk in self._response.iter_lines(delimiter=b'--MIME_boundary'):
                if start_image or chunk.startswith(b'\xff\xd8'):
                    if chunk.__contains__(b'\xff\xd9'):
                        start_image = False
                        image_end_index = chunk.index(b'\xff\xd9')
                        chunk = chunk[image_end_index + len(b'\xff\xd9'):]
                    else:
                        start_image = True
                        continue

                try:
                    decoded = chunk.decode("utf-8")
                except:
                    continue

                for line in [r.strip() for r in decoded.split("\n")]:

                    line = line.replace("\t", "")
                    line = line.replace("\r", "")

                    if line == "--MIME_boundary" or line.__contains__('Content'):
                        in_header = True

                    if in_header:
                        if line.startswith("Content-Length"):
                            line = line.replace(" ", "")
                            content_length = line.split(":")[1]
                            response_size = int(content_length)

                        if line == "" or line == '\r':
                            in_header = False
                            grabbing_response = True

                    elif grabbing_response:
                        response_buffer += line

                if len(response_buffer) == 0 or \
                        (not response_buffer.startswith("{") and not response_buffer.startswith("[")):
                    continue
                # # time to convert it json and return it
                grabbing_response = False

                if not response_buffer.startswith("{") and not response_buffer.endswith("}"):
                    print('response fail : ' + str(response_buffer))
                    break

                dic: dict = json.loads(str(response_buffer))
                #
                if dic["eventType"] == "AccessControllerEvent":
                    controller_event = dic["AccessControllerEvent"]
                    attendance_status = controller_event["attendanceStatus"]
                    rsp = {
                        "date": dic["dateTime"],
                        "status": "check" if attendance_status == 'undefined' else attendance_status,
                    }

                    if controller_event.__contains__('mask'):
                        rsp['mask'] = True if controller_event['mask'] == 'yes' else False

                    if controller_event.__contains__("employeeNoString"):
                        if rsp["status"] == "checkIn" or rsp["status"] == "checkOut" or rsp["status"] == "check":
                            rsp["employee_id"] = int(controller_event["employeeNoString"])
                    self._callback(rsp)
                response_buffer = ""
            print("Close notification event connection")
            self._start_thread = False
            self._session = None
            self._response = None
        except Exception as e:
            print_exception("Tracking.start_listener -> {}".format(str(e)))
            print("Track connection close")
            self._start_thread = False
            self._session = None
            self._response = None
