import json
import requests
from requests.auth import HTTPBasicAuth
from pathlib import Path

import util
import const

class Server:
	def _upload_person_no_image(self, person):
		data = {
			'employee_code': person['employee_id'],
			'employee_name': person['name'],
		}
		
		response = requests.post(const.DESTINATION_SERVER + const.UPLOAD_PERSON_ROUTE,
															auth=HTTPBasicAuth(username=const.DESTINATION_USERNAME, password=const.DESTINATION_PASSWORD),
															timeout=(5, 30),
															data=json.dumps(data))
		if response.status_code != 200:
			raise Exception(response.text)

	def _upload_person_with_image(self, person):
		image_path = const.IMAGE_PATH + "/{}.jpg".format(person['employee_id'])

		data = {
			'employee_code': person['employee_id'],
			'employee_name': person['name'],
			'photo_sha': '\u00000',
		}

		headers = {
			'BiruniUpload': 'param',
		}
		response = requests.post(const.DESTINATION_SERVER + const.UPLOAD_PERSON_ROUTE,
															headers=headers,
															auth=HTTPBasicAuth(username=const.DESTINATION_USERNAME, password=const.DESTINATION_PASSWORD),
															timeout=(5, 30),
															files={
																"files[0]": ('migrated_img.jpg', open(image_path, 'rb'), 'image/jpeg'),
																"param": (None, json.dumps(data), 'application/json'),
															})
		if response.status_code != 200:
			raise Exception(response.text)

	def upload_person(self, person):
		file_path = Path(const.IMAGE_PATH + "/{}.jpg".format(person['employee_id']))
		
		try:
			if file_path.is_file():
				self._upload_person_with_image(person)
			else:
				self._upload_person_no_image(person)
		except Exception as e:
			util.print_exception("upload_person -> {}\n".format(str(e)))
