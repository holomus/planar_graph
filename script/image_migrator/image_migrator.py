import argparse
import const
import sys
import linecache
import json
import requests
from requests.auth import HTTPBasicAuth
import urllib.request

def print_exception(prefix=""):
	exc_type, exc_obj, tb = sys.exc_info()
	f = tb.tb_frame
	lineno = tb.tb_lineno
	filename = f.f_code.co_filename
	linecache.checkcache(filename)
	line = linecache.getline(filename, lineno, f.f_globals)
	print(prefix + ' except({}, LINE {} "{}"): {}'.format(filename, lineno, line.strip(), exc_obj))

def load_image_shas(cursor: int):
	try:
		response = requests.get(const.SOURCE_SERVER + const.DOWNLOAD_SHAS_ROUTE,
														headers={ "cursor": str(cursor) },
														auth=HTTPBasicAuth(username=const.SOURCE_USERNAME, password=const.SOURCE_PASSWORD),
														timeout=(5, 30))
		if response.status_code == 200:
			return response.json()
		else:
			raise Exception(response.text)
	except Exception as e:
		print_exception("load_image_shas -> {}\n".format(str(e)))
		return None

def load_image(image_sha: str):
	image_path = const.IMAGE_PATH + "/{}.jpg".format(image_sha)

	image_url = const.SOURCE_SERVER + const.DOWNLOAD_IMAGE_ROUTE + "?sha={}".format(image_sha)

	urllib.request.urlretrieve(image_url, image_path)

def upload_image_file(image_sha: str):
	try:
		image_path = const.IMAGE_PATH + "/{}.jpg".format(image_sha)

		response = requests.post(const.DESTINATION_SERVER + const.UPLOAD_IMAGE_ROUTE,
														 auth=HTTPBasicAuth(username=const.DESTINATION_USERNAME, 
														 										password=const.DESTINATION_PASSWORD),
														 headers={"BiruniUpload": "param"},
														 timeout=(5, 30),
														 files={
														 		"files": ('migrated_img.jpg', open(image_path, 'rb'), 'application/octet-stream'),
														 		"param": (None, "{}", 'application/json'),
														 })
		if response.status_code != 200:
				raise Exception(response.text)
		return True
	except Exception as e:
		print_exception("upload_image_file -> {}\n".format(str(e)))
		return False

def upload_image_shas(persons):
	if len(persons) == 0:
		return None
	
	try:
		response = requests.post(const.DESTINATION_SERVER + const.UPLOAD_SHAS_ROUTE,
														 auth=HTTPBasicAuth(username=const.DESTINATION_USERNAME, password=const.DESTINATION_PASSWORD),
														 timeout=(5, 30),
														 data=json.dumps(persons))
		if response.status_code != 200:
			raise Exception(response.text)
	except Exception as e:
		print_exception("upload_image_shas -> {}\n".format(str(e)))

def load_images(cursor: int):
	response = load_image_shas(cursor)

	if response is None:
		return (-1, [])

	persons = response["data"]
	next_cursor = response["meta"]["next_cursor"]

	if persons is None:
		return (-1, [])
	
	for person in persons:
		for photo in person["photos"]:
			load_image(photo["photo_sha"])

	return (int(next_cursor), persons)

def upload_images(persons):
	for person in persons:
		for photo in person["photos"]:
			photo["photo_uploaded"] = 'Y' if upload_image_file(photo["photo_sha"]) else 'N'

	upload_image_shas(persons)
			
def migr_images():
	cursor = const.INITIAL_CURSOR
	max_iter = const.MAX_ITER_COUNT

	while cursor >= 0 and max_iter >= 0:
		cursor, persons = load_images(cursor)

		print("loaded images")
		
		upload_images(persons)

		print("uploaded images")

		print("next cursor: {}".format(cursor))

		max_iter -= 1
	
	print("next cursor: {}".format(cursor))

if __name__ == '__main__':
  migr_images()
