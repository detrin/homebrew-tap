#!/usr/bin/env python3
"""Bump Formula/brow.rb to the latest brow-cli release on PyPI, in place."""
import json
import os
import re
import sys
import urllib.request

FORMULA = os.path.join(os.path.dirname(__file__), "..", "..", "Formula", "brow.rb")


def fetch_json(url):
    with urllib.request.urlopen(url) as r:
        return json.load(r)


def write_output(name, value):
    path = os.environ.get("GITHUB_OUTPUT")
    if not path:
        print(f"{name}={value}")
        return
    with open(path, "a") as f:
        f.write(f"{name}={value}\n")


def main():
    with open(FORMULA) as f:
        formula = f.read()

    current = re.search(r"brow_cli-([\d.]+)\.tar\.gz", formula).group(1)
    latest = fetch_json("https://pypi.org/pypi/brow-cli/json")["info"]["version"]

    if latest == current:
        print(f"up to date at {current}")
        write_output("changed", "false")
        return

    print(f"bumping {current} -> {latest}")
    release = fetch_json(f"https://pypi.org/pypi/brow-cli/{latest}/json")
    sdist = next(u for u in release["urls"] if u["packagetype"] == "sdist")
    url = sdist["url"]
    sha256 = sdist["digests"]["sha256"]

    formula = re.sub(r'url "[^"]*brow_cli-[^"]*\.tar\.gz"', f'url "{url}"', formula)
    formula = re.sub(r'sha256 "[0-9a-f]{64}"', f'sha256 "{sha256}"', formula)
    formula = re.sub(r"brow-cli==[\d.]+", f"brow-cli=={latest}", formula)

    with open(FORMULA, "w") as f:
        f.write(formula)

    write_output("changed", "true")
    write_output("version", latest)


if __name__ == "__main__":
    sys.exit(main())
