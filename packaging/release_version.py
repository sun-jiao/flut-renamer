#!/usr/bin/env python3
"""Parse release tags and validate their base version against pubspec.yaml."""
import argparse
import re
from pathlib import Path


def parse_tag(tag):
    match = re.fullmatch(
        r'v([0-9]+\.[0-9]+\.[0-9]+)(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?',
        tag,
    )
    if not match:
        raise ValueError('Release tags must use vX.Y.Z or vX.Y.Z-suffix')
    return match[1], tag[1:]


def validate_version(tag, pubspec):
    base, _ = parse_tag(tag)
    match = re.search(r'^version:\s*([0-9]+\.[0-9]+\.[0-9]+)(?:\+[0-9]+)?\s*$',
                      pubspec, re.MULTILINE)
    if not match:
        raise ValueError('Cannot read the version from pubspec.yaml')
    if base != match[1]:
        raise ValueError(f'Tag base version {base} does not match pubspec.yaml version {match[1]}')
    return base


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tag', required=True)
    parser.add_argument('--pubspec', type=Path, default=Path('pubspec.yaml'))
    args = parser.parse_args()
    try:
        print(validate_version(args.tag, args.pubspec.read_text()))
    except ValueError as error:
        parser.exit(1, f'{error}\n')
