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

import runningorder
import band

class Controller:
    def __init__(self):
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def load_data(self):
        url = 'http://www.metaldays.net/Line_up'
        with open_request(url) as f:
            p = runningorder.Parser()
            p.feed(f.read().decode('utf-8'))
            pyotherside.send('numberOfEventsDetermined', p.number_of_events)
            d = self.__add__genres(p.running_order)
        if d:
            pyotherside.send('dataLoaded', d)

    def __add__genres(self, d):
        for day in d['days']:
            for stages in day['stages']:
                for event in stages['events']:
                    pyotherside.send('eventProcessed', event['title'])

                    g = 'unknown'
                    url = event['url']

                    if url and url != '#':
                        with open_request(url) as f:
                            g = band.get_genre(f.read().decode('utf-8'))

                    event['genre'] = g
        return d

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

