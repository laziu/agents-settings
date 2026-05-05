#!/usr/bin/env python3
"""Summarize Unreal Engine log warnings and errors by category.

Usage:
  python scan_output_log.py --log Saved/Logs/MyProject.log --top 20
"""

from __future__ import annotations

import argparse
import collections
import re
from pathlib import Path


LOG_RE = re.compile(
    r"(?P<category>[A-Za-z_][A-Za-z0-9_]*):\s+"
    r"(?P<verbosity>Warning|Error|Fatal):\s*"
    r"(?P<message>.*)"
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Summarize Unreal log warnings/errors.")
    parser.add_argument("--log", required=True, help="Path to an Unreal .log file")
    parser.add_argument("--top", type=int, default=20, help="Number of categories to print")
    parser.add_argument("--samples", type=int, default=3, help="Sample messages per category")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    log_path = Path(args.log)
    if not log_path.exists():
        print(f"[ERROR] Log file not found: {log_path}")
        return 1

    totals: collections.Counter[str] = collections.Counter()
    by_category: collections.Counter[tuple[str, str]] = collections.Counter()
    samples: dict[tuple[str, str], list[str]] = collections.defaultdict(list)

    with log_path.open("r", encoding="utf-8", errors="replace") as handle:
        for raw_line in handle:
            match = LOG_RE.search(raw_line.strip())
            if not match:
                continue
            verbosity = match.group("verbosity")
            category = match.group("category")
            message = match.group("message").strip()
            key = (verbosity, category)
            totals[verbosity] += 1
            by_category[key] += 1
            if len(samples[key]) < args.samples and message:
                samples[key].append(message)

    print(f"Log: {log_path}")
    print(f"Errors: {totals['Error']}")
    print(f"Fatals: {totals['Fatal']}")
    print(f"Warnings: {totals['Warning']}")
    print()
    print("Top categories:")
    for key, count in by_category.most_common(args.top):
        verbosity, category = key
        print(f"- {verbosity:<7} {category}: {count}")
        for message in samples[key]:
            print(f"  sample: {message[:240]}")

    return 2 if totals["Fatal"] or totals["Error"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
