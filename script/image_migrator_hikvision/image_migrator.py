import const
import sys
import linecache
import json
import requests
from requests.auth import HTTPBasicAuth
import urllib.request
import ssl

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

def load_image(person: int):
	try:
		image_path = const.IMAGE_PATH + "/{}.jpg".format(person['person_code'])

		image_url = const.SOURCE_SERVER + const.DOWNLOAD_IMAGE_ROUTE.format(person['person_code'])

		urllib.request.urlretrieve(image_url, image_path)
	except Exception as e:
		print_exception("load_image -> {}\n".format(str(e)))

def upload_image_shas(person):
	try:
		image_path = const.IMAGE_PATH + "/{}.jpg".format(person['person_code'])

		data = {
			'person_code': person['person_code'],
			'server_id': person['server_id'],
			'org_code': person['org_code'],
			'photo_sha': '\u00000',
		}

		headers = {
			'BiruniUpload': 'param',
		}
		response = requests.post(const.DESTINATION_SERVER + const.UPLOAD_IMAGE_ROUTE,
														 headers=headers,
														 auth=HTTPBasicAuth(username=const.DESTINATION_USERNAME, password=const.DESTINATION_PASSWORD),
														 timeout=(5, 30),
														 files={
														 		"files[0]": ('migrated_img.jpg', open(image_path, 'rb'), 'image/jpeg'),
														 		"param": (None, json.dumps(data), 'application/json'),
														 })
		if response.status_code != 200:
			raise Exception(response.text)
	except Exception as e:
		print_exception("upload_image_shas -> {}\n".format(str(e)))

def load_images():
	for person in const.PERSONS:
		load_image(person)

def upload_images():
	for person in const.PERSONS:
		upload_image_shas(person)
			
def migr_images():
	load_images()

	upload_images()

if __name__ == '__main__':
	ssl._create_default_https_context = ssl._create_unverified_context
	migr_images()
