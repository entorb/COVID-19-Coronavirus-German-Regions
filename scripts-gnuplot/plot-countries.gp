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

set title "Deaths"
set ylabel "Deaths"
set output '../plots-gnuplot/countries-latest-selected-deaths.png'
plot data u 4:xticlabels(1) with boxes linecolor rgb "red"
unset output
set title "Deaths per Million Population"
set ylabel "Deaths per Million Population"
set output '../plots-gnuplot/countries-latest-selected-deaths-per-mill.png'
plot data u 7:xticlabels(1) with boxes linecolor rgb "red"
unset output
