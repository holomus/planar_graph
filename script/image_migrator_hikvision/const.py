import os

SOURCE_SERVER = "http://192.168.10.26:8080/verifix_hr"

DESTINATION_SERVER = "http://192.168.10.26:8080/verifix_hr"
DESTINATION_USERNAME = "admin@head"
DESTINATION_PASSWORD = "greenwhite"

DOWNLOAD_IMAGE_ROUTE = "/ISAPI/Bumblebee/Platform/V0/PersonCredential/Persons/{}/Photo?SID=&PHOTOTYPE=1"
UPLOAD_IMAGE_ROUTE = "/b/vhr/hes/face_detection:upload_photo"

PERSONS = [
  {
    'person_code': "2532",
    'org_code': "16",
    'server_id': "21",
  },
]

IMAGE_PATH = "./cache/images"

MAX_ITER_COUNT = 1000
INITIAL_CURSOR = 0

if not os.path.exists(IMAGE_PATH):
  os.makedirs(IMAGE_PATH)