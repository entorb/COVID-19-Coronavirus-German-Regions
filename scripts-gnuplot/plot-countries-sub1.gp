data = "../data/countries-timeseries-".country_code.".csv"

# fetch data from last row of data
x_min = ( system("head -n 2 " . data . " | tail -1 | cut -f1") + 0 )
x_max = ( system("tail -1 " . data . " | cut -f1") + 0 )
# fetch data from last row of data
y_last = ( system("tail -1 " . data . " | cut -f".col) + 0)
date_last = system("tail -1 " . data . " | cut -f2")

title = "Fitting Deaths in ".country_name
set title title
set label 1 label1_text_right." based on JHU data of ".date_last

set xrange [x_min:x_max+1]

# Important: remove 0 values from fit
set yrange [1:] 

# fitting
f(x)=a * exp(b * x)
a = y_last # initial value
b = 0.24
fit f(x) data using 1:col via a, b
t_doubling = log(2) / b
print sprintf (country_name."\t%.1f days", t_doubling)

# guide lines
f2(x)=a2 * exp(log(2)/2 * x)
f3(x)=a3 * exp(log(2)/3 * x)
fit f2(x) data using 1:col via a2
fit f3(x) data using 1:col via a3



set key top left box
# plot 1: lin scale
set label 2 sprintf("Fit Results\nDoubling Time: %.1f Days\nIncrease 1 Day: %.0f%%\n  -> %d Deaths\nIncrease 7 Days: %.0f%%\n  -> %d Deaths", t_doubling, (exp(b * 1)-1)*100, y_last * exp(b * 1), (exp(b * 7)-1)*100, y_last * exp(b * 7) )
set label 3 "" .y_last right at first x_max - 2, first y_last 
set output '../plots-gnuplot/deaths-'.country_code.'-fit.png'
plot data using 1:col title "data" with points \
, f(x) title sprintf ("fit") with lines \
, f2(x) title sprintf ("model 2 days doubling") with lines \
, f3(x) title sprintf ("model 3 days doubling") with lines 
unset output
# plot 2: log scale
set logscale y
set title title ." - Log Scale"
set output '../plots-gnuplot/deaths-'.country_code.'-fit-log.png'
replot
unset output
unset logscale y