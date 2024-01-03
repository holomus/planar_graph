import json

import requests
from requests.auth import HTTPBasicAuth

import util
from const import VERIFIX_SERVER, VERIFIX_USERNAME, VERIFIX_PASSWORD


# noinspection PyMethodMayBeStatic
class RESTApi:
    def load_data(self, recall=False):
        try:
            response = requests.get("{}/b/vhr/hes/hikvision:load_data".format(VERIFIX_SERVER),
                                    auth=HTTPBasicAuth(username=VERIFIX_USERNAME, password=VERIFIX_PASSWORD),
                                    timeout=(5, 30),
                                    verify=False)
            if response.status_code == 200:
                return response.json()
            else:
                raise Exception(response.text)
        except requests.ConnectTimeout as e:
            if recall:
                util.print_exception("RESTApi.load_data -> {}\n".format(str(e)))
                return None
            return self.load_data(recall=True)
        except Exception as e:
            util.print_exception("Verifix.load_data -> {}\n".format(str(e)))
            return None

    def save_tracks(self, tracks, recall=False):
        try:
            response = requests.post("{}/b/vhr/hes/hikvision:save_tracks".format(VERIFIX_SERVER),
                                     auth=HTTPBasicAuth(username=VERIFIX_USERNAME, password=VERIFIX_PASSWORD),
                                     timeout=(5, 30),
                                     data=json.dumps(tracks),
                                     verify=False)
            if response.status_code != 200:
                raise Exception(response.text)
            return response.json()
        except requests.ConnectTimeout as e:
            if recall:
                util.print_exception("RESTApi.save_tracks -> {}\n".format(str(e)))
                return None
            return self.save_tracks(tracks=tracks, recall=True)
        except Exception as e:
            util.print_exception("Verifix.save_tracks -> {}\n".format(str(e)))
            return None

    def upload_files(self, file_path, recall=False):
        try:
            response = requests.post("{}/b/core/m:upload_files".format(VERIFIX_SERVER),
                                     auth=HTTPBasicAuth(username=VERIFIX_USERNAME, password=VERIFIX_PASSWORD),
                                     headers={"BiruniUpload": "param"},
                                     timeout=(5, 30),
                                     files={
                                         "files": ('img.jpeg', open(file_path, 'rb'), 'application/octet-stream'),
                                         "param": (None, "{}", 'application/json'),
                                     },
                                     verify=False)
            if response.status_code != 200:
                raise Exception(response.text)
            return True
        except requests.ConnectTimeout as e:
            if recall:
                util.print_exception("RestApi.upload_files -> {}\n".format(str(e)))
                return False
            return self.upload_files(file_path=file_path, recall=True)
        except Exception as e:
            util.print_exception("RestApi.upload_files -> {}\n".format(str(e)))
            return False
