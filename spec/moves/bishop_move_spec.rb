# frozen_string_literal: true

require_relative "../../lib/moves/bishop_move"

describe BishopMove do
  subject(:new_board) { described_class.new }

  describe "#basic_rules?" do
    context "when bishop moves e5 to g7" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("g7")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when bishop moves e5 to h2" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("h2")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when bishop moves e5 to b2" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("b2")
        expect(new_board.basic_rules?).to eq(true)
      end
    end

    context "when bishop moves e5 to a5" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("a5")
        expect(new_board.basic_rules?).to eq(false)
      end
    end

    context "when bishop moves e5 to c7" do
      it "returns true" do
        new_board.update_start_square("e5")
        new_board.update_finish_square("c7")
        expect(new_board.basic_rules?).to eq(true)
      end
    end
  end

  describe "#clear_path?" do
    subject(:bishop_obstructions) { described_class.new("8/2p3p1/5P2/4B3/8/6P1/1p5p/8")}

    context "when bishop moves e5 to g7 with obstruction" do
      it "returns true" do
        bishop_obstructions.update_start_square("e5")
        bishop_obstructions.update_finish_square("g7")
        expect(bishop_obstructions.clear_path?).to eq(false)
      end
    end

    context "when bishop moves e5 to h2 with obstruction" do
      it "returns true" do
        bishop_obstructions.update_start_square("e5")
        bishop_obstructions.update_finish_square("h2")
        expect(bishop_obstructions.clear_path?).to eq(false)
      end
    end

    context "when bishop moves e5 to b2, no obstruction" do
      it "returns true" do
        bishop_obstructions.update_start_square("e5")
        bishop_obstructions.update_finish_square("b2")
        expect(bishop_obstructions.clear_path?).to eq(true)
      end
    end

    context "when bishop moves e5 to c7, no obstruction" do
      it "returns true" do
        bishop_obstructions.update_start_square("e5")
        bishop_obstructions.update_finish_square("c7")
        expect(bishop_obstructions.clear_path?).to eq(true)
      end
    end
  end

  describe "#valid_move" do
    context "when pinned bishop tries to move" do
      it "returns false" do
        pinned_bishop = described_class.new("5k2/8/5b2/8/8/8/5R2/6K1")
        expect(pinned_bishop.valid_move?("f6", "e7")).to eq(false)
      end
    end

    context "when non-pinned bishop tries to move" do
      it "returns true" do
        pinned_bishop = described_class.new("5k2/8/5b2/8/8/8/8/6K1")
        expect(pinned_bishop.valid_move?("f6", "e7")).to eq(true)
      end
    end
  end
end
