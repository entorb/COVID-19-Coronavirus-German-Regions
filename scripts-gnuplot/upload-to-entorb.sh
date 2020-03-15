# TODO: replace by rsync

# scp ../plots-gnuplot/*.png entorb@entorb.net:html/COVID-19-coronavirus/plots-gnuplot/
# scp ../plots-excel/*.png entorb@entorb.net:html/COVID-19-coronavirus/plots-excel/

rsync -rvhu --delete --delete-excluded ../plots-gnuplot/*.png entorb@entorb.net:html/COVID-19-coronavirus/plots-gnuplot/
rsync -rvhu --delete --delete-excluded ../plots-excel/*.png entorb@entorb.net:html/COVID-19-coronavirus/plots-excel/