# frozen_string_literal: true

require_relative "../../lib/moves/king_move"

describe KingMove do
  subject(:basic_king) { described_class.new("8/8/8/8/4K3/8/8/8") }

  describe "basic_rules?" do
    context "when king moves from e4 to e5" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("e5")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to f5" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("f5")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to f4" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("f4")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to f3" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("f3")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to e3" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("e3")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to d3" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("d3")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to d4" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("d4")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to d5" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("d5")
        expect(basic_king.basic_rules?).to eq(true)
      end
    end

    context "when king moves from e4 to e7" do
      it "returns true" do
        basic_king.update_start_square("e4")
        basic_king.update_finish_square("e7")
        expect(basic_king.basic_rules?).to eq(false)
      end
    end
  end

  describe "#safe_king?" do
    bishop_board = described_class.new("6k1/2b5/8/8/4K3/8/8/8")

    context "when king moves e4-e5, bishop blocks e5" do
      it "returns false" do
        bishop_board.update_start_square("e4")
        bishop_board.update_finish_square("e5")
        expect(bishop_board.safe_king?).to eq(false)
      end
    end

    context "when king moves e4-d3, bishop blocks e5 and f4" do
      it "returns true" do
        bishop_board.update_start_square("e4")
        bishop_board.update_finish_square("d3")
        expect(bishop_board.safe_king?).to eq(true)
      end
    end

    context "check shadow - when king moves g1-h1, rook blocks h1 from c1" do
      it "returns false" do
        rook_check = described_class.new("6k1/8/8/8/4R3/8/5PPP/2r3K1")
        rook_check.update_start_square("g1")
        rook_check.update_finish_square("h1")
        expect(rook_check.safe_king?).to eq(false)
      end
    end

    context "check shadow - when the king moves f2-g1, checked by bishop on d5" do
      it "returns false" do
        bishop_check = described_class.new("6k1/8/8/2b5/8/8/5KPP/8")
        bishop_check.update_start_square("f2")
        bishop_check.update_finish_square("g1")
        expect(bishop_check.safe_king?).to eq(false)
      end
    end

    context "when the king moves g8-f8, and f8 is guarded" do
      it "returns false" do
        guarded_piece = described_class.new("5Rk1/6pp/8/2B5/8/8/8/3K4")
        guarded_piece.update_start_square("g8")
        guarded_piece.update_finish_square("f8")
        expect(guarded_piece.safe_king?).to eq(false)
      end
    end

    context "hook mate" do
      it "returns true" do
        hook_mate = described_class.new("4R3/4kp2/5N2/4P3/8/8/8/6K1")
        hook_mate.update_start_square("e7")
        hook_mate.update_finish_square("d6")
        expect(hook_mate.safe_king?).to eq(false)
      end
    end
  end

  describe "#special_move?" do
    context "when castling is allowed" do
      it "returns true" do
        castling_allowed = described_class.new("r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4")
        castling_allowed.update_start_square("e1")
        castling_allowed.update_finish_square("g1")
        expect(castling_allowed.basic_rules?).to eq(true)
      end
    end
  end

  describe "#valid_move?" do
    context "when castling is allowed" do
      it "returns true" do
        castling_allowed = described_class.new("r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4")
        start_name = "e1"
        finish_name = "g1"
        expect(castling_allowed.valid_move?(start_name, finish_name)).to eq(true)
      end
    end
  end
end
