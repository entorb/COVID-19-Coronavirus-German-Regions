# by Torben Menke
# https://entorb.net
# date 2020-03-12

# set terminal png noenhanced large size 640,480
set terminal pngcairo size 640,480 font 'Verdana,9'
# set terminal svg size 640,480 fname 'Verdana, Helvetica, Arial, sans-serif' rounded dashed

set datafile commentschars '#'
# set datafile missing '#'
set datafile separator "\t"

set encoding utf8

label1_text_right = "by Torben https://entorb.net"
set label 1 label1_text_right rotate by 90 center at screen 0.985, screen 0.5

set style increment user 
set style line 1 linetype 7 dt 3 lw 2 linecolor rgb 'black' 
set style line 2 linetype 7 dt 1 lw 2 linecolor rgb 'grey' 
set style line 3 linetype 7 dt 4 lw 2 linecolor rgb 'red' 
set style line 4 linetype 7 dt 5 lw 2 linecolor rgb 'blue' 
# boxplot
set style line 11 dt 1 lw 1 linecolor rgb "red"

set grid xtics ytics
set xtics mirror
set ytics mirror 

    