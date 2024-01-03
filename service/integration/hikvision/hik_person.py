import json
import urllib.request

from requests import Response, ConnectTimeout

import util
from const import VERIFIX_SERVER
from hikvision import get_session


class HikPerson:
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
            response: Response = session.post(path, timeout=(5, 10), data=json.dumps(body))
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

    def delete(self, employee_id, recall=False):
        try:
            path = '/ISAPI/AccessControl/UserInfo/Delete?format=json'
            session = get_session(host=self._host, login=self._login, password=self._password)
            body = {
                "UserInfoDelCond": {"EmployeeNoList": [{"employeeNo": str(employee_id)}]}
            }
            response: Response = session.put(path, timeout=(5, 10), data=json.dumps(body))
            if response.status_code != 200:
                raise Exception(response.text)
        except ConnectTimeout as e:
            if recall:
                util.print_exception("HikPerson.delete -> {}\n".format(str(e)))
                return
            return self.delete(employee_id=employee_id, recall=True)

    def add(self, employee_id, name, male=False, recall=False):
        try:
            path = "/ISAPI/AccessControl/UserInfo/Record?format=json"
            session = get_session(host=self._host, login=self._login, password=self._password)
            body = {
                "UserInfo": {
                    "employeeNo": str(employee_id),
                    "name": str(name),
                    "userType": "normal",
                    "gender": "male" if male else "female",
                    "localUIRight": False,
                    "maxOpenDoorTime": 0,
                    "Valid": {
                        "enable": True,
                        "beginTime": "2021-06-01T00:00:00",
                        "endTime": "2037-12-31T23:59:59",
                        "timeType": "local"
                    }, "doorRight": "1",
                    "RightPlan": [{
                        "doorNo": 1,
                        "planTemplateNo": "1"
                    }],
                    "userVerifyMode": ""}}
            response: Response = session.post(path, timeout=(5, 10), data=json.dumps(body))
            if response.status_code != 200:
                raise Exception(response.text)

            return True
        except ConnectTimeout as e:
            if recall:
                util.print_exception("HikPerson.add -> {}\n".format(str(e)))
                return False
            return self.add(employee_id=employee_id, name=name, male=male, recall=True)

    def add_photo(self, employee_id, image_path=None, image_url=None, image_sha=None, recall=False):
        if image_path or image_url:
            try:
                path = "/ISAPI/Intelligent/FDLib/FDSetUp?format=json"
                session = get_session(host=self._host, login=self._login, password=self._password)

                if image_path:
                    with open(image_path, 'rb') as read:
                        image = bytearray(read.read())

                    data = {
                        "FaceDataRecord": json.dumps({"faceLibType": "blackFD", "FDID": "1", "FPID": str(employee_id)})}
                    files = [("img", ("image.jpg", image, "image/jpeg"))]
                    response: Response = session.put(path, timeout=(5, 10), files=files, data=data)
                    if response.status_code != 200:
                        raise Exception(response.text)
                    return True
                elif image_url:
                    print(image_url)
                    body = {"faceLibType": "blackFD", "FDID": "1", "FPID": str(employee_id), "faceURL": image_url}
                    response: Response = session.put(path, timeout=(5, 10), data=json.dumps(body))
                    if response.status_code != 200:
                        raise Exception(response.text)
                    return True
            except ConnectTimeout as e:
                if recall:
                    util.print_exception("HikPerson.add_photo -> {}\n".format(str(e)))
                    return False
                return self.add_photo(employee_id=employee_id,
                                      image_path=image_path,
                                      image_url=image_url,
                                      image_sha=image_sha,
                                      recall=True)
        elif image_sha:
            image_path = "./img.jpg"

            image_url = "{}/b/core/m$load_image?sha={}&type=L".format(VERIFIX_SERVER, image_sha)
            urllib.request.urlretrieve(image_url, image_path)

            util.image_resize(path=image_path, size=400)

            return self.add_photo(employee_id=employee_id, image_path=image_path)

    def person_photo(self, employee_id, recall=False):
        try:
            path = "/ISAPI/Intelligent/FDLib/FDSearch?format=json"
            session = get_session(host=self._host, login=self._login, password=self._password)
            body = {"searchResultPosition": 0, "maxResults": 30, "faceLibType": "blackFD", "FDID": "1",
                    "FPID": str(employee_id)}
            response: Response = session.post(path, timeout=(5, 10), data=json.dumps(body))
            if response.status_code != 200:
                raise Exception(response.text)
            dic = json.loads(response.text)
            if dic.__contains__("MatchList"):
                return [r["faceURL"] for r in dic["MatchList"]]
            return []
        except ConnectTimeout as e:
            if recall:
                util.print_exception("person_photo -> {}\n".format(str(e)))
                return []
            return self.person_photo(employee_id=employee_id, recall=True)
        except Exception as e:
            util.print_exception("person_photo -> {}\n".format(e))
            return []
