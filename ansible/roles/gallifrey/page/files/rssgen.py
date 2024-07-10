#!/usr/bin/env python3
import argparse
import datetime
import sys

from bs4 import BeautifulSoup

"""Generate an RSS feed from arguments and a set of links from stdin"""

ITEM_TPL = """<item>
  <title>{title}</title>
  <link>https://boards.greenhouse.io/{link}</link>
  <description>{description}</description>
</item>"""

RSS_TPL = """<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
  <title>{title}</title>
  <link>{link}</link>
  <description>{description}</description>
  <pubDate>{pub_date}</pubDate>
  {items}
</channel>
</rss>"""

def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--title', help='Feed title')
    parser.add_argument('--link', help='Feed link')
    parser.add_argument('--description', help='Feed description')
    return parser.parse_args()


def main():
    args = parse_args()
    soup = BeautifulSoup(sys.stdin, features='html.parser')
    items = []
    for link in soup.find_all('a'):
        items.append(
            ITEM_TPL.format(
                title=link.text,
                link=link.attrs['href'],
                description=link.text
            )
        )
    print(
        RSS_TPL.format(
            title=args.title,
            link=args.link,
            description=args.description,
            pub_date=datetime.datetime.now().strftime("%a, %d %b %Y %H:%M:%S"),
            items='\n'.join(items)
        )
    )


if __name__ == "__main__":
    main()
