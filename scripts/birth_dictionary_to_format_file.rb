#!/usr/bin/env ruby

require 'csv'

row=0
csv=CSV.open("CHIRP Birth Extract Dictionary (v1.1) - Dictionary Extract.csv", 
	'r:bom|utf-8', headers: true)	#, return_headers: true )

puts "10.0"	#	SQL Server version-ish
puts csv.count		#	this is only a placeholder if there are gaps.
csv.rewind	#	csv.count reads to the end of the file. Undo so can read.

#EBRS Field Name,Variable Name,Field Structure,Code Description,Type,Start Position,End Position

#	End Position is really LENGTH

position=1
unknum=0
csv.each do |incsv|
	
	if position != incsv['Start Position'].to_i
		puts "#{row+=1} SQLCHAR 0 #{incsv['Start Position'].to_i - position} \"\" #{row} UNK#{unknum+=1} SQL_Latin1_General_Cp437_BIN"
		position=incsv['Start Position'].to_i
	end

	puts "#{row+=1} SQLCHAR 0 #{incsv['End Position']} \"\" #{row} #{incsv['EBRS Field Name']} SQL_Latin1_General_Cp437_BIN"
##1   SQLCHAR  0  10   ""       3  cert_num         SQL_Latin1_General_Cp437_BIN
#	puts incsv

	position+=incsv['End Position'].to_i
end
csv.close



#	May need to manually correct record count if there are gaps
#	WILL need to add \n as final separator.


