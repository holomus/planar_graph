from urllib.parse import urljoin

from requests import Session
from requests.auth import HTTPDigestAuth


class LiveServerSession(Session):
    def __init__(self, prefix_url=None, *args, **kwargs):
        super(LiveServerSession, self).__init__(*args, **kwargs)
        self.prefix_url = prefix_url

    def request(self, method, url, *args, **kwargs):
        url = urljoin(self.prefix_url, url)
        print("request: " + str(url))
        return super(LiveServerSession, self).request(method, url, *args, **kwargs)


def get_session(host, login, password):
    session = LiveServerSession(host)
    session.auth = HTTPDigestAuth(login, password)
    return session
