#!/bin/bash

# dir_old=$PWD
# dir_of_this_script="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# cd dir_of_this_script

python fetch-country-data.py
rm plots-gnuplot/*.png
cd scripts-gnuplot
gnuplot plot-de.gp
gnuplot plot-countries.gp
cd ..
rsync -rvhu --delete --delete-excluded plots-gnuplot/*.png entorb@entorb.net:html/COVID-19-coronavirus/plots-gnuplot/
rsync -rvhu --delete --delete-excluded plots-excel/*.png entorb@entorb.net:html/COVID-19-coronavirus/plots-excel/

# cd dir_old