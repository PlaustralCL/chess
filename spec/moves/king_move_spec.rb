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

  describe "clear_path?" do
    bishop_board = described_class.new("8/2b5/8/8/4K3/8/8/8")

    context "when king moves e4-e5, bishop blocks e5" do
      it "returns false" do
        bishop_board.update_start_square("e4")
        bishop_board.update_finish_square("e5")
        expect(bishop_board.clear_path?).to eq(false)
      end
    end

    context "when king moves e4-d3, bishop blocks e5 and f4" do
      it "returns true" do
        bishop_board.update_start_square("e4")
        bishop_board.update_finish_square("d3")
        expect(bishop_board.clear_path?).to eq(true)
      end
    end
  end
end