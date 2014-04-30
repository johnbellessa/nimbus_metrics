	#name="`echo $filename`"
	#metric="`echo $metric`"
	infile = name.".csv"
	outfile = name.".ps"
		
	set size 1.0, 0.7
	set term postscript portrait enhanced color lw 3  "Helvetica" 14 
	set output outfile
        set xlabel "Time" 
        set ylabel metric 
	set key left top	
	set datafile separator ","
	
	#set key autotitle columnhead
	#set style line 1 linetype 2 linecolor rgb "#0000BB"
	#set style line 2 linetype 1 linecolor rgb "#FF8C00"
        #plot infile using 0:1 with lines ,\
	#     infile using 0:2 with lines

	plot for [i=2:columns+1] infile u 0:i with lp title columnheader(i)	
	set size 1,1
#set term x11
#replot

