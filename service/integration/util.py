import linecache
import sys
import time

from PIL import Image


def print_exception(prefix=""):
    exc_type, exc_obj, tb = sys.exc_info()
    f = tb.tb_frame
    lineno = tb.tb_lineno
    filename = f.f_code.co_filename
    linecache.checkcache(filename)
    line = linecache.getline(filename, lineno, f.f_globals)
    print(prefix + ' except({}, LINE {} "{}"): {}'.format(filename, lineno, line.strip(), exc_obj))


def convert_device_datetime(date_time: str):
    a = date_time.split("T")
    b = a[1].split("+")
    date = a[0].split("-")
    time = b[0]
    # timezone = b[1]

    yyyy = date[0]
    mm = date[1]
    dd = date[2]
    return "{}.{}.{} {}".format(dd, mm, yyyy, time)


def parse_to_milliseconds(date_time: str):
    date_time = convert_device_datetime(date_time)
    return round(time.mktime(time.strptime(date_time, "%d.%m.%Y %H:%M:%S")) * 1000.0)


def image_resize(path, size=300):
    img = Image.open(path)
    wpercent = (size / float(img.size[0]))
    hsize = int((float(img.size[1]) * float(wpercent)))
    img = img.resize((size, hsize), Image.ANTIALIAS)
    if img.mode in ["RGBA", "P"]:
        img = img.convert("RGB")
    img.save(path, format="JPEG", quality=95)
