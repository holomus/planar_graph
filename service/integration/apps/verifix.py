import os
import time

import const
import util
from apps import Hik
from common import Task
from database import Database
from network import RESTApi


# noinspection PyTypeChecker
class Verifix:
    def __init__(self, database: Database):
        self.db = database
        self.app_port = const.APP_PORT
        self.hik: Hik = None

    def _send_all_tracks(self):
        device_list = self.db.load_devices()
        for device in device_list:
            try:
                self.send_device_track(device_code=device["device_code"])
            except Exception as e:
                util.print_exception("send_all_tracks -> {}".format(str(e)))

    def _configure(self):
        body = RESTApi().load_data()
        if body is None:
            return

        use_device_code = []
        for item in body:
            device_code = item["device_id"]
            use_device_code.append(device_code)

            device: dict = self.db.take_device(device_code=device_code)

            device["device_code"] = device_code
            device["host"] = item["host"]
            device["login"] = item["login"]
            device["password"] = item["password"]

            device_host: str = device["host"]
            if not device_host.startswith("http"):
                device_host = "http://" + device_host

            self.db.add_device(
                device_code=device["device_code"],
                host=device_host,
                login=device["login"],
                password=device["password"],
            )

            use_employees = []
            for emp in item["persons"]:
                photo_sha: str = ''
                if emp.__contains__('photo_shas') and len(emp["photo_shas"]) > 0:
                    photo_sha = emp["photo_shas"][0]

                if photo_sha is not None and len(photo_sha) == 64:
                    employee_id = emp["person_id"]
                    use_employees.append(employee_id)
                    self.db.add_employee(
                        device_code=device_code,
                        employee_id=employee_id,
                        pin=emp["pin"],
                        name=emp["name"],
                    )

                    photo_info = self.db.take_employee_photo(device_code=device_code, employee_id=employee_id)
                    if not photo_info.__contains__('photo_sha') or photo_info['photo_sha'] != photo_sha:
                        self.db.add_employee_photo(device_code=device_code,
                                                   employee_id=employee_id,
                                                   photo_sha=photo_sha)

            device_employees = self.db.load_employees(device_code=device_code)
            for employee_id in [r['employee_id'] for r in device_employees if r['employee_id'] not in use_employees]:
                self.db.remove_employee(device_code=device_code, employee_id=employee_id)

            self.hik.sync_tracks(device_code=device_code)

        devices = self.db.load_devices()
        for device_code in [r["device_code"] for r in devices if r["device_code"] not in use_device_code]:
            self.db.remove_device(device_code=device_code)
            self.db.remove_all_employee(device_code=device_code)
            self.db.remove_all_track(device_code=device_code)

        self.hik.sync_device_configs(app_port=self.app_port)

    def run(self, app_port, hik: Hik):
        self.app_port = app_port if app_port else self.app_port
        self.hik = hik

        Task(function=self._configure).post_interval(seconds=const.VERIFIX_CONFIG_SECONDS)
        Task(function=self._send_all_tracks).post_interval(seconds=const.VERIFIX_TRACKS_SECONDS)
        self._configure()

    def send_device_track(self, device_code):
        tracks = []

        local_tracks = self.db.load_not_sync_tracks(device_code=device_code)
        print("Not sync tracks len=={}".format(str(len(local_tracks))))

        remove_files = []
        for photo_sha in [r['photo_sha'] for r in local_tracks if r.__contains__('photo_sha') and r['photo_sha']]:
            try:
                file_path = "{}/{}.jpeg".format(const.IMAGE_PATH, photo_sha)

                if not os.path.exists(file_path):
                    continue

                success_upload_file = RESTApi().upload_files(file_path)
                if success_upload_file:
                    remove_files.append(file_path)
            except Exception as e:
                util.print_exception("send_device_track.upload_files -> {}\n".format(str(e)))

        for remove_file in remove_files:
            try:
                os.remove(remove_file)
            except Exception as e:
                util.print_exception("send_device_track.remove_file: {} -> {}\n".format(remove_file, str(e)))

        try:
            for track in local_tracks:
                track_type = track["status"]
                tracks.append({
                    "track_id": track['track_id'],
                    "track_time": util.convert_device_datetime(track['track_date']),
                    "person_id": track["employee_id"],
                    "photo_sha": track["photo_sha"] if track.__contains__("photo_sha") else "",
                    "track_type": "I" if track_type == "checkIn" else ("O" if track_type == "checkOut" else "C"),
                    "mark_type": "F" if track["mark_type"] == 'face' else 'T',
                    "mask": track["mask"],
                })

            if len(tracks) == 0:
                print("Track is empty")
                return

            data = {"device_id": device_code, "tracks": tracks}
            result = RESTApi().save_tracks(data)

            if not result or not result.__contains__("statuses"):
                return

            for item in result["statuses"]:
                if item[1] == 'success' or (item[1] == 'error' and item[2].__contains__('dup val on index')):
                    track_info = tracks[int(item[0]) - 1]
                    track_id = track_info["track_id"]
                    self.db.update_track(device_code=device_code, track_id=track_id, is_synced=True)
                else:
                    print(item[2])
        except Exception as e:
            util.print_exception("send_device_track.rest_save_tracks -> {}\n".format(str(e)))
        finally:
            try:
                now_millisecond = time.time() * 1000.0
                tracks = self.db.load_synced_tracks(device_code=device_code)
                print("Total cache tracks: {}".format(len(tracks)))
                for track in tracks:
                    difference_second = (now_millisecond - util.parse_to_milliseconds(track["track_date"])) / 1000.0
                    if const.LOCAL_TRACK_CACHE_SECOND > difference_second:
                        continue
                    self.db.remove_track(device_code=device_code, track_id=track["track_id"])
            except Exception as e:
                util.print_exception("send_device_track.remove cache tracks -> {}\n".format(str(e)))
