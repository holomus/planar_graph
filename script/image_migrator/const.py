import os

SOURCE_SERVER = "http://192.168.10.26:8080/verifix_hr"
SOURCE_USERNAME = "image.migrator@makro"
SOURCE_PASSWORD = "image.migrator"

DESTINATION_SERVER = "http://127.0.0.1:9090"
DESTINATION_USERNAME = "image.migrator@pro"
DESTINATION_PASSWORD = "image.migrator"

DOWNLOAD_SHAS_ROUTE = "/b/vhr/hes/image_migrator:download_person_shas"
UPLOAD_SHAS_ROUTE = "/b/vhr/hes/image_migrator:upload_person_shas"

DOWNLOAD_IMAGE_ROUTE = "/b/core/m$load_image"
UPLOAD_IMAGE_ROUTE = "/b/core/m:upload_files"

IMAGE_PATH = "./cache/images"

MAX_ITER_COUNT = 100
INITIAL_CURSOR = 0

if not os.path.exists(IMAGE_PATH):
  os.makedirs(IMAGE_PATH)