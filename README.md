# eventide-graph

This generates a graph of your events from the data in your Eventide DB.

### What you need: 

* Generate a CSV file from your DB using query.sql. Put the file at `input.csv`. 
* Install PlantUML. On OSX this is `brew install plantuml`. 

### Running

Run `bundle install` (duh). 

Rake Tasks:
* `make` - Generates the PlantUML diagram file at `diagram.puml`
* `image` - Generates the image from the diagram file at `diagram.png`
* `all` - Generate the diagram/image and open it

`bundle exec rake all` to do everything.

### Notes

Your graph will come out best if you only have one type of starting event (i.e. your graph has one start node with no inbound edges).

This is all super rough. Figured I'd put it up in case others found it useful. 
