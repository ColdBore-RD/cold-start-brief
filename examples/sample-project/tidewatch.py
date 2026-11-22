"""List tide readings above a threshold."""
import csv
import sys

THRESHOLD_M = 3.2


def high_readings(rows, threshold=THRESHOLD_M):
    return [row for row in rows if float(row["height_m"]) > threshold]


if __name__ == "__main__":
    with open(sys.argv[1], newline="", encoding="utf-8") as handle:
        for row in high_readings(csv.DictReader(handle)):
            print(row["time"], row["height_m"])
