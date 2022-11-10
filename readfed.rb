# Reading the Federalist Papers
#
# A Fed object contains one Federalist paper
# (Right now it has only the number)
#
require 'erb'
class Fed
    attr_accessor :fedno
		attr_accessor :author
		attr_accessor :title
		attr_accessor :pub

    # Constructor
    def initialize
      @fedno=0
      @author = "Jimmy"
      @title = "Title"
      @pub = "To the people"
    end

    # Method to print data on one Fed object
    def prt
       puts "Federalist #@fedno"
    end
end

#Global method to make HTML Contents File
def compileHTMLContents(feds)
    #Title and Header
    htmlFile = File.new("contents.html", "w+")
    htmlFile.puts "<html>"
    htmlFile.puts "<head><title>Federalist Index</title></head>"
    htmlFile.puts "<body>"
    htmlFile.puts "<h3>Federalist Index</h3>"
    htmlFile.puts "<table>"
		htmlFile.puts "<tr><th>No.</th><th>Author</th><th>Title</th><th>Pub</th></tr>"

    #Loop iterating through Embeded Ruby (ERB) code for each fed object
    feds.each do |f|
			#Initialize variables for ERB
      @number = f.fedno
      @author = f.author
      @title = f.title
      @pub = f.pub
			#Embed Ruby Template
			template = File.read('./template.html.erb')
			result = ERB.new(template).result(binding)
			htmlFile.write result
    end

		#End HTML File
    htmlFile.puts "</table>"
    htmlFile.puts "</body>"
    htmlFile.puts "</html> "
    htmlFile.close
end

#Returns the next non-empty line
def getNextTextLine(file)
		line = ""
		while (line.empty? && (line = file.gets))
				line.strip!            # Remove trailing white space
		end
		line
end

#Gets the header text as a text line array
def getTextLineArray(file)
		lines = []
		lines << getNextTextLine(file)
		while ((line = file.gets) && !line.strip.empty?)
				lines << line.strip!
		end
		lines
end

#Compiles multiple text lines into one body text
def compileTextLineArray(lines)
		final = lines.shift
		lines.each do |line|
				final += " " + line
		end
		final
end

#=========================
# Main program
#=========================

# Input will come from file fed.txt
file = File.new("fed.txt", "r")

# List of Fed objects
feds = []

#Read and process each line
while (line = getNextTextLine file)
    line.strip!            # Remove trailing white space
    words = line.split     # Split into array of words

    # "FEDERALIST No. number" starts a new Fed object
    if words[0]=="FEDERALIST" then
      curFed = Fed.new    # Construct new Fed object
      feds << curFed      # Add it to the array
			curFed.fedno = words[2]
			if (curFed.fedno.to_i  == 54)
					curFed.title = getNextTextLine file
					curFed.pub = getNextTextLine file
					curFed.author = getNextTextLine file
			else
					header = getTextLineArray file
					curFed.pub = header.pop #Removes last line from array (pub)
					curFed.title = compileTextLineArray header #Compiles rest of line array to the title
					curFed.author = getNextTextLine file #Next line with text should be the author's name
			end
    end
end # End of reading

file.close

# Apply the prt (print) method to each Fed object in the feds array
#feds.each{|f| f.prt}

#Make HTML File
compileHTMLContents feds
