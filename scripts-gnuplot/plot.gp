# by Torben Menke
# https://entorb.net
# date 2020-03-12


# set terminal png noenhanced large size 640,480
set terminal pngcairo size 640,480 font 'Verdana,9'
# set terminal svg size 640,480 fname 'Verdana, Helvetica, Arial, sans-serif' rounded dashed

set datafile commentschars '#'
# set datafile missing '#'
set datafile separator "\t"

data = '../data/cases-de.csv'

set encoding utf8

set grid xtics ytics
set xtics mirror
set ytics mirror 


set title "Titel"
# set ylabel "Cases"
# set xlabel "Days since first data"
set ylabel "Fälle"
set xlabel "Tage seit erstem Datenpunkt"


set key top left box

# FOR SOME STRANGE REASON THIS IS NOT WORKING, So fitting againt number column insteays since first datanot working: Singular matrix
# set timefmt '%d.%m.%Y %H:%M'
# set xdata time
# x0 = 1582884000 # unix time of 28.02.20 10:00
# f(x)=a * exp(b * (x-x0))
# fit f(x) data using 2:col via a, b


# doubling time
# 2 * a = a * exp (b * t) 
# ln 2  = b * t
# -> t = ln (2) / b

set fit quiet
a = 50.0
b = 0.2
f(x)=a * exp(b * x)


#set key off
# text will be inserted later on
set label 1 "" right front at graph 0.98, graph 0.22
# font ",20" 
print ("Doubling time")

short_name = 'BW' ; col = 4; long_name = "Baden-Württemberg"
load "plot-sub1.gp"

short_name = 'BY' ; col = 5; long_name = "Bayern"
load "plot-sub1.gp"

short_name = 'BE' ; col = 6; long_name = "Berlin"
load "plot-sub1.gp"

short_name = 'BB' ; col = 7; long_name = "Brandenburg"
load "plot-sub1.gp"

short_name = 'HB' ; col = 8; long_name = "Bremen"
load "plot-sub1.gp"

short_name = 'HH' ; col = 9; long_name = "Hamburg"
load "plot-sub1.gp"

short_name = 'HE' ; col = 10; long_name = "Hessen"
load "plot-sub1.gp"

short_name = 'MV' ; col = 11; long_name = "Mecklenburg-Vorpommern"
load "plot-sub1.gp"

short_name = 'NI' ; col = 12; long_name = "Niedersachsen"
load "plot-sub1.gp"

short_name = 'NW' ; col = 13; long_name = "Nordrhein-Westfalen"
load "plot-sub1.gp"

short_name = 'RP' ; col = 14; long_name = "Rheinland-Pfalz"
load "plot-sub1.gp"

short_name = 'SL' ; col = 15; long_name = "Saarland"
load "plot-sub1.gp"

short_name = 'SN' ; col = 16; long_name = "Sachsen"
load "plot-sub1.gp"

short_name = 'ST' ; col = 17; long_name = "Sachsen-Anhalt"
load "plot-sub1.gp"

short_name = 'SH' ; col = 18; long_name = "Schleswig-Holstein"
load "plot-sub1.gp"

short_name = 'TH' ; col = 19; long_name = "Thüringen"
load "plot-sub1.gp"

short_name = 'DE-total' ; col = 20; long_name = "Deutschland"
load "plot-sub1.gp"

unset label 1

# delete fit logfile
`rm fit.log`
unset xrange
unset xlabel



# now lets compare several stats
set timefmt '%d.%m.%Y %H:%M'
set format x '%d.%m'
set xdata time

# set key on
set title "Comparison"
set output '../plots-gnuplot/cases-de-comparison.png'
plot \
 data using 2:20 title "DE total" with linespoints \
,data using 2:4 title "BW" with linespoints \
,data using 2:5 title "BY" with linespoints \
,data using 2:12 title "NS" with linespoints \
,data using 2:13 title "NW" with linespoints \

unset output

set logscale y
# set format y "10^{%L}"
set title "Comparison log"
set output '../plots-gnuplot/cases-de-comparison-log.png'
replot
unset output
unset logscale y