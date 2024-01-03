from threading import Timer, Thread
from time import time

from apscheduler.schedulers.background import BackgroundScheduler


class Task:
    def __init__(self, function, args=None, seconds=None):
        self.function = function
        self.args = args
        self.seconds = seconds
        self.job = None
        self.timer = None
        self.is_posted = False
        self.post_time = None

    def init(self):
        self.job = None
        self.timer = None
        self.is_posted = False
        self.post_time = None
        return self

    def time_passed(self):
        if not self.post_time:
            return None
        now_time = time() * 1000
        return round((now_time - self.post_time) / 1000.0)

    def remove(self):
        if self.job:
            self.job.remove()

        if self.timer:
            self.timer.cancel()

        self.init()

        return self

    def post(self, args=None):
        self.init()
        self.is_posted = True
        self.post_time = round(time() * 1000)
        func_args = args if args else self.args
        if self.seconds:
            self.post_delay(seconds=self.seconds)
        else:
            Thread(target=self.function, args=func_args, daemon=True).start()
        return self

    def post_delay(self, seconds, args=None):
        self.init()
        self.is_posted = True
        self.post_time = round(time() * 1000)
        func_args = args if args else self.args
        interval_time = seconds if seconds else self.seconds
        self.timer = Timer(interval=interval_time, function=self.function, args=func_args)
        self.timer.setDaemon(daemonic=True)
        self.timer.start()
        return self

    def post_interval(self, seconds, args=None):
        self.init()
        self.is_posted = True
        self.post_time = round(time() * 1000)
        interval_time = seconds if seconds else self.seconds
        func_args = args if args else self.args
        scheduler = BackgroundScheduler()
        self.job = scheduler.add_job(func=self.function, trigger='interval', seconds=interval_time, args=func_args)
        scheduler.start()
        return self
