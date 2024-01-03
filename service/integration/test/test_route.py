import os

from network.route import RESTApi

file_path = "C:\\Users\\axmad\\Documents\\greenwhite\\verifix_hr\\integration\\cache\\event_image\\2b864da4e90f65f60c33558101bff9f54efcea236693fae9afc451f945c9c677.jpeg"
RESTApi().upload_files(file_path=file_path)
os.remove(file_path)
