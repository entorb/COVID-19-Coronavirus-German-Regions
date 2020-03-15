set title "Fitting ".long_name
fit f(x) data using 1:col via a, b
stats data using 1:col
x_max = STATS_max_x
t_doubling = log(2) / b
print sprintf ("%.1f days", t_doubling) . "\t " . short_name
set label 1 sprintf("Fit Ergebnisse\nVerdopplungszeit: %.1f Tage\nAnstiegsfaktor 1 Tag: %.0f%%\n  -> %d Fälle\nAnstiegsfaktor 7 Tage: %.0f%%\n  -> %d Fälle", t_doubling, (exp(b * 1)-1)*100, f(x_max+1), (exp(b * 7)-1)*100, f(x_max+7) )
set output '../plots-gnuplot/cases-de-fit-'.short_name.'.png'
set xrange [0:x_max+1]
plot data using 1:col title "data" with linespoints \
, f(x) title sprintf ("fit") with lines
unset output
set logscale y
set title "Fitting ".long_name. " - Logarithmische Skalierung"
set output '../plots-gnuplot/cases-de-fit-'.short_name.'-log.png'
replot
unset output
unset logscale y
