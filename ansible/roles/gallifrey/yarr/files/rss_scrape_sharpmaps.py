#!/usr/bin/env python3

import sys

from bs4 import BeautifulSoup

html = sys.stdin.read()
soup = BeautifulSoup(html, features="html.parser")
post_links = [link for link in soup.find_all('a') if link.attrs['href'].startswith('/posts')]
for post_link in post_links:
    print(f'<a href="{post_link.attrs["href"]}">{post_link.find("h3").text.strip()}</a>')