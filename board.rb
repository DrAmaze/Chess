require_relative 'piece'
require_relative 'cursor'

class MovementError < StandardError
  def start_message
    "No piece to move."
  end

  def end_message
    "Cannot move here."
  end
end


class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @grid.each_index do |row|
      @grid[row].each_index do |col|
        @grid[row][col] = Piece.new if row <= 1 || row >= 6
      end
    end
  end

  def move_piece(start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos

    raise MovementError if self[start_pos].nil?
    raise MovementError if !in_bounds?(end_pos)

    self[end_pos] = self[start_pos]
    self[start_pos] = nil  # nil piece
  end

  def in_bounds?(pos)
    (pos[0] < 0 || pos[0] > 7 || pos[1] < 0 || pos[1] > 7) ? false : true
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

end
