# frozen_string_literal: true

require_relative "../../lib/moves/king_move"

# Tests specifically for castling with the KingMove class
describe KingMove do
  describe "#castling?" do
    context "when black has queenside castling" do
      it "returns true" do
        black_queenside = described_class.new("r3k1nr/pppb1ppp/2np1q2/1Bb1p3/4P3/2N2N2/PPPP1PPP/R1BQK2R b KQq - 0 1")
        black_queenside.update_start_square("e8")
        black_queenside.update_finish_square("c8")
        expect(black_queenside.castling?).to eq(true)
      end
    end
    context "when white has lost kingside castling" do
      it "returns false" do
        white_kingside = described_class.new("r3k1nr/pppb1ppp/2np1q2/1Bb1p3/4P3/2N2N2/PPPP1PPP/R1BQK2R w Qkq - 0 1")
        white_kingside.update_start_square("e1")
        white_kingside.update_finish_square("g1")
        expect(white_kingside.castling?).to eq(false)
      end
    end

  end
end
