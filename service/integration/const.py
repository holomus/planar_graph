import os
import pathlib

APP_PORT = 8888

VERIFIX_SERVER = "https://app2.verifix.com"
VERIFIX_USERNAME = "hikvision_terminal@demo"
VERIFIX_PASSWORD = "hikvision_terminal"

CURRENT_PATH = pathlib.Path(__file__).parent.resolve()
DATABASE_PATH = "{}/cache/database".format(CURRENT_PATH)
IMAGE_PATH = "{}/cache/event_image".format(CURRENT_PATH)

VERIFIX_CONFIG_SECONDS = round(60 * 30)  # 30 minute
VERIFIX_TRACKS_SECONDS = round(60 * 20)  # 20 minute

LOCAL_TRACK_CACHE_SECOND = round(3600 * (24))  # 3600 is 1 hour, total 1 day

TERMINAL_SYNC_SECONDS = round(60 * 40)  # 40 minute
TERMINAL_PING_SECONDS = round(5)  # 5 seconds

MAJOR_EVENT = 5
FINGERPRINT_PASS = 38
FACE_PASS = 75

if not os.path.exists(DATABASE_PATH):
    os.makedirs(DATABASE_PATH)

if not os.path.exists(IMAGE_PATH):
    os.makedirs(IMAGE_PATH)
