import pathlib
import sys
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from tidewatch import high_readings


class HighReadingsTest(unittest.TestCase):
    def test_keeps_readings_above_threshold(self):
        rows = [{"height_m": "3.1"}, {"height_m": "3.4"}]
        self.assertEqual(high_readings(rows), [{"height_m": "3.4"}])

    def test_skips_empty_height(self):
        self.assertEqual(high_readings([{"height_m": ""}]), [])


if __name__ == "__main__":
    unittest.main()
