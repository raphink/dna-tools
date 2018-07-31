#!/usr/bin/env ruby
#
# Generates a phased kit from two kits
#
# Takes 3 parameters
#   - base kit
#   - parent kit
#   - phased kit to generate

require 'csv'

FILE1, FILE2, FILE3 = ARGV

HEADER = [ 'RSID', 'CHROMOSOME' , 'POSITION' , 'RESULT' ]

def phase(file1, file2)
    csv1 = CSV.read(file1)[1..-1]
    csv2 = CSV.read(file2)[1..-1]

    csv1.each_with_index.map do |l, i|
        bases1 = l[3].split('')
        bases2 = csv2[i][3].split('')
        inter = bases1 & bases2
        l[3] = inter.join.ljust(2, '-')
        l
    end
end


CSV.open(FILE3, 'w') do |csv|
    csv << HEADER
    phase(FILE1, FILE2).each do |l|
        csv << l
    end
end
