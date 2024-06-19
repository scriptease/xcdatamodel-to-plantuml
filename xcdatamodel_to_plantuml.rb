#!/usr/bin/env ruby

require 'nokogiri'
require 'optparse'
require 'pathname'

# Function to parse the .xcdatamodel file and generate PlantUML
def xcdatamodel_to_plantuml(xcdatamodel_path)
  # Load and parse the xcdatamodel file
  xml_doc = Nokogiri::XML(File.read(xcdatamodel_path))
  
  # Initialize PlantUML content
  plantuml_content = "@startuml\n"
  
  # Parse entities
  entities = xml_doc.xpath("//entity")
  entities.each do |entity|
    entity_name = entity.attr('name')
    plantuml_content += "class #{entity_name} {\n"
    
    # Parse attributes
    attributes = entity.xpath("attribute")
    attributes.each do |attribute|
      attribute_name = attribute.attr('name')
      attribute_type = attribute.attr('attributeType') || "String"
      plantuml_content += "  #{attribute_name}: #{attribute_type}\n"
    end
    
    plantuml_content += "}\n"
  end
  
  # Parse relationships
  entities.each do |entity|
    entity_name = entity.attr('name')
    
    relationships = entity.xpath("relationship")
    relationships.each do |relationship|
      destination = relationship.attr('destinationEntity')
      min_count = relationship.attr('minCount') || "0"
      max_count = relationship.attr('maxCount') || "*"
      plantuml_content += "#{entity_name} \"#{min_count}\" -- \"#{max_count}\" #{destination}\n" unless destination.nil?
    end
  end
  
  plantuml_content += "@enduml\n"
  
  # Output the PlantUML content
  puts plantuml_content
end

# Function to determine the path to the .xcdatamodel file inside .xcdatamodeld directory
def find_xcdatamodel_in_package(package_path)
  package_name = File.basename(package_path, ".xcdatamodeld")
  model_path = File.join(package_path, "#{package_name}.xcdatamodel", "contents")
  
  unless File.exist?(model_path)
    puts "Error: Could not find .xcdatamodel file inside the specified .xcdatamodeld package."
    exit 1
  end
  
  model_path
end

# Option parsing
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: xcdatamodel_to_plantuml.rb [options]"

  opts.on("-f", "--file FILE", "Path to the .xcdatamodel or .xcdatamodeld file") do |file|
    options[:file] = file
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

# Check if the file option is provided
if options[:file].nil?
  puts "Error: You must specify the path to the .xcdatamodel or .xcdatamodeld file using the -f option."
  exit 1
end

# Determine the type of the specified file and get the path to the .xcdatamodel file
file_path = options[:file]
if File.directory?(file_path) && file_path.end_with?(".xcdatamodeld")
  xcdatamodel_path = find_xcdatamodel_in_package(file_path)
elsif File.directory?(file_path) && file_path.end_with?(".xcdatamodel")
  xcdatamodel_path = File.join(file_path,'contents')
elsif File.file?(file_path) && file_path.end_with?(".xcdatamodel")
  xcdatamodel_path = file_path
else
  puts "Error: The specified path is not a valid .xcdatamodel or .xcdatamodeld file."
  exit 1
end

# Convert xcdatamodel to PlantUML
xcdatamodel_to_plantuml(xcdatamodel_path)