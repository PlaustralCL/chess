# frozen_string_literal: true

require_relative "../lib/game"

describe Game do
  let(:board) { instance_double("board") }
  subject(:new_game) { described_class.new(board) }
  describe "#final_message" do
    context "when white wins" do
      it "states white won by checkmate" do
        winning_phrase = "Checkmate! White won.\n"
        allow(board).to receive(:winner).and_return("white")
        expect { new_game.final_message }.to output(winning_phrase).to_stdout
      end
    end

    context "when black wins" do
      it "states black won by checkmate" do
        winning_phrase = "Checkmate! Black won.\n"
        allow(board).to receive(:winner).and_return("black")
        expect { new_game.final_message }.to output(winning_phrase).to_stdout
      end
    end

    context "when the game ends in stalemate" do
      it "states draw by stalemate" do
        stalemate_phrase = "Stalemate! The game is a draw.\n"
        allow(board).to receive(:winner).and_return("stalemate")
        expect { new_game.final_message }.to output(stalemate_phrase).to_stdout
      end
    end

    context "when the game ends by insufficient material" do
      it "states draw by insufficient material" do
        stalemate_phrase = "Insufficient material. The game is a draw.\n"
        allow(board).to receive(:winner).and_return("insufficient")
        expect { new_game.final_message }.to output(stalemate_phrase).to_stdout
      end
    end
  end
end
