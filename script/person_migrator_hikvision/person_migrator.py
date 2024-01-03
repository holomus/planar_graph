import ssl
import const
import tqdm
from device import Device
from server import Server

device = Device(const.DEVICE_IP, const.DEVICE_LOGIN, const.DEVICE_PASSWORD)
server = Server()

if __name__ == '__main__':
	ssl._create_default_https_context = ssl._create_unverified_context
	person_list = device.list()

	for person in tqdm(person_list, desc='Downloading persons'):
		person['has_photo'] = device.person_photo(person['employee_id'])

	for person in tqdm(person_list, desc='Uploading persons'):
		server.upload_person(person)



