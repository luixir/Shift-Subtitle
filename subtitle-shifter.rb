require 'optparse'
require 'yaml'

# need to verify SRT file format first
# how many operation options needed? add, substract, ..
# print out number of lines once it has finished. "2129 lines changed"

# Create hash
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
		options[:time] = time
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

def change_time(time)
	
	# Will return changed time
	"abc"
end

def calculate_time(s, ms)
	# do the time calculation
	
end

# If user pass two arguments, prints error and exit.
if options[:add] && options[:substract] == true
	puts "ERROR: Two operation arguments detected. Use only one."
	exit
end

# Opening file..
if options[:file]
	file = options[:file].to_s
	# file2 = Array.new
	# File.readlines(input).each do |line|
	File.open(file) do |file|
		# Get line with specific expression
		# line2 =  line if (line[/\d{2}:\d{2}:\d{2}/])
		@line2 = file.readlines.join
		@line2.gsub!(/\d{2}:\d{2}:\d{2},\d+/) {|time| change_time(time)}
		# puts @line2
  		#puts line.gsub(/-->/, "CHANGED")
	end
	File.open("out.txt", "w") do |file|
    	file.write(@line2)
  	end
end


if options[:add]
	puts "Adding.."
end

# \d is for digits
options[:time] =~ /(\d+),(\d+)/
s = $1.to_i
ms = $2.to_i

if options[:substract]
	s *= -1
	ms *= -1
end

calculate_time(s, ms)

# Debugging tools
#puts Dir.pwd
p options
p ARGV