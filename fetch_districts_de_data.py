#!/usr/bin/python3

"""
German regions in more detail.

Data: the ArcGIS REST API of the RKI Corona Dashboard
"""

from typing import Dict, List
import logging
import requests


SEP = "\t"
TMPDIR = "./tmp/"
API_STRING = ("https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/"
              "RKI_Landkreisdaten/FeatureServer/0/query?f=json&where=1%3D1"
              "&returnGeometry=false&spatialRel=esriSpatialRelIntersects"
              "&outFields=*&orderByFields=cases%20desc&outSR=102100&resultOffset=0"
              "&resultRecordCount=1000&cacheHint=true")


def dict_to_table(json: Dict):
    """
    Prints the json result from the API as separated values.
    """
    for row, obj in enumerate(json['features']):
        if row == 0:
            line = ""
            for col, item in enumerate(obj["attributes"].items()):
                line += "%s%s" % (SEP if col else "", item[0])
            yield line
        line = ""
        for col, item in enumerate(obj["attributes"].items()):
            line += "%s%s" % (SEP if col else "", item[1])
        yield line


def main(args: List[str]) -> int:
    """
    No arguments required.
    """
    response = requests.get(API_STRING)

    if response.status_code != 200:
        logging.error("No response.")
        return 1

    for line in dict_to_table(response.json()):
        print(line)
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main(sys.argv))
