# frozen_string_literal: true

require_relative "../lib/board"

describe Board do
  subject(:new_board) { described_class.new }

  describe "#start_square_choices" do
    context "when not all pieces have moves" do
      it "returns the names squares with pieces that can move" do
        pieces_board = described_class.new("6k1/8/8/2b5/8/5pp1/5P2/2R3K1")
        pieces_board.update_current_player("white")
        actual_piece_locations = pieces_board.start_square_choices
        expect(actual_piece_locations).to contain_exactly("c1", "g1")
      end
    end

    context "when stalemate" do
      it "retuns an empty array" do
        stalemate = described_class.new("7k/8/6Q1/8/8/8/8/7K")
        stalemate.update_current_player("black")
        expect(stalemate.start_square_choices).to be_empty
      end
    end

    context "when new board" do
      it "returns pawns and knights" do
        new_board.update_current_player("white")
        expect(new_board.start_square_choices).to contain_exactly("a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2", "b1", "g1")
      end
    end
  end

  describe "#finish_square_choices" do
    context "when the piece has limited moves" do
      it "returns the names of squares the piece can move to" do
        bishop_start_board = described_class.new("2r3k1/8/4b3/8/2B3p1/8/8/6K1")
        actual_piece_locations = bishop_start_board.finish_square_choices("e6")
        expect(actual_piece_locations).to contain_exactly("c4", "d5", "f7")
      end
    end
  end

  describe "#valid_move?" do
    context "when given an valid move" do
      it "returns true" do
        expect(new_board.valid_move?("g1", "f3")).to eq(true)
      end
    end

    context "when given an invalid move" do
      it "returns false" do
        expect(new_board.valid_move?("a1", "f3")).to eq(false)
      end
    end
  end

  describe "#game_over?" do
    context "when new board" do
      it "returns false" do
        new_board.update_current_player("white")
        expect(new_board.game_over?).to eq(false)
      end
    end

    context "when stalemate" do
      it "returns true" do
        stalemate_board = described_class.new("7k/8/6Q1/8/8/8/8/6K1")
        stalemate_board.update_current_player("black")
        expect(stalemate_board.game_over?).to eq(true)
      end
    end

    context "when stalemate" do
      it "sets winner to 'stalemate'" do
        stalemate_board = described_class.new("7k/8/6Q1/8/8/8/8/6K1")
        stalemate_board.update_current_player("black")
        stalemate_board.game_over?
        expect(stalemate_board.winner).to eq("stalemate")
      end
    end

    context "when black is checkmated" do
      it "sets winner to 'white'" do
        black_checkmate_board = described_class.new("7k/8/8/6R1/7R/8/8/7K")
        black_checkmate_board.update_current_player("black")
        black_checkmate_board.game_over?
        expect(black_checkmate_board.winner).to eq("white")
      end
    end

    context "when black is checkmated" do
      it "returns true" do
        black_checkmate_board = described_class.new("7k/8/8/6R1/7R/8/8/7K")
        black_checkmate_board.update_current_player("black")
        expect(black_checkmate_board.game_over?).to eq(true)
      end
    end

    context "when white is checkmated" do
      it "sets winner to 'black'" do
        white_checkmate_board = described_class.new("7k/8/8/7r/6r1/8/8/7K")
        white_checkmate_board.update_current_player("white")
        white_checkmate_board.game_over?
        expect(white_checkmate_board.winner).to eq("black")
      end
    end

    context "when white is checkmated" do
      it "returns true" do
        white_checkmate_board = described_class.new("7k/8/8/7r/6r1/8/8/7K")
        white_checkmate_board.update_current_player("white")
        expect(white_checkmate_board.game_over?).to eq(true)

      end
    end



  end
end
