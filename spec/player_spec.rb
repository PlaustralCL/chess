# frozen_string_literal: true

require_relative "../lib/player"

describe Player do
  subject(:new_player) { described_class.new }
  let(:available_choices) { %w[f1 g1 f2 g3] }
  let(:finish_choices) { %w[a1 b1 c1 d1 e1] }

  describe "#verify_input" do
    context "when a valid choice is entered" do
      it "returns the choice" do
        player_input = "g1"
        expect(new_player.verify_input(player_input, available_choices)).to eq("g1")
      end
    end

    context "when an invalid choice is entered" do
      it "returns nil" do
        player_input = "a1"
        expect(new_player.verify_input(player_input, available_choices)).to eq(nil)
      end
    end
  end

  describe "#input_start_square" do
    error_message = "That square does not have a piece you can move. Please try again."

    context "when input is valid" do
      it "stops the loop and does not receive the error message" do
        valid_input = "g3"
        allow(new_player).to receive(:request_input).and_return(valid_input)
        expect(new_player).not_to receive(:puts).with(error_message)
        new_player.input_start_square(available_choices)
      end
    end

    context "when player enters incorrect choice followed by valid choice" do
      it "completes the loop and displays error message once" do
        valid_input = "g3"
        allow(new_player).to receive(:request_input).and_return(nil, valid_input)
        expect(new_player).to receive(:puts).with(error_message).once
        new_player.input_start_square(available_choices)
      end
    end

    context "when player enters incorrect choice and then quits" do
      it "completes the loop and displays error message once" do
        valid_input = "q"
        allow(new_player).to receive(:request_input).and_return(nil, valid_input)
        expect(new_player).to receive(:puts).with(error_message).once
        new_player.input_start_square(available_choices)
      end
    end

    context "when player enters 2 incorrect choice followed by a valid choice" do
      it "completes the loop and displays error message once" do
        valid_input = "g3"
        allow(new_player).to receive(:request_input).and_return(nil, nil, valid_input)
        expect(new_player).to receive(:puts).with(error_message).twice
        new_player.input_start_square(available_choices)
      end
    end
  end

  describe "#input_finish_square" do
    error_message = "That piece cannot move there. Please try again."

    context "when input is valid" do
      it "stops the loop and does not receive the error message" do
        valid_input = "e1"
        allow(new_player).to receive(:request_input).and_return(valid_input)
        expect(new_player).not_to receive(:puts).with(error_message)
        new_player.input_finish_square(finish_choices)
      end
    end

    context "when player enters incorrect choice followed by valid choice" do
      it "completes the loop and displays error message once" do
        valid_input = "e1"
        allow(new_player).to receive(:request_input).and_return(nil, valid_input)
        expect(new_player).to receive(:puts).with(error_message).once
        new_player.input_finish_square(finish_choices)
      end
    end

    context "when player enters 2 incorrect choice followed by a valid choice" do
      it "completes the loop and displays error message once" do
        valid_input = "e1"
        allow(new_player).to receive(:request_input).and_return(nil, nil, valid_input)
        expect(new_player).to receive(:puts).with(error_message).twice
        new_player.input_finish_square(finish_choices)
      end
    end
  end

  describe "#input_promotion_piece" do
    error_message = "That was not one of the allowed choices. Please try again."

    context "when input is valid" do
      it "stops the loop and does not receive the error message" do
        valid_input = "1"
        allow(new_player).to receive(:menu_input).and_return(valid_input)
        expect(new_player).not_to receive(:puts).with(error_message)
        new_player.input_promotion_piece
      end
    end

    context "when player enters incorrect choice followed by valid choice" do
      it "completes the loop and displays error message once" do
        valid_input = "2"
        allow(new_player).to receive(:menu_input).and_return(nil, valid_input)
        expect(new_player).to receive(:puts).with(error_message).once
        new_player.input_promotion_piece
      end
    end

    context "when player enters 2 incorrect choice followed by a valid choice" do
      it "completes the loop and displays error message once" do
        valid_input = "3"
        allow(new_player).to receive(:menu_input).and_return(nil, nil, valid_input)
        expect(new_player).to receive(:puts).with(error_message).twice
        new_player.input_promotion_piece
      end
    end
  end

  describe "#menu_input" do
    before do
      $stdin = StringIO.new("3")
    end

    after do
      $stdin = STDIN
    end

    it "outputs a menu" do
    phrase = "Pawn Promotion - Please choose the number corresponeding to your new piece:"
    options = %w[Queen Knight Rook Bishop]
    display = "Pawn Promotion - Please choose the number corresponeding to your new piece:\n[1] - Queen\n[2] - Knight\n[3] - Rook\n[4] - Bishop\n"
    expect { new_player.menu_input(phrase, options) }.to output(display).to_stdout
    end
  end

end
