from flask import Flask

from common import Task
from network import RESTApi

count = 0
task: Task = None
job: Task = None


def test():
    global count
    count += 1
    print("run test def " + str(count))


def timer_job(integer_id):
    print("timer job " + str(integer_id))

    counter = 0
    while counter <= 100:
        result = str(len(str(RESTApi().load_data())))
        if counter > 95:
            print("load data " + result)
        counter += 1

    stop_job()


def stop_timer(is_stop_job: bool):
    global task
    print("stop timer")

    if task is not None:
        task.remove()
        task = None
        print("task remove")

    if is_stop_job:
        stop_job()


def stop_job():
    global job
    print("stop_job")
    if job is not None:
        print('start remove job')
        job.remove()
        job = None
        print('removed job')
    else:
        print("job is removed")


if __name__ == '__main__':
    print(str(RESTApi().load_data()))

    task = Task(function=timer_job, args=(121,)).post_delay(seconds=5)

    job = Task(function=test).post_interval(seconds=1)

    Task(function=stop_timer, args=(False,)).post_delay(seconds=6)
    Task(function=stop_timer, args=(True,)).post_delay(seconds=10)

    app = Flask(__name__)
    app.run("0.0.0.0", port=1558)
