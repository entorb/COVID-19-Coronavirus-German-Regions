import csv
import urllib.request

import json

# data source: https://github.com/pomber/covid19
url = "https://pomber.github.io/covid19/timeseries.json"
json_file = 'data/international-timeseries.json'


def download_new_data():
    filedata = urllib.request.urlopen(url)
    datatowrite = filedata.read()
    with open(json_file, 'wb') as f:
        f.write(datatowrite)


def read_json_data() -> dict:
    # read json file contents
    with open(json_file, encoding='utf-8') as f:
        return json.load(f)


def read_ref_selected_countries() -> dict:
    # read data for selected countries from csv file
    d_countries = {}
    with open('data/ref_selected_countries.csv', mode='r', encoding='utf-8') as f:
        csv_reader = csv.DictReader(f, dialect='excel', delimiter=";")
        for row in csv_reader:
            d = {}
            for key in ('Code',):
                d[key] = row[key]
            for key in ('Population',):
                d[key] = int(row[key])
            for key in ('Pop_Density', 'GDP_mon_capita'):
                d[key] = float(row[key])
            d_countries[row["Country"]] = d
    return d_countries


d_selected_countries = read_ref_selected_countries()

# TODO: uncomment
# download_new_data()

d_json_data = read_json_data()

# for all countries in json: extract latest entry into data/countries-latest-all.csv
with open('data/countries-latest-all.csv', 'w') as f:
    csvwriter = csv.writer(f, delimiter="\t")
    csvwriter.writerow(
        ('Country', 'Date', 'Confirmed', 'Deaths', 'Recovered')
    )
    for country in sorted(d_json_data.keys(), key=str.casefold):
        country_data = d_json_data[country]
        entry = country_data[-1]  # last entry per
        csvwriter.writerow(
            (country, entry['date'], entry['confirmed'],
             entry['deaths'], entry['recovered'])
        )


# for my selected countries: extract latest of json and calculate per capita values into into data/countries-latest-selected.csv
with open('data/countries-latest-selected.csv', 'w') as f:
    csvwriter = csv.writer(f, delimiter="\t")
    csvwriter.writerow(
        ('Country', 'Date', 'Confirmed', 'Deaths', 'Recovered',
         'Confirmed_per_Million', 'Deaths_per_Million', 'Recovered_per_Million')
    )
    for country in sorted(d_selected_countries.keys(), key=str.casefold):
        country_data = d_json_data[country]
        entry = country_data[-1]  # last entry per
        pop_in_Mill = d_selected_countries[country]['Population'] / 1000000
        csvwriter.writerow(
            (country, entry['date'], entry['confirmed'],
             entry['deaths'], entry['recovered'], "%.3f" % (entry['confirmed']/pop_in_Mill), "%.3f" % (entry['deaths']/pop_in_Mill), "%.3f" % (entry['recovered']/pop_in_Mill))
        )


# TODO
# am I missing further intersting countries ?
# for selected countries write into csv: all 3 data per capita
# export time series for interesting countries to files

# data_de = json_data['Germany']
# for entry in data_de:
#     print(
#         f"{entry['date']}\t{entry['confirmed']}\t{entry['deaths']}\t{entry['recovered']}")
# print(json_data)
