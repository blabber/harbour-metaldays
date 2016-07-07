# "THE BEER-WARE LICENSE" (Revision 42):
# <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return.
#                                                             Tobias Rehbein

import html.parser
import urllib.request

class Parser(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()

        self.running_order = { 'days' : [] }
        self.number_of_events = 0

        self.__current_day = { }
        self.__current_stage = { }
        self.__current_event = { }

        self.__in_date = False
        self.__in_stage_name = False
        self.__in_time = False
        self.__in_title = False

    def handle_starttag(self, tag, attrs):
        ad = dict(attrs)

        try:
            c = ad['class']
        except KeyError:
            return

        cs = c.split(' ')

        if 'lineup_day' in cs:
            self.__current_day = { 'stages' : [] }
            self.running_order['days'].append(self.__current_day)

        elif 'l-stage' in cs:
            self.__current_stage = { 'events' : [] }
            self.__current_day['stages'].append(self.__current_stage)
            self.__in_date = True

        elif 'band_lineup' in cs:
            self.__current_event = { }
            self.__current_event['url'] = ad['href']
            self.__current_stage['events'].append(self.__current_event)
            self.number_of_events = self.number_of_events + 1

        elif 'time' in cs:
            self.__in_time = True

        elif 'title' in cs:
            self.__in_title = True

    def handle_data(self, data):
        if self.__in_date:
            self.__in_date = False
            self.__current_day['date'] = data.replace('. ', '.')
            self.__in_stage_name = True

        elif self.__in_stage_name:
            self.__in_stage_name = False
            self.__current_stage['name'] = data

        elif self.__in_time:
            self.__in_time = False
            self.__current_event['time'] = data

        elif self.__in_title:
            self.__in_title = False
            self.__current_event['title'] = data

if __name__ == '__main__':
    p = Parser()
    url = 'http://www.metaldays.net/Line_up'
    with urllib.request.urlopen(url=url, timeout=10) as f:
        p.feed(f.read().decode('utf-8'))

    print(p.running_order)

