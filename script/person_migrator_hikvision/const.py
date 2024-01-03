import os

DESTINATION_SERVER = "https://safia.verifix.com"
DESTINATION_USERNAME = "test@head"
DESTINATION_PASSWORD = "1"

UPLOAD_PERSON_ROUTE = "/b/vhr/hes/image_migrator:upload_person"

DEVICE_IP = 'http://192.168.40.45'
DEVICE_LOGIN = 'admin'
DEVICE_PASSWORD = 'verifix1234'

IMAGE_PATH = "./cache/images"

MAX_ITER_COUNT = 1000
INITIAL_CURSOR = 0

if not os.path.exists(IMAGE_PATH):
  os.makedirs(IMAGE_PATH)