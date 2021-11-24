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
    error_message = "Input Error! That square does not have a piece you can move."

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
    error_message = "Input Error! That piece cannot move there."
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

end
