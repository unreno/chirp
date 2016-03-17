#!/usr/bin/env ruby

require 'nokogiri'
require 'csv'

doc = File.open("2016-PCS-Code-Tables/icd10pcs_tables_2016.xml") { |f| Nokogiri::XML(f) }



#irb(main):060:0> doc.xpath('//pcsTable').first.xpath('axis').first.xpath('title').text
#=> "Section"
#irb(main):061:0> doc.xpath('//pcsTable').first.xpath('axis').first.xpath('label').text
#=> "Medical and Surgical"
#irb(main):062:0> doc.xpath('//pcsTable').first.xpath('axis').first.xpath('label').attribute('code')
#=> #<Nokogiri::XML::Attr:0x3fc639811340 name="code" value="0">
#irb(main):063:0> doc.xpath('//pcsTable').first.xpath('axis').first.xpath('label').attribute('code').value
#=> "0"


doc.xpath('//pcsTable').each do |pcstable|
	p1 = pcstable.xpath('axis[@pos=1]/label')
	p3code  = p1.attribute('code').value
	p3path  = "/#{p1.text}"
	p2 = pcstable.xpath('axis[@pos=2]/label')
	p3code += p2.attribute('code').value
	p3path += "/#{p2.text}"
	p3 = pcstable.xpath('axis[@pos=3]/label')
	p3code += p3.attribute('code').value
	p3path += "/#{p3.text}"

	#	puts code
	#	puts path

#	      <label code="0">Medical and Surgical</label>
	pcstable.xpath('pcsRow').each do |pcsrow|
		pcsrow.xpath('axis[@pos=4]').each do |axis4|
			l=axis4.xpath('label')
			p4code = p3code + l.attribute('code').value
			p4path = p3path + "/#{l.text}"
			#puts p4code
			#puts p4path
			pcsrow.xpath('axis[@pos=5]').each do |axis5|
				l=axis5.xpath('label')
				p5code = p4code + l.attribute('code').value
				p5path = p4path + "/#{l.text}"
				#puts p5code
				#puts p5path
				pcsrow.xpath('axis[@pos=6]').each do |axis6|
					l=axis6.xpath('label')
					p6code = p5code + l.attribute('code').value
					p6path = p5path + "/#{l.text}"
					#puts p6code
					#puts p6path
					pcsrow.xpath('axis[@pos=7]').each do |axis7|
						l=axis7.xpath('label')
						p7code = p6code + l.attribute('code').value
						p7path = p6path + "/#{l.text}"
						#puts p7code
						#puts p7path
						#puts p7path.slice(0..255)
						#	path is VARCHAR(255). Need to trim and don't forget the /ICD10PCS prefix!
						puts ["ICD10PCS:#{p7code}",
							"/ICD10PCS#{p7path.slice(0..245)}",
							"#{p7path}"].to_csv
					end
				end
			end
		end
	end	#	pcstable.xpath('pcsRow').each |pcsrow|

end	#	doc.xpath('//pcsTable').each |pcsnode|


#puts doc.inspect
