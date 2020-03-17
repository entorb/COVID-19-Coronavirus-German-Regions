# by Torben Menke
# https://entorb.net
# date 2020-03-12


load "header.gp"

data = '../data/countries-latest-selected.csv'

set label 1 "by Torben (https://entorb.net)" rotate by 90 center at screen 0.985, screen 0.5


# Deaths

set xtics rotate by 60 offset 1,0 right
# set bmargin 10.5
set style fill solid 0.5 border 0
set boxwidth 0.75 relative
set key off
set yrange [0:]

title = "Deaths"
set title title
set ylabel "Deaths"
set output '../plots-gnuplot/countries-latest-selected-deaths.png'
plot data u 4:xticlabels(1) with boxes ls 11
unset output
#
title = title." - Log Scale"
set title title
set logscale y
set output '../plots-gnuplot/countries-latest-selected-deaths-log.png'
replot
unset output
unset logscale y

title = "Deaths per Million Population"
set title title
set ylabel "Deaths per Million Population"
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


# plot and fit time series


# text will be inserted later on
set label 2 "" right front at graph 0.3, graph 0.22
set ylabel "Deaths"
set xlabel "Days"

col = 4

country_code = "DE"
country_name = "Germany"
load "plot-countries-sub1.gp"

country_code = "IT"
country_name = "Italy"
load "plot-countries-sub1.gp"

country_code = "ES"
country_name = "Spain"
load "plot-countries-sub1.gp"
