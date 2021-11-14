# frozen_string_literal: true

require_relative "../../lib/moves/rook_move"

describe RookMove do
  subject(:new_board) { described_class.new }

  describe "#name_converter" do
    it "converts algebraic name to the correct square" do
      expect(new_board.name_converter("h1")).to eq(new_board.gameboard[63])
    end
  end

  describe "#different_squares?" do
    context "when start and finish are the same" do
      it "returns false" do
        new_board.update_start_square("e7")
        new_board.update_finish_square("e7")
        expect(new_board.different_squares?).to eq(false)
      end
    end

    context "when start and finish are different" do
      it "returns true" do
        new_board.update_start_square("e7")
        new_board.update_finish_square("e5")
        expect(new_board.different_squares?).to eq(true)
      end
    end
  end

  describe "#basic_rules?" do
    basic_white_rook = described_class.new("8/8/1R4p1/8/8/8/1P6/8")
    context "when rook moves horizontally" do
      it "returns true" do
        basic_white_rook.update_start_square("b6")
        basic_white_rook.update_finish_square("d6")
        expect(basic_white_rook.basic_rules?).to eq(true)
      end
    end

    context "when rook moves vertically" do
      basic_white_rook = described_class.new("8/8/1R4p1/8/8/8/1P6/8")
      it "returns true" do
        basic_white_rook.update_start_square("b6")
        basic_white_rook.update_finish_square("b4")
        expect(basic_white_rook.basic_rules?).to eq(true)
      end
    end

    context "when rook moves illeagally" do
      it "returns false" do
        basic_white_rook.update_start_square("b6")
        basic_white_rook.update_finish_square("e3")
        expect(basic_white_rook.basic_rules?).to eq(false)
      end
    end
  end

  describe "#finish_square_allowed?" do
    basic_white_rook = described_class.new("8/8/1R4p1/8/8/8/1P6/8")


    context "when finish is empty" do
      it "returns true" do
        basic_white_rook.update_start_square("b6")
        basic_white_rook.update_finish_square("d6")
        expect(basic_white_rook.finish_square_allowed?).to eq(true)
      end
    end

    context "when finish has opposite colored piece" do
      it "returns true" do
        basic_white_rook.update_start_square("b6")
        basic_white_rook.update_finish_square("g6")
        expect(basic_white_rook.finish_square_allowed?).to eq(true)
      end
    end

    context "when finish has same colored piece" do
      it "returns false" do
        basic_white_rook.update_start_square("b6")
        basic_white_rook.update_finish_square("b2")
        expect(basic_white_rook.finish_square_allowed?).to eq(false)
      end
    end
  end

  describe "#clear_path?" do
    white_rook = described_class.new("8/8/1R1p2p1/8/8/8/1P6/8")
    g2_rook = described_class.new("8/8/8/8/6P1/8/6R1/8")

    context "rook moving right when the path is not clear" do
      it "returns false" do
        white_rook.update_start_square("b6")
        white_rook.update_finish_square("g6")
        expect(white_rook.clear_path?).to eq(false)
      end
    end

    context "rook moving down when the path is clear" do
      it "returns true" do
        white_rook.update_start_square("b6")
        white_rook.update_finish_square("b3")
        expect(white_rook.clear_path?).to eq(true)
      end
    end

    context "rook moving left and the path is clear" do
      it "returns true" do
        g2_rook.update_start_square("g2")
        g2_rook.update_finish_square("b2")
        expect(g2_rook.clear_path?).to eq(true)
      end
    end

    context "rook moving up and the path is not clear" do
      it "returns false" do
        g2_rook.update_start_square("g2")
        g2_rook.update_finish_square("g6")
        expect(g2_rook.clear_path?).to eq(false)
      end
    end

    context "rook moving one square left" do
      it "returns true" do
        g2_rook.update_start_square("g2")
        g2_rook.update_finish_square("f2")
        expect(g2_rook.clear_path?).to eq(true)
      end
    end
  end

  describe "#valid_move?" do
    context "rook moving up and the path is not clear" do
      g2_rook = described_class.new("8/8/8/8/6P1/8/6R1/8")
      start_name = "g2"
      finish_name = "g6"
      it "returns false" do
        expect(g2_rook.valid_move?(start_name, finish_name)).to eq(false)
      end
    end

    context "when rook moves vertically" do
      basic_white_rook = described_class.new("8/8/1R4p1/8/8/8/1P6/8")
      start_name = "b6"
      finish_name = "b4"
      it "returns true" do
        expect(basic_white_rook.valid_move?(start_name, finish_name)).to eq(true)
      end
    end
  end
end
