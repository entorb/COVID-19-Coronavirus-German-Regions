title = "Fitting Fälle in ".long_name
set title title
# fitting
fit f(x) data using 1:col via a, b
# stats data using 1:col nooutput
# x_max = STATS_max_x
t_doubling = log(2) / b

# fetch data from last row of data
y_last = ( system("tail -1 " . data . " | cut -f".col) + 0)

print sprintf (short_name."\t%.1f days", t_doubling)
# write fit results to file
set print fit_data_file append
print sprintf (  long_name."\t".short_name."\t%d\t%.2f\t%.2f\t%.2f\t%.2f\t%d\t%.2f\t%d", y_last, a, b, t_doubling, exp(b * 1), y_last * exp(b * 1), exp(b * 7), y_last * exp(b * 7)   )
unset print 

# plot 1: lin scale
set label 2 sprintf("Fit Ergebnisse\nVerdopplungszeit: %.1f Tage\nZunahme 1 Tag: %.0f%%\n  -> %d Fälle\nZunahme 7 Tage: %.0f%%\n  -> %d Fälle", t_doubling, (exp(b * 1)-1)*100, y_last * exp(b * 1), (exp(b * 7)-1)*100, y_last * exp(b * 7) )
set label 3 "" .y_last right at first x_max - 0.25, first y_last 
set output '../plots-gnuplot/cases-de-fit-'.short_name.'.png'
set xrange [0:x_max+1]
plot data using 1:col title "data" with linespoints \
, f(x) title sprintf ("fit") with lines
unset output
# plot 2: log scale
set logscale y
set title title ." - Logarithmische Skalierung"
set output '../plots-gnuplot/cases-de-fit-'.short_name.'-log.png'
replot
unset output
unset logscale y
