#!/usr/bin/env python3

import re
import sys

html = sys.stdin.read()
for (url_match, title_match) in zip(
    re.findall(r'"absolute_url":"([^"]+)"', html),
    re.findall(r'"title":"([^"]+)"', html)
):
    if 'Engineer' in title_match:
        print(f"<a href=\"{url_match}\">{title_match}</a>")
