import os
import pathlib

APP_PORT = 5000
APP_NAME = "PREDICT FACTS SERVICE"

VERIFIX_SERVER = "https://app2.verifix.com"

CURRENT_PATH = pathlib.Path(__file__).parent.resolve()
DATABASE_PATH = "{}/cache/database".format(CURRENT_PATH)

PREDICT_TYPE_WEEK = 'W'
PREDICT_TYPE_MONTH = 'M'
PREDICT_TYPE_QUARTER = 'Q'
PREDICT_TYPE_YEAR = 'Y' 
 
if not os.path.exists(DATABASE_PATH):
    os.makedirs(DATABASE_PATH)
