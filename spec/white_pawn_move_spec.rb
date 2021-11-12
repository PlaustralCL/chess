# frozen_string_literal: true

require_relative "../lib/white_pawn_move"

describe WhitePawnMove do
  subject(:basic_board) { described_class.new("8/P7/1P3p1p/6P1/8/2P5/4P3/8") }

  describe "#basic_rules?" do
    # starting position
    context "pawn moves from e2 to e4" do
      it "returns true" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("e4")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn moves from e2 to e3" do
      it "returns true" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("e3")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn mves from e2 to e5" do
      it "returns false" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("e5")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn mves from e2 to e1" do
      it "returns false" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("e1")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn mves from e2 to g3" do
      it "returns false" do
        basic_board.update_start_square("e2")
        basic_board.update_finish_square("g3")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    # normal move
    context "pawn moves from c3 to c5" do
      it "returns false" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("c5")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn moves from c3 to c4" do
      it "returns true" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("c4")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn moves from c3 to c2" do
      it "returns false" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("c2")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn moves from c3 to a4" do
      it "returns false" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("a4")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    # capture
    context "pawn captures from g5 to f6" do
      it "returns true" do
        basic_board.update_start_square("g5")
        basic_board.update_finish_square("f6")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn captures from g5 to h6" do
      it "returns true" do
        basic_board.update_start_square("g5")
        basic_board.update_finish_square("h6")
        expect(basic_board.basic_rules?).to eq(true)
      end
    end

    context "pawn moves diagonally when no piece to capture" do
      it "returns false" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("b4")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn trys to capture own piece" do
      it "returns false" do
        basic_board.update_start_square("b6")
        basic_board.update_finish_square("a7")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end

    context "pawn moves diagonally backward" do
      it "returns false" do
        basic_board.update_start_square("c3")
        basic_board.update_finish_square("f4")
        expect(basic_board.basic_rules?).to eq(false)
      end
    end
  end

  describe "#clear_path?" do

  end
end
