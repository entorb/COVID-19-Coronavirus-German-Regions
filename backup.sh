#!/bin/bash
# initialdir=$PWD
DATE=`date +"%Y-%m-%d_%H-%M"`

rm index.html
wget -q https://entorb.net/COVID-19-coronavirus/index.html
zip -9 backup/covid-$DATE.zip ./* scripts-gnuplot/* data/* 
