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


set title "Plot Title"
set ylabel "Cases"
set xlabel "Days since first data"

set key bottom right box

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

# delete fit logfile
set fit quiet
a = 50.0
b = 0.2
f(x)=a * exp(b * x)


#set key off
# text will be inserted later on
# set label 1 "" left front at graph 0.5, graph 0.5
# font ",20" 
print ("Doubling time")

colName = 'BW' ; col = 4
load "plot-sub1.gp"

colName = 'BY' ; col = 5
load "plot-sub1.gp"

colName = 'NDS' ; col = 12
load "plot-sub1.gp"

colName = 'NRW' ; col = 13
load "plot-sub1.gp"

colName = 'DE-total' ; col = 20
load "plot-sub1.gp"

`rm fit.log`
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
,data using 2:12 title "NDS" with linespoints \
,data using 2:13 title "NRW" with linespoints \

unset output

set logscale y
# set format y "10^{%L}"
set title "Comparison log"
set output '../plots-gnuplot/cases-de-comparison-log.png'
replot
unset output
unset logscale y