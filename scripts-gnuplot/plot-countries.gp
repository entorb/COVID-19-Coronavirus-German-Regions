# by Torben Menke
# https://entorb.net
# date 2020-03-12


load "header.gp"

data = '../data/countries-latest-selected.tsv'

date_last = system("tail -1 " . data . " | cut -f2")

set label 1 label1_text_right." based on JHU data of ".date_last

# Deaths

set xtics rotate by 60 offset 1,0 right
# set bmargin 10.5
set style fill solid 0.5 border 0
set boxwidth 0.75 relative
set key off
set yrange [0:]

title = "Casualties"
set title title
set ylabel "Casualties"
set output '../plots-gnuplot/countries-latest-selected-deaths.png'
plot data u 4:xticlabels(1) with boxes ls 11
unset output
#
title = title." - Log Scale"
set title title
set logscale y
set output '../plots-gnuplot/countries-latest-selected-deaths-log.png'
set yrange [1:]
replot
unset output
unset logscale y
unset yrange

title = "Casualties per Million Population"
set title title
set ylabel "Casualties per Million Population"
set output '../plots-gnuplot/countries-latest-selected-deaths-per-mill.png'
plot data u 7:xticlabels(1) with boxes ls 11
unset output
#
title = title." - Log Scale"
set title title
set logscale y
set output '../plots-gnuplot/countries-latest-selected-deaths-per-mill-log.png'
replot
unset output
unset logscale y

title = "Duplications until hitting Italy's casualties per capita\n(larger means more time to prepare)"
set yrange [0:]
deaths_per_million_of_IT = system ("grep Italy ../data/countries-latest-selected.tsv| tail -1 | cut -f7") + 0
print deaths_per_million_of_IT
set title title
set ylabel "Duplications"
set output '../plots-gnuplot/countries-duplications-until-IT-level-of-casulties.png'
plot data u (log(deaths_per_million_of_IT/$7)/log(2)):xticlabels(1) with boxes ls 11
unset output

# combining the duplications until reaching IT level from countries-latest-selected.tsv and the duplication time from countries-gnuplot-fit.tsv
# this needs the python script join-country-latest-and-fit-data.py to run first after plotting
set title "Days until hitting Italy's casualties per capita\nbased on current casualties and fitted duplication time"
set ylabel "Days (estimated)"
set yrange [0:28]
set ytics 0,7
out = system ("cd .. ; python join-country-latest-and-fit-data.py ; cd scripts-gnuplot")
print out
data = '../data/countries-joined_selected_and_gnuplot_fit.tsv'
set output '../plots-gnuplot/countries-days-until-IT-level-of-casulties.png'
plot data u 18:xticlabels(1) with boxes ls 11
unset output
unset yrange
unset ytics
# plot and fit time series


# text will be inserted later on
set label 2 "" right front at graph 0.3, graph 0.6
set ylabel "Casualties"
set xlabel "Days"
# set lmargin 9

col = 4

fit_data_file = "../data/countries-gnuplot-fit.tsv"
set print fit_data_file
print "# Country\tCode\ta\tb\tDeaths\tDoubling time\tFactor at t+1\tDeaths at t+1\tFactor at t+7\tDeaths at t+7"
unset print

country_code = "AT" ; country_name = "Austria" ; load "plot-countries-sub1.gp"
country_code = "BE" ; country_name = "Belgium" ; load "plot-countries-sub1.gp"
# country_code = "FI" ; country_name = "Finland" ; load "plot-countries-sub1.gp"
country_code = "FR" ; country_name = "France" ; load "plot-countries-sub1.gp"
country_code = "DE" ; country_name = "Germany" ; load "plot-countries-sub1.gp"
country_code = "HU" ; country_name = "Hungary" ; load "plot-countries-sub1.gp"
country_code = "IR" ; country_name = "Iran" ; load "plot-countries-sub1.gp"
country_code = "IT" ; country_name = "Italy" ; load "plot-countries-sub1.gp"
country_code = "JP" ; country_name = "Japan" ; load "plot-countries-sub1.gp"
country_code = "KR" ; country_name = "Korea, South" ; load "plot-countries-sub1.gp"
country_code = "NL" ; country_name = "Netherlands" ; load "plot-countries-sub1.gp"
country_code = "ES" ; country_name = "Spain" ; load "plot-countries-sub1.gp"
country_code = "SE" ; country_name = "Sweden" ; load "plot-countries-sub1.gp"
country_code = "CH" ; country_name = "Switzerland" ; load "plot-countries-sub1.gp"
country_code = "UK" ; country_name = "United Kingdom" ; load "plot-countries-sub1.gp"
country_code = "US" ; country_name = "US" ; load "plot-countries-sub1.gp"

# delete fit logfile
`rm fit.log`

unset xrange
unset yrange
unset label 2
unset label 3
unset xlabel
unset ylabel

# let's plot the fit data as boxes
set title "Fit Result: Casualties Doubling Time (days)"
set ylabel "Casualties Doubling Time (days)"
set xtics rotate by 60 offset 1,0 right
set ytics format "%g" 
unset bmargin
set style fill solid 0.5 border 0
set boxwidth 0.75 relative
set key off
set yrange [0:]
# y_value_de = ( system("tail -1 " . fit_data_file . " | cut -f6") + 0)
set output '../plots-gnuplot/countries-fit-deaths-doubling-time.png'
plot fit_data_file u 6:xticlabels(1) with boxes ls 11
#, y_value_de
unset output
set ytics format "%g%%" 
set title "Fit Result: Increase of Casualties per Day"
set ylabel "Increase Casualties per Day"
# y_value_de = ( system("tail -1 " . fit_data_file . " | cut -f7") + 0)
# y_value_de = (y_value_de-1)*100
set output '../plots-gnuplot/countries-fit-deaths-increase-1-day.png'
plot fit_data_file u (($7-1)*100):xticlabels(1) with boxes ls 11
# , y_value_de
unset output

