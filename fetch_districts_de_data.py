#!/usr/bin/python3

"""
German regions in more detail.

Data: the ArcGIS REST API of the RKI Corona Dashboard
"""

from typing import Dict
import os
import subprocess
import datetime
import logging

import requests


LOG = logging.getLogger(__name__)
SEP = "\t"
TMPDIR = "./tmp/"
API_STRING = ("https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/"
              "RKI_Landkreisdaten/FeatureServer/0/query?f=json&where=1%3D1"
              "&returnGeometry=false&spatialRel=esriSpatialRelIntersects"
              "&outFields=*&orderByFields=cases%20desc&outSR=102100&resultOffset=0"
              "&resultRecordCount=1000&cacheHint=true")


class NoResponseException(Exception):
    """Exception class for data downloads."""


def dict_to_table(json: Dict, add_header: bool):
    """
    Prints the json result from the API as separated values.
    """
    for row, obj in enumerate(json['features']):
        if add_header and row == 0:
            line = ""
            for col, item in enumerate(obj["attributes"].items()):
                line += (SEP if col else "") + item[0]
            yield line + SEP + "Request date"
        line = ""
        for col, item in enumerate(obj["attributes"].items()):
            line += (SEP if col else "") + str(item[1])
        yield line + SEP + datetime.date.isoformat(datetime.date.today())


def fetch_data(url: str) -> Dict:
    """
    Download json file from given api_string.
    """
    response = requests.get(url)

    if response.status_code != 200:
        raise NoResponseException("No response, status code: %d" % response.status_code)

    return response.json()


def main(args: object) -> int:
    """
    First argument: file for storage that will also be committed.
    """
    try:
        with open(args.filename, 'a') as outfile:
            for line in dict_to_table(fetch_data(args.url),
                                      add_header=os.stat(args.filename).st_size == 0):
                outfile.write("%s\n" % line)
    except NoResponseException as exc:
        LOG.error(exc)
        return 1
    except subprocess.CalledProcessError as exc:
        LOG.error(exc)
        return exc.returncode
    else:
        return 0


if __name__ == "__main__":
    import sys
    import argparse

    PARSER = argparse.ArgumentParser(description="Fetch and commit current data.")
    PARSER.add_argument('filename', type=str,
                        help="File to store and commit")
    PARSER.add_argument('-u', '--url', type=str, default=API_STRING,
                        help="REST URL")

    sys.exit(main(PARSER.parse_args()))
