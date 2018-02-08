require_relative 'board'
require_relative 'cursor'
require 'byebug'
require 'colorize'

class Display
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end

  def render
    puts "  #{(0..7).to_a.join(" ")}"
    @board.grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        if j == 0
          print "#{i}"
        end
        if @cursor.cursor_pos == [i, j]
          print " #{col}".colorize(background: :light_blue)
        else
          print " #{col}"
        end
        if j == 7
          puts ""
        end
      end
    end
  end

  def move_cursor
    while true
      @cursor.get_input
      render
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  display = Display.new(board)
  display.render
  display.move_cursor
end
