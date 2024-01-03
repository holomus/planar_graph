import json
import os
from datetime import datetime, timedelta
from hashlib import sha256

from requests import Response, ConnectTimeout

import const
import util
from const import MAJOR_EVENT, FACE_PASS, FINGERPRINT_PASS
from hikvision import get_session


class HikEvent:
    def __init__(self, host=str, login=str, password=str):
        self._host = host
        self._login = login
        self._password = password

    def _load_event(self, begin_time, end_time, position=0, recall=False):
        try:
            path = '/ISAPI/AccessControl/AcsEvent?format=json'
            session = get_session(host=self._host, login=self._login, password=self._password)
            body = {
                "AcsEventCond":
                    {
                        "searchID": "1",  # hohlagan text kiritsa bolarekan
                        "maxResults": 50,
                        "searchResultPosition": position,
                        "minor": 0,
                        "major": 0,
                        "startTime": begin_time,
                        "endTime": end_time
                    }
            }
            response: Response = session.post(path, timeout=(5, 10), data=json.dumps(body))
            if response.status_code != 200:
                return 0, 0, []

            data = response.json()
            total_match = data["AcsEvent"]["totalMatches"]
            num_match = data["AcsEvent"]["numOfMatches"]

            if not data["AcsEvent"].__contains__('InfoList') or total_match <= 0:
                return 0, 0, [],

            return total_match, num_match, [r for r in data["AcsEvent"]["InfoList"] if
                                            r['major'] == MAJOR_EVENT and
                                            r['minor'] in [FACE_PASS, FINGERPRINT_PASS] and
                                            r.__contains__("employeeNoString") and r["employeeNoString"]],
        except ConnectTimeout as e:
            if recall:
                util.print_exception("_load_event -> {}\n".format(str(e)))
                raise e
            return self._load_event(begin_time=begin_time, end_time=end_time, position=position, recall=True)

    def load(self, start_time=None):
        begin_time = start_time
        now_time = datetime.now()
        now_time_str = datetime.now().strftime('%Y-%m-%dT00:00:00+05:00')
        end_time = (now_time + timedelta(seconds=5)).strftime('%Y-%m-%dT%H:%M:%S+05:00')
        begin_time = begin_time if begin_time else (
                    datetime.now() - timedelta(seconds=const.LOCAL_TRACK_CACHE_SECOND)).strftime(
            '%Y-%m-%dT00:00:00+05:00')

        print("Start at {} the load event begin: {}, end: {}".format(now_time_str, begin_time, end_time))
        result: list = []
        position = 0
        while True:
            total_match, num_match, events = self._load_event(begin_time=begin_time, end_time=end_time,
                                                              position=position)
            if num_match > 0 and events:
                position += num_match
                result.extend(events)
            else:
                break

            if total_match <= position:
                break

        result_time = (now_time - timedelta(seconds=5)).strftime('%Y-%m-%dT%H:%M:%S+05:00')
        return (result_time, [{'employee_id': r['employeeNoString'],
                               'date': r['time'],
                               'status': r['attendanceStatus'] if r.__contains__('attendanceStatus') else 'check',
                               'mask': r['mask'] if r.__contains__('mask') else 'no',
                               'mark_type': 'face' if r['minor'] == FACE_PASS else 'touch',
                               'image_url': r['pictureURL'] if r.__contains__('pictureURL') else ""
                               } for r in result],)

    def download_image(self, image_url: str, path, recall=False):
        try:
            session = get_session(host=self._host, login=self._login, password=self._password)
            response: Response = session.get(image_url.replace(str(self._host), ""), timeout=(5, 10), stream=True)
            if response.status_code != 200:
                print("Response error -> {}".format(str(response.text)))
                return None

            data = response.raw.read(decode_content=True)

            sha = sha256()
            sha.update(data)
            filename = sha.hexdigest()

            if not os.path.exists(path):
                os.makedirs(path)
            with open("{}/{}.jpeg".format(path, filename), 'wb') as f:
                f.write(data)

            return filename
        except ConnectTimeout as e:
            if recall:
                util.print_exception("download_image -> {}\n".format(str(e)))
                return None
            return self.download_image(image_url=image_url, path=path, recall=True)
        except Exception as e:
            util.print_exception("download_image -> {}\n".format(str(e)))
            return None
