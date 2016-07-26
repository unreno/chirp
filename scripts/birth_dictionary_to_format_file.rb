#!/usr/bin/env ruby

require 'csv'

row=0
csv=CSV.open("CHIRP Birth Extract Dictionary (v1.2) - Dictionary Extract.csv", 
	'r:bom|utf-8', headers: true)	#, return_headers: true )

puts "10.0"	#	SQL Server version-ish
puts csv.count		#	this is only a placeholder if there are gaps.
csv.rewind	#	csv.count reads to the end of the file. Undo so can read.

#	v 1.1
#EBRS Field Name,Variable Name,Field Structure,Code Description,Type,Start Position,End Position
#	v 1.2
#EBRS Field Name,Variable Name,Field Structure,Code Description,Type,Start Position,Length

#	End Position is really LENGTH

def print_line(num,len,sep,order,name)
	puts "#{num.to_s.ljust(4)} SQLCHAR 0 #{len.to_s.rjust(5)} #{sep.ljust(4)} #{order.to_s.rjust(3)} #{name.ljust(30)} SQL_Latin1_General_CP1_CI_AS"
end

position=1
unknum=0
csv.each do |incsv|
	
	if position != incsv['Start Position'].to_i
		print_line row+=1, incsv['Start Position'].to_i - position, "\"\"",
			row, "UNK"+(unknum+=1).to_s
		position=incsv['Start Position'].to_i
	end

	print_line row+=1, incsv['Length'], "\"\"", row, incsv['EBRS Field Name']

#	position+=incsv['End Position'].to_i
	position+=incsv['Length'].to_i
end
csv.close

print_line row+=1, 1000, "\"\\n\"", row, "UNK"+(unknum+=1).to_s




#	May need to manually correct record count if there are gaps



#	SELECT a.* 
#	FROM OPENROWSET( 
#		BULK 'C:\Users\gwendt\Desktop\CHIRP Birth Extract 20160701.txt',
#		FORMATFILE = 'Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\development\births_dev.fmt'
#	) AS a;

