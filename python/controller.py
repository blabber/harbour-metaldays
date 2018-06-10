# "THE BEER-WARE LICENSE" (Revision 42):
# <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return.
#                                                             Tobias Rehbein

import pyotherside
import threading
import urllib.request
import traceback
import sys
import ssl
import os
import os.path
import json

class JSendError(Exception):
    pass

class Controller:
    def __init__(self):
        self.bgthread = threading.Thread()
        self.bgthread.start()
        self.refresh()

    def refresh(self):
        if self.bgthread.is_alive():
            return

        self.bgthread = threading.Thread(target=self.__refresh_in_background)
        self.bgthread.start()

    def __refresh_in_background(self):
        try:
            self.__load_data()
        except JSendError as e:
            es = 'Backend error: {0}'.format(e)
            pyotherside.send('refreshError', es)
        except:
            traceback.print_exc()

            ei = sys.exc_info()
            es = ''.join(traceback.format_exception_only(ei[0], ei[1]))
            pyotherside.send('refreshError', es)

    def __load_data(self):
        url = 'https://gist.githubusercontent.com/blabber/babc4803141b0ec13fd613cc84eae074/raw'
        with open_request(url) as f:
            d = json.loads(f.read().decode('utf-8'))

        if d:
            if d['status'] == "error":
                raise JSendError(d['message'])
            pyotherside.send('dataLoaded', d)

def open_request(url):
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    return urllib.request.urlopen(url=url, context=ctx, timeout=20)

instance = Controller()

