# frozen_string_literal: true

require "yaml"

# File operations for saving a game
class GameFile
  private

  attr_reader :yaml

  public

  attr_reader :filename

  def initialize(data)
    @yaml = _yaml(data)
    @filename = _filename
  end

  def write
    Dir.mkdir("saved_games") unless Dir.exist?("saved_games")
    File.open(filename, "w") do |file|
      file.puts yaml
    end
  end

  private

  def _filename
    color = %w[aqua black blue fuchsia gray green lime maroon navy olive purple
                red silver teal white and yellow]
    fruit = %w[apple apricot avocado banana blackberry blueberry cherry fig
                gooseberry grape plum lemon lime mango papaya peach pear pineapple
                raspberry strawberry]
    number = Time.now.to_i.to_s[-3..-1]
    @filename = "saved_games/#{color.sample}_#{fruit.sample}_#{number}.yaml"
  end

  def _yaml(data)
    @yaml = YAML.dump(data)
  end
end
