# frozen_string_literal: true

require_relative "board_helper"

# Prepare the display
class Display
  include BoardHelper

  attr_reader :gameboard, :display_board

  def initialize(position = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    @gameboard = Array.new(64) { Square.new }
    setup_board(position)
  end

  def update_gameboard(board)
    @gameboard = board
  end

  def build_display
    @display_board = gameboard.map { |piece| piece == " - " ? "   " : piece }
    @display_board = display_board.map { |piece_name| piece_name.center(3) }
  end
end
