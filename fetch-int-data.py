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


def read_ref_selected_countries() -> dict:
    # read data for selected countries from csv file
    d_countries = {}
    with open('data/ref_selected_countries.csv', mode='r', encoding='utf-8') as f:
        csv_reader = csv.DictReader(f, dialect='excel', delimiter="\t")
        for row in csv_reader:
            d = {}
            for key in ('Code', 'Population', 'Pop_Density', 'GDP_mon_capita'):
                d[key] = row[key]
            d_countries[row["Country"]] = d
    return d_countries


d_selected_countries = read_ref_selected_countries()

# TODO: download_new_data()

with open(json_file, encoding='utf-8') as f:
    json_data = json.load(f)

# extract latest entry per country into data/countries-latest.csv
with open('data/countries-latest.csv', 'w') as f:
    csvwriter = csv.writer(f, delimiter="\t")
    csvwriter.writerow(
        ('Country', 'Date', 'Confirmed', 'Deaths', 'Recovered', 'Population')
    )
    for country in sorted(json_data.keys(), key=str.casefold):
        country_data = json_data[country]
        entry = country_data[-1]  # last entry per
        pop = ""
        if country in d_selected_countries:
            pop = int(d_selected_countries[country]['Population'])
            print(
                f"{country}\t{entry['deaths']}\t%.1f" % (int(entry['deaths'])/pop*1000000))
        csvwriter.writerow(
            (country, entry['date'], entry['confirmed'],
             entry['deaths'], entry['recovered'], pop)
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
