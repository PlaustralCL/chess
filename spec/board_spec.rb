# frozen_string_literal: true

require_relative "../lib/board"

describe Board do
  subject(:new_board) { described_class.new }

  describe "#name_converter" do
    it "converts algebraic name to the correct square" do
      expect(new_board.name_converter("h1")).to eq(new_board.gameboard[63])
    end
  end

  describe "#different_squares?" do
    context "when start and finish are the same" do
      it "returns fales" do
        expect(new_board.different_squares?("e2", "e2")).to eq(false)
      end
    end

    context "when start and finish are different" do
      it "returns true" do
        expect(new_board.different_squares?("e2", "e4")).to eq(true)
      end
    end
  end

  describe "#basic_rules?" do
    basic_white_rook = described_class.new("8/8/1R4p1/8/8/8/1P6/8")
    start_square = basic_white_rook.gameboard[17]

    context "when rook moves horizontally" do
      finish_square = basic_white_rook.gameboard[19]
      it "returns true" do
        expect(basic_white_rook.basic_rules?(start_square, finish_square)).to eq(true)
      end
    end

    context "when rook moves vertically" do
      finish_square = basic_white_rook.gameboard[33]
      it "returns true" do
        expect(basic_white_rook.basic_rules?(start_square, finish_square)).to eq(true)
      end
    end

    context "when rook moves illeagally" do
      finish_square = basic_white_rook.gameboard[44]
      it "returns false" do
        expect(basic_white_rook.basic_rules?(start_square, finish_square)).to eq(false)
      end
    end
  end

  describe "#finish_square_allowed?" do
    basic_white_rook = described_class.new("8/8/1R4p1/8/8/8/1P6/8")
    start_square = basic_white_rook.gameboard[17]

    context "when finish is empty" do
      finish_square = basic_white_rook.gameboard[19]
      it "returns true" do
        expect(basic_white_rook.finish_square_allowed?(start_square, finish_square)).to eq(true)
      end
    end

    context "when finish has opposite colored piece" do
      finish_square = basic_white_rook.gameboard[22]
      it "returns true" do
        expect(basic_white_rook.finish_square_allowed?(start_square, finish_square)).to eq(true)

      end
    end

    context "when finish has same colored piece" do
      finish_square = basic_white_rook.gameboard[49]
      it "returns false" do
        expect(basic_white_rook.finish_square_allowed?(start_square, finish_square)).to eq(false)
      end
    end
  end

  describe "#clear_path?" do
    white_rook = described_class.new("8/8/1R1p2p1/8/8/8/1P6/8")
    g2_rook = described_class.new("8/8/8/8/6P1/8/6R1/8")

    context "rook moving right when the path is not clear" do
      start_square = white_rook.gameboard[17]
      finish_square = white_rook.gameboard[22]
      it "returns false" do
        expect(white_rook.clear_path?(start_square, finish_square)).to eq(false)
      end
    end

    context "rook moving down when the path is clear" do
      start_square = white_rook.gameboard[17]
      finish_square = white_rook.gameboard[41]
      it "returns true" do
        expect(white_rook.clear_path?(start_square, finish_square)).to eq(true)
      end
    end

    context "rook moving left and the path is clear" do
      start_square = g2_rook.gameboard[54]
      finish_square = g2_rook.gameboard[49]
      it "returns true" do
        expect(g2_rook.clear_path?(start_square, finish_square)).to eq(true)
      end
    end

    context "rook moving up and the path is not clear" do
      start_square = g2_rook.gameboard[54]
      finish_square = g2_rook.gameboard[22]
      it "returns false" do
        expect(g2_rook.clear_path?(start_square, finish_square)).to eq(false)
      end
    end

    context "rook moving one square left" do
      start_square = g2_rook.gameboard[54]
      finish_square = g2_rook.gameboard[53]
      it "returns true" do
        expect(g2_rook.clear_path?(start_square, finish_square)).to eq(true)
      end
    end
  end
end
