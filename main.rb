require 'csv'
require 'mharris_ext'

class String
  def to_base
    split("-").first.gsub(":command","")
  end
end

class Row
  include FromHash
  attr_accessor :from_stream, :to_stream, :from_type, :to_type, :global_position

  def from
    "#{from_stream.to_base}:#{from_type.to_base}"
  end

  def to
    "#{to_stream.to_base}:#{to_type.to_base}"
  end

  def line
    "\"#{from}\" --> \"#{to}\""
  end

  def short_line
    "#{from_type.to_base} --> #{to_type.to_base}"
  end

  def to_s
    "partition #{to_stream.to_base} {\n  #{short_line}\n}"
  end

  def use?
    [from_stream, to_stream].all?(&:present?)
  end
end

# Nodes with nothing pointing to them
def start_nodes(rows)
  rows.reject do |row|
    rows.any? do |other_row|
      other_row.to == row.from
    end
  end
end

# Rows pointed to by the already processed nodes
def next_rows(rows, done)
  res = rows.select do |row|
    done.map(&:to).include?(row.from)
  end
  if res.empty?
    str = [
      "no next",
      "Done: " + done.map(&:line).join("\n"),
      "Rows: " + rows.map(&:line).join("\n"),
    ].join("\n")
    raise str
  end
  res
end

# Rows sorted by order in the graph
def sorted_rows(rows, done = [])
  return done if rows.empty?

  if done.empty?
    done = start_nodes(rows)
    rows -= done
  end

  done += next_rows(rows, done)
  rows -= done

  sorted_rows(rows, done)
end

def graph_body
  rows = []
  CSV.foreach("input.csv", headers: true) do |csv|
    rows << Row.new(csv)
  end

  rows = rows.select(&:use?)
  rows = sorted_rows(rows)
  strs = rows.map(&:to_s).uniq
  strs.join("\n")
end

if !FileTest.exist?("input.csv")
  raise "\n\nGenerate a CSV file from your Eventide DB using query.sql. Put this file at input.csv, then try again\n\n"
end

full = <<EOF
@startuml
#{graph_body}
@enduml
EOF

File.create "diagram.puml", full
