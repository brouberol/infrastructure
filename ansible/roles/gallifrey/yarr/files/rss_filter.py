#!/usr/bin/env python3
from feedgen.feed import FeedGenerator
import feedparser
import argparse


def add_entry_to_feed(feed, entry):
    fe = feed.add_entry()
    fe.id(entry.get('id'))
    fe.title(entry.get('title'))
    fe.link(href=entry.get('link'))
    fe.description(entry.get('description'))
    fe.pubDate(entry.get('published'))


def filter_feed(input_url, search_string, negative_filter, output_filename):
    """
    Filter an RSS feed to include only entries whose titles contain the specified substring.

    Args:
        input_url (str): URL of the input RSS feed
        search_string (str): Substring to search for in entry titles

    Returns:
        str: Path to the filtered RSS feed file
    """
    # Get the source feed
    source_feed = feedparser.parse(input_url)

    # Parse the input feed
    fg = FeedGenerator()
    fg.id(input_url)
    fg.link(href=input_url)
    fg.description(f"Filtered feed from {input_url}")
    fg.title(source_feed.feed.title)



    # Add entries that match our criteria
    for entry in source_feed.entries:
        if negative_filter and negative_filter.lower() not in entry.get('title', '').lower():
            add_entry_to_feed(fg, entry)
        else:
            for field in ('title', 'description'):
                if search_string and search_string.lower() in entry.get(field, '').lower():
                    add_entry_to_feed(fg, entry)

    # Save the feed
    fg.rss_file(output_filename)
def main():
    parser = argparse.ArgumentParser(description='Filter an RSS feed based on title substring')
    parser.add_argument('--url', help='URL of the RSS feed to filter')
    parser.add_argument('--filter', help='Substring to search for in entry titles/descriptions')
    parser.add_argument('--negative-filter', help='Substring to exclude from entry titles')
    parser.add_argument('--output', help='Output filename')
    args = parser.parse_args()

    filter_feed(args.url, args.filter, args.negative_filter, args.output)


if __name__ == "__main__":
    main()