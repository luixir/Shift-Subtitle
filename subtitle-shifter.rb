require 'optparse'

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
SECOND_MS = 1000
MINUTE_MS = 60000
HOUR_MS = 3600000

# convert time to ms
def to_ms(h, m, s, ms)
	ms + (s * 1000) + (m * 60000) + (h * 3600000)
end

# Convert the number back to the format
def format_result(ms)
	h = ms / HOUR_MS
	ms -= h * HOUR_MS
  	h = h.to_s
  
	m = ms / MINUTE_MS
	ms -= m * MINUTE_MS
	m = m.to_s
	  
	s = ms / SECOND_MS
	ms -= s * SECOND_MS
	s = s.to_s
	  
	ms = ms.to_s
	  
	h = "0#{h}" if h.length == 1
	m = "0#{m}" if m.length == 1
	s = "0#{s}" if s.length == 1
	if ms.length == 1
	  ms = "00#{ms}"
	elsif ms.length == 2
	  ms = "0#{ms}"
	end

	"#{h}:#{m}:#{s},#{ms}"
end

def change_time(time, h, m, s, ms)
	time =~ /(\d{2}):(\d{2}):(\d{2}),(\d+)/
	ms_time = to_ms($1.to_i, $2.to_i, $3.to_i, $4.to_i) + to_ms(h, m, s, ms)
	# Will return changed time
	format_result(ms_time)
end

# If user pass two arguments, prints error and exit.
if options[:add] && options[:substract] == true
	puts "ERROR: Two operation arguments detected. Use only one."
	exit
end

# Opening and writing file..
inputfile = options[:file].to_s
def write_file(input, output, h, m, s, ms)
	File.open(input) do |file|
		# Get line with specific expression
		@line2 = file.readlines.join
		@line2.gsub!(/\d{2}:\d{2}:\d{2},\d+/) {|time| change_time(time, h, m, s, ms)}
	end
	File.open(output, "w") do |file|
    	file.write(@line2)
  	end
end

# \d is for digits
options[:time] =~ /(\d+),(\d+)/
s = $1.to_i
ms = $2.to_i

if options[:substract]
	s *= -1
	ms *= -1
end

if options[:add]
	inputtime = options[:time].to_s
	puts "Shifting #{inputtime} seconds"
end

outputfile = ARGV[0]

write_file(inputfile, outputfile, 0, 0, s, ms)

puts "Output file: #{outputfile}"

# Debugging tools
#puts Dir.pwd
p options
p ARGV