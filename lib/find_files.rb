# frozen_string_literal: true

require "yaml"

# List files in a directory
module FindFiles
  def files(directory)
    if Dir.exist?(directory)
      Dir.entries(directory).sort[2..-1]
    else
      []
    end
  end

  def list_files(entries)
    puts "\n(#)  File name\n\n"
    entries.each_with_index do |file, index|
      puts "(#{index + 1})   #{file}\n\n"
    end
  end

  def load_yaml(filename)
    YAML.load(File.read(filename))
  end
end
