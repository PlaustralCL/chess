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

    context "when kingside castling is allowed for white" do
      it "allows f1 as a finish square" do
        basic_castling = described_class.new("4k3/8/8/8/8/8/8/4K2R w K - 0 1")
        actual_piece_locations = basic_castling.finish_square_choices("e1")
        expect(actual_piece_locations).to contain_exactly("d1", "d2", "e2", "f2", "f1", "g1")
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

  describe "#move_piece" do
    context "when a queen moves" do
      it "updates the board to show the new position" do
        queen_move = described_class.new("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 3 3")
        queen_move.move_piece("d1", "e2")
        expect(queen_move.fen[:piece_position]).to eq("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPPQPPP/RNB1K2R")
      end
    end

    context "when a queen moves" do
      it "The castling abilities do not change" do
        queen_move = described_class.new("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 3 3")
        queen_move.move_piece("d1", "e2")
        expect(queen_move.fen[:castling_ability]).to eq("KQkq")
      end
    end

    context "when a knigt moves" do
      it "updates the board to show the new position" do
        knight_move = described_class.new("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 3 3")
        knight_move.move_piece("b1", "c3")
        expect(knight_move.fen[:piece_position]).to eq("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R")
      end
    end

    context "when a king moves one square" do
      it "updates the board to show the new position" do
        king_move = described_class.new("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 3 3")
        king_move.move_piece("e1", "f1")
        expect(king_move.fen[:piece_position]).to eq("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1K1R")
      end
    end

    context "when a king moves one square" do
      it "That side looses all castling ability" do
        king_move = described_class.new("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 3 3")
        king_move.move_piece("e1", "f1")
        expect(king_move.fen[:castling_ability]).to eq("kq")
      end
    end

    context "when a king castles kingside" do
      it "updates the board to move the king and kingside rook" do
        king_move = described_class.new("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 3 3")
        king_move.move_piece("e1", "g1")
        expect(king_move.fen[:piece_position]).to eq("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1")
      end
    end

    context "when a king castles kingside" do
      it "That side looses all castling ability" do
        king_move = described_class.new("r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 3 3")
        king_move.move_piece("e1", "g1")
        expect(king_move.fen[:castling_ability]).to eq("kq")
      end
    end

    context "when a king castles queenside" do
      it "updates the board to move the king and queenside rook" do
        king_move = described_class.new("r3kbnr/pppbqppp/2np4/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 3 3")
        king_move.move_piece("e8", "c8")
        expect(king_move.fen[:piece_position]).to eq("2kr1bnr/pppbqppp/2np4/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1")
      end
    end

    context "when a king castles queenside" do
      it "That side looses all castling ability" do
        king_move = described_class.new("r3kbnr/pppbqppp/2np4/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 3 3")
        king_move.move_piece("e8", "c8")
        expect(king_move.fen[:castling_ability]).to eq("-")
      end
    end

    context "when a rook moves" do
      it "updates the board" do
        rook_move = described_class.new("r3kbnr/pppqpppp/2n5/3p1b2/2PP4/2N1PN2/PP3PPP/R1BQKB1R b KQkq - 0 5")
        rook_move.move_piece("a8", "d8")
        expect(rook_move.fen[:piece_position]).to eq("3rkbnr/pppqpppp/2n5/3p1b2/2PP4/2N1PN2/PP3PPP/R1BQKB1R")
      end
    end

    context "when the black queenside rook moves" do
      it "removes queenside castling" do
        rook_move = described_class.new("r3kbnr/pppqpppp/2n5/3p1b2/2PP4/2N1PN2/PP3PPP/R1BQKB1R b KQkq - 0 5")
        rook_move.move_piece("a8", "d8")
        expect(rook_move.fen[:castling_ability]).to eq("KQk")
      end
    end

    context "when a rook is captured on it starting square" do
      it "removes the associated castling ability" do
        rook_capture = described_class.new("r1bqk2r/p1ppnp1p/1pn1p1p1/8/1P2P3/1P6/1BPP1PPP/RN1QKBNR w KQkq - 0 1")
        rook_capture.move_piece("b2", "h8")
        expect(rook_capture.fen[:castling_ability]).to eq("KQq")
      end
    end

    context "when a rook is captured on it starting square" do
      it "removes the associated castling ability" do
        rook_capture = described_class.new("r1bqk3/p1ppnp1p/1pn1p1p1/8/1P2P3/1P6/1BPP1PPP/RN1QKBNR w KQq - 0 1")
        rook_capture.move_piece("b2", "h8")
        expect(rook_capture.fen[:castling_ability]).to eq("KQq")
      end
    end

    # en passant/ pawn move testing
    context "when a pawn moves one square" do
      it "updates the board correctly" do
        basic_pawn_move = described_class.new("rnbqkbnr/ppp2ppp/8/3p4/3Pp3/2P5/PP2PPPP/RNBQKBNR w KQkq - 0 1")
        basic_pawn_move.move_piece("a1", "a2")
        expect(basic_pawn_move.fen[:piece_position]).to eq("rnbqkbnr/ppp2ppp/8/3p4/3Pp3/P1P5/1P2PPPP/RNBQKBNR b KQkq - 0 1")
      end
    end

    context "when a pawn moves one square" do
      it "the ep_target_square is '-'" do
        basic_pawn_move = described_class.new("rnbqkbnr/ppp2ppp/8/3p4/3Pp3/2P5/PP2PPPP/RNBQKBNR w KQkq - 0 1")
        basic_pawn_move.move_piece("a2", "a3")
        expect(basic_pawn_move.fen[:ep_target_square]).to eq("-")
      end
    end

    context "when a pawn moves two squares" do
      it "updates the board correctly" do
        basic_pawn_move = described_class.new("rnbqkbnr/ppp2ppp/8/3p4/3Pp3/2P5/PP2PPPP/RNBQKBNR w KQkq - 0 1")
        basic_pawn_move.move_piece("f2", "f4")
        expect(basic_pawn_move.fen[:piece_position]).to eq("rnbqkbnr/ppp2ppp/8/3p4/3PpP2/2P5/PP2P1PP/RNBQKBNR b KQkq f3 0 1")
      end
    end

    context "when a pawn moves two squares" do
      it "the ep_target_square shows the square that was jumped" do
        basic_pawn_move = described_class.new("rnbqkbnr/ppp2ppp/8/3p4/3Pp3/2P5/PP2PPPP/RNBQKBNR w KQkq - 0 1")
        basic_pawn_move.move_piece("f2", "f4")
        expect(basic_pawn_move.fen[:ep_target_square]).to eq("f3")
      end
    end

    context "when a pawn makes a normal capture" do
      it "updates the board correctly" do
        basic_pawn_capture = described_class.new("rnbqkbnr/1pp2ppp/p7/3p4/2PPp3/8/PP2PPPP/RNBQKBNR w KQkq - 0 2")
        basic_pawn_capture.move_piece("c4", "d5")
        expect(basic_pawn_capture.fen[:piece_position]).to eq("rnbqkbnr/1pp2ppp/p7/3P4/3Pp3/8/PP2PPPP/RNBQKBNR b KQkq - 0 2")
      end
    end

    context "when a pawn makes a normal capture" do
      it "the ep_target_square is '-'" do
        basic_pawn_capture = described_class.new("rnbqkbnr/1pp2ppp/p7/3p4/2PPp3/8/PP2PPPP/RNBQKBNR w KQkq - 0 2")
        basic_pawn_capture.move_piece("c4", "d5")
        expect(basic_pawn_move.fen[:ep_target_square]).to eq("-")
      end
    end

    context "when a white pawn makes a ep capture" do
      it "updates the board correctly" do
        white_ep_capture = described_class.new("rnbqkbnr/1p3ppp/p7/2pP4/3Pp3/8/PP2PPPP/RNBQKBNR w KQkq c6 0 3")
        white_ep_capture.move_piece("d5", "c6")
        expect(white_ep_capture.fen[:piece_position]).to eq("rnbqkbnr/1p3ppp/p1P5/8/3Pp3/8/PP2PPPP/RNBQKBNR b KQkq - 0 3")
      end
    end

    context "when a white pawn makes a ep capture" do
      it "the ep_target_square is '-'" do
        white_ep_capture = described_class.new("rnbqkbnr/1p3ppp/p7/2pP4/3Pp3/8/PP2PPPP/RNBQKBNR w KQkq c6 0 3")
        white_ep_capture.move_piece("d5", "c6")
        expect(basic_pawn_move.fen[:ep_target_square]).to eq("-")
      end
    end

    context "when a black pawn makes a ep capture" do
      it "updates the board correctly" do
        black_ep_capture = described_class.new("rnbqkbnr/1pp2ppp/p7/3p4/2PPpP2/8/PP2P1PP/RNBQKBNR b KQkq f3 0 2")
        black_ep_capture.move_piece("e4", "f3")
        expect(black_ep_capture.fen[:piece_position]).to eq("rnbqkbnr/1pp2ppp/p7/3p4/2PP4/5p2/PP2P1PP/RNBQKBNR w KQkq - 0 3")
      end
    end

    context "when a black pawn makes a ep capture" do
      it "the ep_target_square is '-'" do
        black_ep_capture = described_class.new("rnbqkbnr/1pp2ppp/p7/3p4/2PPpP2/8/PP2P1PP/RNBQKBNR b KQkq f3 0 2")
        black_ep_capture.move_piece("e4", "f3")
        expect(basic_pawn_move.fen[:ep_target_square]).to eq("-")
      end
    end
  end
end
