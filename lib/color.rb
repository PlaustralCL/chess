# frozen_string_literal: true

# Adds color to strings printed to the terminal by extending the
# functionality of the built in String class.
# This is based almost entirely on this stackoverflow answer:
# https://stackoverflow.com/a/11482430
class String
  def colorize(color_code, special = 0)
    "\e[#{special};#{color_code}m#{self}\e[0m"
  end

  def full_color(foreground, background)
    "\e[1;38;5;#{foreground};48;5;#{background}m#{self}\e[0m"
  end

  def pink_teal
    full_color(199, 6)
  end

  def pink_brown
    full_color(199, 178)
  end

  def white_pink
    full_color(15, 199)
  end

  def black_pink
    full_color(232, 199)
  end

  def white_teal
    full_color(15, 6)
  end

  def black_teal
    full_color(232, 6)
  end

  def white_brown
    full_color(15, 178)
  end

  def black_brown
    full_color(232, 178)
  end

  def white_green
    full_color(15, 46)
  end

  def black_green
    full_color(232, 46)
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end

  def bold_red
    colorize(31, 1)
  end

  def bold_green
    colorize(32, 1)
  end

  def bold_yellow
    colorize(33, 1)
  end

  def bold_blue
    colorize(34, 1)
  end

  def bold_pink
    colorize(35, 1)
  end

  def bold_light_blue
    colorize(36, 1)
  end

  def bold
    colorize(37, 1)
  end

  def bold_cyan_backgrouond
    colorize(46, 1)
  end
end

if $PROGRAM_NAME == __FILE__
  puts "Testing red".red
  puts "Testing bold red".bold_red
  puts "testing green".green
  puts "testing bold green".bold_green
  puts "testing blue".blue
  puts "testing bold blue".bold_blue
  puts "testing bold".bold
end
