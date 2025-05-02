#!/usr/bin/env python3

import sys

import xml.etree.ElementTree as ET
from urllib.parse import urlparse

xml = sys.stdin.read()
root =  ET.fromstring(xml)
for post_item in root.iter('item'):
    link = post_item.find('link')
    relpath = urlparse(link.text).path.replace("/wiki/Wikipedia:Wikipedia_Signpost", "")
    print(f"<a href='{relpath}'>{link.text}</a>")
