#!/usr/bin/env ruby
require 'csv'
ARGV.each do |infilename|
	puts infilename
#	:bom|utf-8 NEEDED for screening data, but don't cause issues in others, so keep it.
#	This also removes double quotes from fields unless needed
	CSV.open( infilename, 'r:bom|utf-8', headers: true, return_headers: true ).each do |incsv|
		CSV.open( "#{infilename}.psv", 'a', col_sep: '|') do |csv|
			csv << incsv
		end
	end
end
