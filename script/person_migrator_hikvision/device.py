import json
import urllib.request
import os

from requests import Response, ConnectTimeout

import util
import const
from session import get_session


class Device:
    def __init__(self, host, login, password):
        self._host = host
        self._login = login
        self._password = password

    def _list(self, position=0, recall=False):
        try:
            path = '/ISAPI/AccessControl/UserInfo/Search?format=json'
            session = get_session(host=self._host, login=self._login, password=self._password)
            body = {
                "UserInfoSearchCond": {
                    "searchID": "1",  # hohlagan text kiritsa bolarekan
                    "maxResults": 50,
                    "searchResultPosition": position
                }
            }
            response: Response = session.post(path, timeout=(30, 30), data=json.dumps(body))
            if response.status_code != 200:
                return 0, 0, []

            data = response.json()

            total_match = data["UserInfoSearch"]["totalMatches"]
            num_match = data["UserInfoSearch"]["numOfMatches"]

            if not data["UserInfoSearch"].__contains__('UserInfo') or total_match <= 0:
                return 0, 0, [],

            return total_match, num_match, [r for r in data["UserInfoSearch"]["UserInfo"]]
        except ConnectTimeout as e:
            if recall:
                util.print_exception("HikPerson._list -> {}\n".format(str(e)))
                raise e
            return self._list(position=position, recall=True)

    def list(self):
        result: list = []
        position = 0
        while True:
            total_match, num_match, events = self._list(position=position)
            if num_match > 0 and events:
                position += num_match
                result.extend(events)
            else:
                break

            if total_match <= position:
                break
        return [{"employee_id": r["employeeNo"], "name": r["name"], } for r in result]

    def _download_image(self, employee_id, image_url: str, recall=False):
        try:
            session = get_session(host=self._host, login=self._login, password=self._password)
            response: Response = session.get(image_url.replace(str(self._host), ""), timeout=(5, 10), stream=True)
            if response.status_code != 200:
                print("Response error -> {}".format(str(response.text)))
                return None

            data = response.raw.read(decode_content=True)

            if not os.path.exists(const.IMAGE_PATH):
                os.makedirs(const.IMAGE_PATH)
            with open("{}/{}.jpg".format(const.IMAGE_PATH, employee_id), 'wb') as f:
                f.write(data)
            
            return True
        except ConnectTimeout as e:
            if recall:
                util.print_exception("download_image -> {}\n".format(str(e)))
                return False
            return self.download_image(employee_id=employee_id, image_url=image_url, recall=True)
        except Exception as e:
            util.print_exception("download_image -> {}\n".format(str(e)))
            return False

    def person_photo(self, employee_id, recall=False):
        try:
            path = "/ISAPI/Intelligent/FDLib/FDSearch?format=json"
            session = get_session(host=self._host, login=self._login, password=self._password)
            body = {"searchResultPosition": 0, "maxResults": 30, "faceLibType": "blackFD", "FDID": "1",
                    "FPID": str(employee_id)}
            response: Response = session.post(path, timeout=(30, 30), data=json.dumps(body))
            if response.status_code != 200:
                raise Exception(response.text)
            dic = json.loads(response.text)
            if dic.__contains__("MatchList"):
                return self._download_image(employee_id=employee_id, image_url=[r["faceURL"] for r in dic["MatchList"]][0])
            return False
        except ConnectTimeout as e:
            if recall:
                util.print_exception("person_photo -> {}\n".format(str(e)))
                return False
            return self.person_photo(employee_id=employee_id, recall=True)
        except Exception as e:
            util.print_exception("person_photo -> {}\n".format(e))
            return False
