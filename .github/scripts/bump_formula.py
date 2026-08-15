#!/usr/bin/env python3
"""Bump Formula/brow.rb to the latest brow-cli release on PyPI, in place."""
import json
import os
import re
import sys
import urllib.request

FORMULA = os.path.join(os.path.dirname(__file__), "..", "..", "Formula", "brow.rb")

# brow-cli relicensed from MIT to Elastic-2.0 after 1.2.0 (releases <=1.2.0
# remain MIT). PyPI's JSON metadata doesn't reliably expose the license for
# this project's build backend, so the cutoff is tracked here by hand rather
# than fetched.
LAST_MIT_VERSION = (1, 2, 0)


def version_tuple(v):
    return tuple(int("".join(c for c in p if c.isdigit()) or 0) for p in v.split("."))


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

    license_id = "MIT" if version_tuple(latest) <= LAST_MIT_VERSION else "Elastic-2.0"
    formula = re.sub(r'license "[^"]*"', f'license "{license_id}"', formula)

    with open(FORMULA, "w") as f:
        f.write(formula)

    write_output("changed", "true")
    write_output("version", latest)


if __name__ == "__main__":
    sys.exit(main())
