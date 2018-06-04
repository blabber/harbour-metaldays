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

class Controller:
    def __init__(self):
        self.bgthread = threading.Thread()
        self.bgthread.start()

        home = os.path.expanduser('~')

        xdg_cache_home = os.environ.get('XDG_CACHE_HOME', os.path.join(home, '.cache'))
        self.cache_file = os.path.join(xdg_cache_home, "harbour-metaldays", "cache.json")

        self.__load_cache()

    def load_data(self):
        url = 'https://gist.githubusercontent.com/blabber/babc4803141b0ec13fd613cc84eae074/raw'
        with open_request(url) as f:
            d = json.loads(f.read().decode('utf-8'))
        if d:
            pyotherside.send('dataLoaded', d)
            self.__save_cache(d)

    def __save_cache(self, d):
        os.makedirs(os.path.dirname(self.cache_file), exist_ok=True)

        with open(self.cache_file, 'w') as f:
            json.dump(d, f, indent=2)

    def __load_cache(self):
        if not os.path.exists(self.cache_file):
            self.refresh()
            return

        with open(self.cache_file, 'r') as f:
            d = json.load(f)

        if d:
            pyotherside.send('dataLoaded', d)

    def refresh(self):
        if self.bgthread.is_alive():
            return

        self.bgthread = threading.Thread(target=self.__refresh_in_background)
        self.bgthread.start()

    def __refresh_in_background(self):
        try:
            self.load_data()
        except:
            traceback.print_exc()

            ei = sys.exc_info()
            es = ''.join(traceback.format_exception_only(ei[0], ei[1]))
            pyotherside.send('refreshError', es)

def open_request(url):
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    return urllib.request.urlopen(url=url, context=ctx, timeout=20)

instance = Controller()

