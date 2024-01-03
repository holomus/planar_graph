import time

import const
import util
from common import Task
from database import Database
from hikvision import HikEvent, HikPerson, HikHost


class Hik:
    def __init__(self, database: Database):
        self.db = database
        self.callback = None
        self.delay_tasks = {}

    def _sync_persons(self, device):
        device_code = device["device_code"]

        employees = self.db.load_employees(device_code=device_code)
        employee_ids = [r['pin'] for r in employees]

        hik_person = HikPerson(
            host=device["host"],
            login=device["login"],
            password=device["password"],
        )

        persons = hik_person.list()
        person_ids = [r["employee_id"] for r in persons]

        def check_persons_available(emp_id, emp_name):
            for person_item in persons:
                if person_item["employee_id"] == emp_id:
                    if person_item["name"] == emp_name:
                        return True
                    else:
                        hik_person.delete(employee_id=emp_id)
                        return False
            return False

        if len(employees) == 0:
            for employee_id in person_ids:
                hik_person.delete(employee_id=employee_id)
        else:
            person_changes = False
            for item in persons:
                try:
                    employee_id = item["employee_id"]
                    person_photos = hik_person.person_photo(employee_id=employee_id)
                    if len(person_photos) == 0:
                        person_changes = True
                        hik_person.delete(employee_id=employee_id)
                except Exception as e:
                    util.print_exception("delete person if not exists photo {}".format(str(e)))

            if person_changes:
                persons = hik_person.list()

            for item in employees:
                try:
                    employee_id = item["pin"]
                    employee_name = item["name"]

                    photo_info = self.db.take_employee_photo(device_code=device_code,
                                                             employee_id=item['employee_id'])

                    if check_persons_available(emp_id=employee_id, emp_name=employee_name):
                        if photo_info['synced'] == 'N':
                            success_add_photo = hik_person.add_photo(
                                employee_id=employee_id,
                                image_sha=photo_info["photo_sha"],
                            )

                            if success_add_photo:
                                self.db.employee_photo_synced(device_code=device_code,
                                                              employee_id=item['employee_id'])
                        continue

                    success_add = hik_person.add(
                        employee_id=employee_id,
                        name=item["name"],
                        male=True,
                    )

                    if success_add and photo_info.__contains__("photo_sha"):
                        success_add_photo = hik_person.add_photo(
                            employee_id=employee_id,
                            image_sha=photo_info["photo_sha"],
                        )

                        if success_add_photo:
                            self.db.employee_photo_synced(device_code=device_code,
                                                          employee_id=item['employee_id'])
                except Exception as e:
                    util.print_exception(
                        "add person into hikvision\n"
                        "person: {}\n"
                        "for-each {}".format(item["name"], str(e)))

            for employee_id in [r for r in person_ids if r not in employee_ids]:
                hik_person.delete(employee_id=employee_id)

    def _sync_device_tracks(self):
        device_list = self.db.load_devices()
        plus_second = 1
        for device in device_list:
            try:
                device_code = device["device_code"]
                _, millis = self.db.get_last_time(device_code=device_code)

                if millis and round(((time.time() * 1000.0) - millis) / 1000.0) < const.TERMINAL_SYNC_SECONDS:
                    continue

                self.sync_task_post(device_code=device_code, plus_second=plus_second)
                plus_second += 1
            except Exception as e:
                util.print_exception("_sync_device_tracks -> {}\n".format(str(e)))

    def run(self, callback=None):
        self.callback = callback

        Task(function=self._sync_device_tracks).post_interval(seconds=const.TERMINAL_SYNC_SECONDS)

    def sync_device_configs(self, app_port):
        device_list = self.db.load_devices()
        if not device_list:
            return

        for device in device_list:
            try:
                self._sync_persons(device=device)

                HikHost(
                    host=device["host"],
                    login=device["login"],
                    password=device["password"],
                ).put(device_code=device["device_code"], port=app_port)
            except Exception as e:
                util.print_exception("sync_device_configs -> {}\n".format(str(e)))

    def sync_task_post(self, device_code, plus_second=0):
        try:
            if self.delay_tasks.__contains__(device_code):
                task = self.delay_tasks[device_code]
                time_passed = task.time_passed()
                if not time_passed or time_passed > (const.TERMINAL_PING_SECONDS + 5):  # + 5 second for running check
                    task.remove()
                    del self.delay_tasks[device_code]

            if not self.delay_tasks.__contains__(device_code):
                task = Task(function=self.sync_tracks, args=(device_code,))
                self.delay_tasks[device_code] = task
                task.post_delay(seconds=const.TERMINAL_PING_SECONDS + plus_second)
        except Exception as e:
            util.print_exception("sync_task_post -> {}\n".format(str(e)))

            if self.delay_tasks.__contains__(device_code):
                del self.delay_tasks[device_code]

    def sync_tracks(self, device_code):
        try:
            device = self.db.take_device(device_code=device_code)
            if not device:
                return

            date_time, _ = self.db.get_last_time(device_code=device_code)
            (min_time, track_ids,) = self.db.load_min_unverified_date(device_code=device_code)
            date_time = min_time if min_time else date_time

            hik_event = HikEvent(
                host=device["host"],
                login=device["login"],
                password=device["password"],
            )
            last_time, trackings = hik_event.load(start_time=date_time)
            for row in [r for r in trackings if r.__contains__('employee_id')]:
                employee = self.db.take_employee(device_code=device_code, pin=row["employee_id"])
                if not employee:
                    continue

                track = self.db.track_exists(device_code=device_code, employee_id=employee["employee_id"],
                                             track_date=row["date"])

                photo_sha = None
                if (not track or not track["synced"]) and row.__contains__("image_url") and len(row["image_url"]) > 0:
                    photo_sha = hik_event.download_image(row["image_url"], const.IMAGE_PATH)

                self.db.create_or_update_track(
                    device_code=device_code,
                    employee_id=employee["employee_id"],
                    track_date=row["date"],
                    photo_sha=photo_sha,
                    status=row["status"],
                    mask="Y" if row["mask"] else "N",
                    mark_type=row["mark_type"],
                    verified="Y"
                )

            for track_id in track_ids:
                track = self.db.load_track(device_code=device_code, track_id=track_id)
                if not track or track["verified"]:
                    continue
                self.db.remove_track(device_code=device_code, track_id=track_id)

            self.db.set_last_time(device_code=device_code, date_time=last_time)
            if len(trackings) > 0:
                self.callback(device_code=device_code)
        except Exception as e:
            util.print_exception("sync_tracks -> {}\n".format(str(e)))
        finally:
            if self.delay_tasks.__contains__(device_code):
                del self.delay_tasks[device_code]

    def track_by_event(self, device_code, event, event_time, event_minor):
        device = self.db.take_device(device_code=device_code)
        if not event_time or not device:
            return

        employee = self.db.take_employee(device_code=device_code, pin=event['employeeNoString'])
        if not employee:
            return

        track_info = {'employee_id': employee["employee_id"],
                      'date': event_time,
                      'status': event['attendanceStatus'] if event.__contains__('attendanceStatus') and event[
                          "attendanceStatus"] != "undefined" else 'check',
                      'mask': event['mask'] if event.__contains__('mask') else 'no',
                      'mark_type': 'face' if event_minor == const.FACE_PASS else 'touch',
                      'image_url': ""
                      }

        self.db.create_or_update_track(
            device_code=device_code,
            employee_id=track_info["employee_id"],
            track_date=track_info["date"],
            photo_sha="",
            status=track_info["status"],
            mask="Y" if track_info["mask"] else "N",
            mark_type=track_info["mark_type"],
            verified="N"
        )
