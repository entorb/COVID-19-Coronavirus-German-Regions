title = "Fitting Infektionen in ".long_name
set title title
# fitting

set xrange [x_min:x_max+1]

# fetch data from last row of data
y_last = ( system("tail -1 " . data . " | cut -f".col) + 0)


f(x)=a * exp(b * x)
a = y_last # initial value
b = 0.24
fit f(x) data using 1:col via a, b
# 17.03.2020: Comparing fits with 1 and 2 parameters
# fit f(x) data using 1:col via b
# b               = 0.240188         +/- 0.003794     (1.58%)
# Extrapolation 1 day: 7644 Cases
#
# fit f(x) data using 1:col via a, b
# a               = 6096.47          +/- 75.56        (1.239%)
# b               = 0.243477         +/- 0.004822     (1.98%)
# Extrapolation 1 day: 7669 Cases
#
# fit f(x) data using 1:col via b,a
# b               = 0.243477         +/- 0.004822     (1.98%)
# a               = 6096.47          +/- 75.56        (1.239%)
# Extrapolation 1 day: 7669 Cases


# stats data using 1:col nooutput
# x_max = STATS_max_x
t_doubling = log(2) / b

print sprintf (short_name."\t%.1f days", t_doubling)
# write fit results to file
set print fit_data_file append
print sprintf (  long_name."\t".short_name."\t%d\t%.2f\t%.2f\t%.2f\t%.2f\t%d\t%.2f\t%d", y_last, a, b, t_doubling, exp(b * 1), y_last * exp(b * 1), exp(b * 7), y_last * exp(b * 7)   )
unset print 

# plot 1: lin scale
set label 2 sprintf("Fit Ergebnisse\nVerdopplungszeit: %.1f Tage\nZunahme 1 Tag: %.0f%%\n  -> %d Fälle\nZunahme 7 Tage: %.0f%%\n  -> %d Fälle", t_doubling, (exp(b * 1)-1)*100, y_last * exp(b * 1), (exp(b * 7)-1)*100, y_last * exp(b * 7) )
set label 3 "" .y_last right at first x_max - 0.25, first y_last 
set output '../plots-gnuplot/cases-de-fit-'.short_name.'.png'
plot data using 1:col title "data" with points \
, f(x) title sprintf ("fit") with lines
unset output
# plot 2: log scale
set logscale y
set title title ." - Logarithmische Skalierung"
set output '../plots-gnuplot/cases-de-fit-'.short_name.'-log.png'
replot
unset output
unset logscale y
