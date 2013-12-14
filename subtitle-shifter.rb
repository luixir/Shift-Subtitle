require 'optparse'
require 'yaml'

# need to verify SRT file format first
# how many operation options needed? add, substract, ..
# print out number of lines once it has finished. "2129 lines changed"

options = {}

OptionParser.new do |opts|
	opts.banner = "Usage: subtitle-shifter --operation add --time 02,110 input_file.srt output_file.srt"
	opts.separator "" # Add a spacing line
	opts.separator "Specific options:"

	# Mandatory argument
	opts.on("-a", "--add",
		"Argument used to add the time") do |add|
		options[:add] = true
	end

	opts.on("-s", "--substract",
		"Argument used to substract the time") do |substract|
		options[:substract] = true
	end

	opts.on("-t", "--time 00,000",
		"Time to be calculated.
		\t\tFormat: 02,110. \"02\" is amount of seconds
		\t\tand \"110\" the amount of milliseconds") do |time|
		options[:time] = true
	end

	opts.on('-f FILE', '--file File', 'Pass-in .srt file name') do |value|
    	options[:file] = value
  	end

	# print out help options
	opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
    end

end.parse! # Parse()

#----------------------------------------------------------#
# Core code goes here									   #
#----------------------------------------------------------#

# If user pass two arguments, prints error and exit.
if options[:add] && options[:substract] == true
	puts "ERROR: Two operation arguments detected. Use only one."
	exit
end

# Opening file..
if options[:file]
	file = options[:file].to_s
	input = File.open(file)
	indata = input.read()
	puts "The input file is #{indata.length} bytes long"
	File.readlines(input).each do |line|
  		puts line
	end
	input.close
else
	puts "Check file name"
end

if options[:add]
	puts "Adding.."
end

if options[:substract]
	puts "Substracting.."
end


# Debugging tools
#puts Dir.pwd
p options
p ARGV