require_relative 'pieces/piece'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/null'
require_relative 'pieces/stepable'
require_relative 'pieces/slideable'

class Piece

  attr_reader :color, :pos, :symbol

  def initialize(board = nil, pos = nil)
    @board = board
    @pos = pos
    @color = nil
    @symbol = symbol

  end

  def moves

  end

  def to_s

  end

  def empty?

  end

  def symbol
    # :q if self.is_a?(Queen)
    # :Ki if self.is_a?(King)
    # :r if self.is_a?(Rook)
    # :b if self.is_a?(Bishop)
    # :Kn if self.is_a?(Knight)
    # :p if self.is_a?(Pawn)
  end

  # for most pieces, #valid_moves will truncate the possible_moves based
  # on other pieces.  For pawns, this will also add 'take piece' moves
  def valid_moves

  end

  private

  def move_into_check(to_pos)

  end
end

module SlidingPiece
  def moves(pos)
    possible_moves = []
    move_dirs.each do |direction|
      case direction
      when :lateral
        possible_moves.concat(lateral_dirs(pos))
      when :diagonal
        possible_moves.concat(diagonal_dirs(pos))
      end
    end

    possible_moves
  end

  private

  def move_dirs
    [:lateral, :diagonal]
  end

  def lateral_dirs(pos)
    laterals = []

    (0..7).each do |i|
      laterals << [i, pos[1]] unless i == pos[0]
      laterals << [pos[0], i] unless i == pos[1]
    end

    laterals
  end

  def diagonal_dirs(pos)
    diagonals = []

    (1..7).each do |i|
      diagonals << [pos[0] + i, pos[1] + i]
      diagonals << [pos[0] - i, pos[1] + i]
      diagonals << [pos[0] + i, pos[1] - i]
      diagonals << [pos[0] - i, pos[1] - i]
    end

    diagonals.select do |pos|
      pos[0] >= 0 && pos[1] >= 0 && pos[0] <= 7 && pos[1] <= 7
    end
  end

  # def grow_unblocked_moves_in_dir(dx, dy)
  #
  # end

end

module SteppingPiece
  def moves(pos)
    possible_moves = []
    move_diffs.each do |diff|
      case diff
      when :single
        possible_moves.concat(single_moves(pos))
      when :jump
        possible_moves.concat(jump_moves(pos))
      end
    end

    possible_moves.select do |pos|
      pos[0] >= 0 && pos[1] >= 0 && pos[0] <= 7 && pos[1] <= 7
    end
  end


  def move_diffs
    [:single, :jump]
  end

  def single_moves(pos)
    moves = []

    displacement = [-1, 0, 1].permutation(2).to_a
    displacement.delete([0, 0])
    displacement += [[-1, -1], [1, 1]]
    displacement.each do |op|
      moves << [(pos[0] + op[0]), (pos[1] + op[1])]
    end

    moves
  end

  def jump_moves(pos)
    moves = []

    displacement = [-2, -1, 1, 2].permutation(2).to_a

    displacement.delete([-1, 1])
    displacement.delete([1, -1])
    displacement.delete([-2, 2])
    displacement.delete([2, -2])

    displacement.each do |op|
      moves << [(pos[0] + op[0]), (pos[1] + op[1])]
    end

    moves
  end

end

class Rook < Piece
  include SlidingPiece

  def initialize
    super
    @symbol = :r
  end

  def move_dirs
    [:lateral]
  end

end

class Bishop < Piece
  include SlidingPiece

  def initialize
    super
    @symbol = :b
  end

  def move_dirs
    [:diagonal]
  end
end

class Queen < Piece
  include SlidingPiece
  def initialize
    super
    @symbol = :Q
  end

  def move_dirs
    [:lateral, :diagonal]
  end
end

class Knight < Piece
  include SteppingPiece

  def initialize
    super
    @symbol = :kn
  end

  def move_diffs
    [:jump]
  end
end

class King < Piece
  include SteppingPiece

  def initialize
    super
    @symbol = :Ki
  end

  def move_diffs
    [:single]
  end
end

class Pawn < Piece
  def initialize(start_pos)
    super
    @symbol = :p
    @start_pos = start_pos
  end

  def moves(pos)
    possible_moves = []
    if self.color == :black
      possible_moves << [pos[0] + 1, pos[1]]
      possible_moves << [pos[0] + 2, pos[1]] if pos == @start_pos
    else
      possible_moves << [pos[0] - 1, pos[1]]
      possible_moves << [pos[0] - 2, pos[1]] if pos == @start_pos
    end
  end
end

class NullPiece
  include Singleton

  attr_reader :color, :symbol

  def initialize(color = nil, symbol = nil)
    @color = color
    @symbol = symbol
  end
end
