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

  def menu_input(phrase, options)
    puts phrase
    options.each.with_index(1) do |choice, index|
      puts "[#{index}] - #{choice}"
    end
    gets.chomp
  end

  def receive_menu_input(available_choices, prompt_message)
    loop do
      input = menu_input(prompt_message, available_choices)
      input = verify_input(input, (1..available_choices.length).to_a.map(&:to_s))
      return input if input

      puts "That was not one of the available choices. Please try again."
    end
  end
end
