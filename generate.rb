#!/usr/bin/env ruby
#
# Generates an ancestor kit from a YAML profile and a base kit
#

require 'yaml'
require 'csv'

PROFILE = ARGV[0]

HEADER = [ 'RSID', 'CHROMOSOME' , 'POSITION' , 'RESULT' ]

puts "[#{PROFILE}] Parsing profile"
prof = YAML.load_file("profiles/#{PROFILE}.yaml")

puts "[#{PROFILE}] Reading source kit"
source = CSV.read("phased/36_#{prof['source']}.csv")[1..-1]

# Create a copy with blanks
puts "[#{PROFILE}] Creating blanked copy"
target = source.map { |l| [ l[0], l[1], l[2], '--' ] }


puts "[#{PROFILE}] Overriding with segments"
prof['segments'].each do |s|
    puts "Looking for #{s}"
    source.each do |l|
        chr = l[1].to_i
        pos = l[2].to_i
        if chr == s['chromosome'] && pos >= s['start'] && pos <= s['end']
            puts "Adding SNP on chromosome #{chr} at #{pos}"
            target.each do |ll|
                if ll[1] == chr && ll[2] == pos
                    ll[3] = l[3]
                end
            end
        end
    end
end

puts "[#{PROFILE}] Generating output kit generated/#{PROFILE}.csv"
CSV.open("generated/36_#{PROFILE}.csv", 'w') do |csv|
    csv << HEADER
    target.each { |l| csv << l }
end
