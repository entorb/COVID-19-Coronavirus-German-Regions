set title "Fitting ".colName
fit f(x) data using 1:col via a, b
t_doubling = log(2) / b
print sprintf ("%.1f days", t_doubling) . "\t " . colName
set label 1 sprintf("Fit Ergebnisse\nVerdopplungszeit: %.1f Tage\nAnstiegsfaktor 1 Tag: %.0f%%\nAnstiegsfaktor 7 Tage: %.0f%%", t_doubling, (exp(b * 1)-1)*100, (exp(b * 7)-1)*100)
set output '../plots-gnuplot/cases-de-fit-'.colName.'.png'
plot data using 1:col title "data" with linespoints \
, f(x) title sprintf ("fit") with lines
unset output
set logscale y
set title "Fit ".colName. " log"
set output '../plots-gnuplot/cases-de-fit-'.colName.'-log.png'
replot
unset output
unset logscale y
