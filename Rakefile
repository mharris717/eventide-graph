require 'mharris_ext'

task default: :make

def plantuml_exists?
  `which plantuml`.present?
end

task :make do
  ec "ruby main.rb"
end
task image: :make do
  raise "\n\nPlantUML is not installed. You can install with brew install plantuml\n\n" unless plantuml_exists?
  ec "plantuml diagram.puml"
  puts "The image for your diagram has been generated at diagram.png"
end
task :open do
  ec "open diagram.png"
end
task all: %w(make image open)
