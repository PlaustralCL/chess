# frozen_string_literal: true

# Accept and validate input from the user. These methods are tested with the
# Player class.
module UserInput
  def verify_input(input, choices = nil)
    return input if choices.include?(input)
  end

  def request_input(phrase)
    puts phrase
    # $stdin is necessary here if ARGV is used in main.rb to
    # initiate the whole program. The gets command looks first to ARGV to
    # receive input so you have to direct it to look at STDIN instead.
    $stdin.gets.chomp.downcase
  end
end
