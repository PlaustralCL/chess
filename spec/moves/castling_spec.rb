# frozen_string_literal: true

require_relative "../../lib/moves/king_move"

# Tests specifically for castling with the KingMove class
describe KingMove do
  describe "#castling_rights?" do
    # castling_rights?
    context "when black has queenside castling" do
      it "returns true" do
        black_queenside = described_class.new("r3k1nr/pppb1ppp/2np1q2/1Bb1p3/4P3/2N2N2/PPPP1PPP/R1BQK2R b KQq - 0 1")
        black_queenside.update_start_square("e8")
        black_queenside.update_finish_square("c8")
        expect(black_queenside.castling_rights?).to eq(true)
      end
    end

    context "when white has lost kingside castling" do
      it "returns false" do
        white_kingside = described_class.new("r3k1nr/pppb1ppp/2np1q2/1Bb1p3/4P3/2N2N2/PPPP1PPP/R1BQK2R w Qkq - 0 1")
        white_kingside.update_start_square("e1")
        white_kingside.update_finish_square("g1")
        expect(white_kingside.castling_rights?).to eq(false)
      end
    end
  end

  describe "#castling_path_clear?" do
    context "When the path is not clear for white" do
      it "returns false" do
        white_not_clear = described_class.new("rnbqkbnr/ppp2ppp/3p4/4p3/2B1P3/8/PPPP1PPP/RNBQK1NR w KQkq - 0 3")
        white_not_clear.update_start_square("e1")
        white_not_clear.update_finish_square("g1")
        expect(white_not_clear.castling_path_clear?).to eq(false)
      end
    end

    context "when the path is not clear for black" do
      it "returns false" do
        black_not_clear = described_class.new("rn2kbnr/pppbqppp/3p4/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQ1RK1 b kq - 5 5")
        black_not_clear.update_start_square("e8")
        black_not_clear.update_finish_square("c8")
        expect(black_not_clear.castling_path_clear?).to eq(false)

      end
    end

    context "when the path is clear for queenside" do
      it "returns true" do
        queenside_clear = described_class.new("r3kbnr/ppp1qppp/2np4/1B2p3/4P1b1/2NP1N2/PPP2PPP/R1BQ1RK1 b kq - 0 6")
        queenside_clear.update_start_square("e8")
        queenside_clear.update_finish_square("c8")
        expect(queenside_clear.castling_path_clear?).to eq(true)
      end
    end

    context "when the path is clear for kingside" do
      it "returns true" do
        kingside_clear = described_class.new("r1bqkbnr/ppp2ppp/2np4/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 4")
        kingside_clear.update_start_square("e1")
        kingside_clear.update_finish_square("g1")
        expect(kingside_clear.castling_path_clear?).to eq(true)
      end
    end
  end

  describe "#safe_castling?" do
    context "when no checks" do
      it "returns true" do
        no_check = described_class.new("r1bqkbnr/ppp2ppp/2np4/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 4")
        no_check.update_start_square("e1")
        no_check.update_finish_square("g1")
        expect(no_check.safe_castling?).to eq(true)
      end
    end

    context "when starting square checked" do
      it "returns false" do
        starting_check = described_class.new("r1bqk1nr/ppp2ppp/2n5/1B1pp3/1b2P3/3P1N1P/PPP2PP1/RNBQK2R w KQkq - 1 6")
        starting_check.update_start_square("e1")
        starting_check.update_finish_square("g1")
        expect(starting_check.safe_castling?).to eq(false)
      end
    end

    context "when middle square checked" do
      it "returns false" do
        middle_check = described_class.new("rnbqk2r/pppp1p1p/5npB/2b1p3/4P3/P1NP4/1PP2PPP/R2QKBNR b KQkq - 0 5")
        middle_check.update_start_square("e8")
        middle_check.update_finish_square("g8")
        expect(middle_check.safe_castling?).to eq(false)
      end
    end

    context "when finish square checked" do
      it "returns false" do
        finish_check = described_class.new("r3kb1r/pppb1ppp/2np1n2/4p1q1/3PP3/1PN2Q2/PBP2PPP/R3KBNR w KQkq - 3 7")
        finish_check.update_start_square("e1")
        finish_check.update_finish_square("c1")
        expect(finish_check.safe_castling?).to eq(false)
      end
    end
  end

  describe "#castling?" do
    context "when castling is allowed" do
      it "returns true" do
        castling_allowed = described_class.new("r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4")
        castling_allowed.update_start_square("e1")
        castling_allowed.update_finish_square("g1")
        expect(castling_allowed.castling?).to eq(true)
      end
    end
  end
end
