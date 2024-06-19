# xcdatamodel-to-plantuml
Generate PlantUml from CoreData

## Motive
Apple got rid of the Core Data Model Editor Style in Xcode 14
https://developer.apple.com/forums/thread/710008

## Requirements

- Ruby (version 2.0 or later)
- Nokogiri gem for XML parsing

### Installing Nokogiri

You can install the Nokogiri gem using:

    gem install nokogiri
    

## Usage

Save the script to a file, for example, xcdatamodel_to_plantuml.rb.

### Command Line Options

    -f, --file FILE - Path to the .xcdatamodel or .xcdatamodeld file.
    -h, --help - Prints help message.

### Running the Script

To run the script, use the following command:

    ruby xcdatamodel_to_plantuml.rb -f path/to/your/model.xcdatamodel

Or for a .xcdatamodeld package:

    ruby xcdatamodel_to_plantuml.rb -f path/to/your/model.xcdatamodeld

This will output the PlantUML representation of your Core Data model to the console. You can redirect the output to a file if needed:

    ruby xcdatamodel_to_plantuml.rb -f path/to/your/model.xcdatamodel > model.puml

Or for a package:

    ruby xcdatamodel_to_plantuml.rb -f path/to/your/model.xcdatamodeld > model.puml
