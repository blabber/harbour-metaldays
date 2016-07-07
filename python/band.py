# "THE BEER-WARE LICENSE" (Revision 42):
# <tobias.rehbein@web.de> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return.
#                                                             Tobias Rehbein

import html.parser
import string

class Parser(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()

        self.genre = "unknown"

        self.__in_header = False
        self.__in_header_span = False

    def handle_starttag(self, tag, attrs):
        if tag == 'div':
            ad = dict(attrs)

            try:
                c = ad['class']
            except KeyError:
                return

            cs = c.split(' ')

            if 'content_header' in cs:
                self.__in_header = True

        if tag == 'span' and self.__in_header:
            self.__in_header = False
            self.__in_header_span = True

    def handle_data(self, data):
        if self.__in_header_span:
            self.__in_header_span = False
            self.genre = string.capwords(data)

def get_genre(c):
    p = Parser()
    p.feed(c)
    return p.genre
