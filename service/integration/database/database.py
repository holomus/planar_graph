import os
import sqlite3
import time

import util


class Database:
    def __init__(self, file_path="./database/integration.db"):
        self._file_path = file_path
        self._sequence = 1
        self._last_time: dict = {}

    def next_id(self):
        self._sequence += 1
        return str(self._sequence)

    def get_last_time(self, device_code):
        if self._last_time.__contains__(device_code):
            return self._last_time[device_code]
        else:
            return self.load_last_track_date(device_code=device_code)

    def set_last_time(self, device_code, date_time):
        milliseconds = round(time.time() * 1000.0)
        self._last_time[device_code] = (date_time, milliseconds,)

    def connect(self):
        db_not_exists = not os.path.exists(self._file_path)

        with sqlite3.connect(self._file_path) as conn:
            if db_not_exists:
                print("Creating tables")

                with open('./database/setup.sql', 'rt') as file:
                    schema = file.read()
                conn.executescript(schema)
            else:
                print("Database already exists.")

    def add_device(self, device_code, host, login, password):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("""
               INSERT OR REPLACE INTO t_devices 
                 (device_code, host, login, password)
               VALUES
                 (?, ?, ?, ?)
            """, (device_code, host, login, password,))

    def remove_device(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM t_devices WHERE device_code = ?",
                           (device_code,))

    def load_devices(self):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM t_devices")
            return [{
                "device_code": device_code,
                "host": host,
                "login": login,
                "password": password,
            } for device_code, host, login, password in cursor.fetchall()]

    def take_device(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM t_devices WHERE device_code = ?",
                           (device_code,))

            device = cursor.fetchone()
            if device is None:
                return {}

            (device_code, host, login, password,) = device

            return {
                "device_code": device_code,
                "host": host,
                "login": login,
                "password": password,
            }

    def add_employee(self, device_code, employee_id, pin, name):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("""
               INSERT OR REPLACE INTO t_employees 
                 (device_code, employee_id, pin, name)
               VALUES
                 (?, ?, ?, ?)
            """, (device_code, employee_id, pin, name,))

    def remove_all_employee(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM t_employees WHERE device_code = ?",
                           (device_code,))

    def remove_employee(self, device_code, employee_id):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM t_employees WHERE device_code = ? AND employee_id = ?",
                           (device_code, employee_id))

    def load_employees(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT employee_id, pin, name FROM t_employees WHERE device_code = ?",
                           (device_code,))
            return [{
                "employee_id": employee_id,
                "pin": pin,
                "name": name,
            } for employee_id, pin, name in cursor.fetchall()]

    def take_employee(self, device_code, pin):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT employee_id, name FROM t_employees WHERE device_code = ? AND pin = ?",
                           (device_code, pin,))

            result = cursor.fetchone()

            if result is not None:
                (employee_id, name,) = result
                return {
                    "employee_id": employee_id,
                    "pin": pin,
                    "name": name,
                }

            return {}

    def add_employee_photo(self, device_code, employee_id, photo_sha, synced="N"):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("""
               INSERT OR REPLACE INTO t_employee_photos 
                 (device_code, employee_id, photo_sha, synced)
               VALUES
                 (?, ?, ?, ?)
            """, (device_code, employee_id, photo_sha, synced,))

    def employee_photo_synced(self, device_code, employee_id):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("""
               UPDATE t_employee_photos 
                SET synced = ?
              WHERE device_code = ?
                AND employee_id = ?
            """, ("Y", device_code, employee_id,))

    def take_employee_photo(self, device_code, employee_id):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT photo_sha, synced FROM t_employee_photos WHERE device_code = ? AND employee_id = ?",
                           (device_code, employee_id,))

            result = cursor.fetchone()

            if result is not None:
                (photo_sha, synced,) = result
                return {
                    "photo_sha": photo_sha,
                    "synced": synced,
                }

            return {}

    def load_employee_photos(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT employee_id, photo_sha, synced FROM t_employee_photos WHERE device_code = ?",
                           (device_code,))
            return [{
                "employee_id": employee_id,
                "photo_sha": photo_sha,
                "synced": synced,
            } for employee_id, photo_sha, synced in cursor.fetchall()]

    def remove_employee_photo(self, device_code, employee_id):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM t_employee_photos WHERE device_code = ? AND employee_id = ?",
                           (device_code, employee_id,))

    def track_exists(self, device_code, employee_id, track_date):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("""
                SELECT track_id,
                       verified,
                       synced
                  FROM t_trackings 
                 WHERE device_code = ?  
                   AND employee_id = ?
                   AND track_date = ?
            """, (device_code, employee_id, track_date,))

            result = cursor.fetchone()

            if result is not None:
                (track_id, verified, synced,) = result
                return {"track_id": track_id, "verified": verified == "Y", "synced": synced == "Y"}

            return None

    def _save_track(self, device_code, track_id, employee_id, track_date, photo_sha, status, mask, mark_type, verified):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("""
               INSERT OR REPLACE INTO t_trackings 
                 (device_code, track_id, employee_id, track_date, photo_sha, status, mask, mark_type, verified, synced)
               VALUES
                 (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                device_code, track_id, employee_id, track_date, photo_sha, status, mask, mark_type, verified, "N",))

    def create_or_update_track(self, device_code, employee_id, track_date, photo_sha, status, mask, mark_type,
                               verified):
        track = self.track_exists(device_code=device_code, employee_id=employee_id, track_date=track_date)
        track_id = track["track_id"] if track else None
        synced = track["synced"] if track else False

        if not track_id:
            track_id = "{}:{}".format(round(time.time() * 1000.0), self.next_id())
            synced = False

        if not synced:
            self._save_track(device_code=device_code, track_id=track_id, employee_id=employee_id, track_date=track_date,
                             photo_sha=photo_sha, status=status, mask=mask, mark_type=mark_type, verified=verified)

    def remove_all_track(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM t_trackings WHERE device_code = ?",
                           (device_code,))

    def remove_track(self, device_code, track_id):
        print("remove track: {}".format(track_id))
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM t_trackings WHERE device_code = ? AND track_id = ?",
                           (device_code, track_id,))

    def update_track(self, device_code, track_id, is_synced: bool):
        synced = "Y" if is_synced else "N"

        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute("""
               UPDATE t_trackings 
                SET synced = ?
              WHERE device_code = ?
                AND track_id = ?
            """, (synced, device_code, track_id,))

    def load_min_unverified_date(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute(
                """
                SELECT track_id,
                       track_date
                  FROM t_trackings 
                 WHERE device_code = ?
                   AND verified == 'N'
                   AND synced == 'N'
                """,
                (device_code,))
            result = [(util.parse_to_milliseconds(track_date), track_date, track_id,)
                      for (track_id, track_date,) in cursor.fetchall()]
            result.sort(key=lambda tup: tup[0], reverse=False)
            if not result:
                return None, [],
            (min_millisecond, min_track_date, _,) = result[0] if result else None
            track_ids = [track_id for (_, _, track_id,) in result]
            now_millisecond = time.time() * 1000.0
            if now_millisecond < min_millisecond:
                return None, track_ids,
            return min_track_date if min_track_date else None, track_ids,

    def load_last_track_date(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute(
                """
                SELECT track_date
                  FROM t_trackings 
                 WHERE device_code = ?
                """,
                (device_code,))
            result = [(util.parse_to_milliseconds(track_date), track_date,)
                      for (track_date,) in cursor.fetchall()]
            if not result:
                return None, None
            result.sort(key=lambda tup: tup[0], reverse=True)
            return result[0][1], result[0][0]

    def load_synced_tracks(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute(
                """
                SELECT track_id,
                       employee_id, 
                       track_date, 
                       photo_sha, 
                       status, 
                       mask, 
                       mark_type
                  FROM t_trackings 
                 WHERE device_code = ?
                   AND synced = 'Y'
                """,
                (device_code,))
            return [{
                "track_id": track_id,
                "employee_id": employee_id,
                "track_date": track_date,
                "photo_sha": photo_sha,
                "status": status,
                "mask": mask,
                "mark_type": mark_type,
            } for (track_id, employee_id, track_date, photo_sha, status, mask, mark_type,) in
                cursor.fetchall()]

    def load_track(self, device_code, track_id):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute(
                """
                SELECT employee_id, 
                       track_date, 
                       photo_sha, 
                       status, 
                       mask, 
                       mark_type,
                       verified, 
                       synced
                  FROM t_trackings 
                 WHERE device_code = ?
                   AND track_id = ?
                """,
                (device_code, track_id,))
            result = cursor.fetchone()
            if result is not None:
                (employee_id, track_date, photo_sha, status, mask, mark_type, verified, synced,) = result
                return {
                    "employee_id": employee_id,
                    "track_date": track_date,
                    "photo_sha": photo_sha,
                    "status": status,
                    "mask": mask,
                    "mark_type": mark_type,
                    "verified": verified == "Y",
                    "synced": synced == "Y",
                }
            return None

    def load_not_sync_tracks(self, device_code):
        with sqlite3.connect(self._file_path) as conn:
            cursor = conn.cursor()
            cursor.execute(
                """
                SELECT track_id, 
                       employee_id, 
                       track_date, 
                       photo_sha, 
                       status, 
                       mask, 
                       mark_type,
                       verified, 
                       synced
                  FROM t_trackings 
                 WHERE device_code = ?
                   AND verified == 'Y'
                   AND synced == 'N'
                """,
                (device_code,))
            return [{
                "track_id": track_id,
                "employee_id": employee_id,
                "track_date": track_date,
                "photo_sha": photo_sha,
                "status": status,
                "mask": mask,
                "mark_type": mark_type,
                "verified": verified,
                "synced": synced,
            } for (track_id, employee_id, track_date, photo_sha, status, mask, mark_type, verified, synced,) in
                cursor.fetchall()]
