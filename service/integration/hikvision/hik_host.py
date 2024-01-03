import socket

from dicttoxml import dicttoxml
from requests import Response, ConnectTimeout
from werkzeug.serving import get_interface_ip

import util
from hikvision import get_session


class HikHost:
    def __init__(self, host, login, password):
        self._host = host
        self._login = login
        self._password = password

    def put(self, device_code, port, recall=False):
        try:
            hostname = get_interface_ip(socket.AF_INET)
            path = '/ISAPI/Event/notification/httpHosts'
            session = get_session(host=self._host, login=self._login, password=self._password)
            body = {
                "HttpHostNotificationList": {
                    "HttpHostNotification": {
                        "id": "1",
                        "url": '/terminal_track?device_code={}'.format(device_code),
                        "protocolType": "HTTP",
                        "parameterFormatType": "JSON",
                        "addressingFormatType": "ipaddress",
                        "ipAddress": hostname,
                        "portNo": port,
                        "httpAuthenticationMethod": "none"
                    }
                }
            }
            response: Response = session.put(path, timeout=(5, 10), data=dicttoxml(body, root=False))
            if response.status_code != 200:
                print(response.text)
            return response.status_code == 200
        except ConnectTimeout as e:
            if recall:
                util.print_exception("HikHost.put -> {}\n".format(str(e)))
                raise e
            return self.put(device_code=device_code, port=port, recall=True)
