#!/usr/bin/env python3
"""Check whether Unreal package/object paths resolve to local asset files.

Usage:
  python quick_asset_check.py --root . --asset /Game/UI/WBP_HUD
  python quick_asset_check.py --root . --asset "Blueprint'/Game/UI/WBP_HUD.WBP_HUD'"
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


OBJECT_PATH_RE = re.compile(r"^(?:[A-Za-z]+')?(?P<path>/[^']+?)(?:')?$")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check Unreal asset existence by package/object path.")
    parser.add_argument("--root", default=".", help="Project root containing Content/")
    parser.add_argument("--asset", action="append", required=True, help="Asset path such as /Game/Foo/Bar")
    return parser.parse_args()


def normalize_package_path(value: str) -> str:
    value = value.strip().strip('"')
    match = OBJECT_PATH_RE.match(value)
    if match:
        value = match.group("path")
    if "." in value:
        value = value.split(".", 1)[0]
    if value.endswith("_C"):
        value = value[:-2]
    return value


def package_to_uasset_path(root: Path, package: str) -> Path:
    package = normalize_package_path(package).strip("/")
    if not package.startswith("Game/"):
        raise ValueError(f"Unsupported package root in '{package}'. Expected '/Game/...'.")
    relative = package[len("Game/") :]
    return root / "Content" / f"{relative}.uasset"


def main() -> int:
    args = parse_args()
    root = Path(args.root).resolve()
    missing: list[str] = []

    print(f"Project root: {root}")
    for asset in args.asset:
        try:
            uasset = package_to_uasset_path(root, asset)
        except ValueError as exc:
            print(f"[INVALID] {exc}")
            missing.append(asset)
            continue

        if uasset.exists():
            print(f"[OK] {asset} -> {uasset}")
        else:
            print(f"[MISSING] {asset} -> {uasset}")
            missing.append(asset)

    if missing:
        print(f"\nMissing/invalid entries: {len(missing)}")
        return 2

    print("\nAll requested assets are present.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
