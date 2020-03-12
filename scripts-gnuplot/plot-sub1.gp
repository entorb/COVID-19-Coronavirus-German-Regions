set title "Fit ".colName
fit f(x) data using 1:col via a, b
t_doubling = log(2) / b
print sprintf ("%.1f days", t_doubling) . "\t " . colName
set output '../plots-gnuplot/cases-de-fit-'.colName.'.png'
plot data using 1:col title "data ".colName with linespoints \
, f(x) title sprintf ("fitted doubling: %.1f days", t_doubling) with lines
unset output
set logscale y
set output '../plots-gnuplot/cases-de-fit-'.colName.'-log.png'
replot
unset output
unset logscale y
