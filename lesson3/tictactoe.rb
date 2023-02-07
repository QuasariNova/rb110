# I want to build my own version of the game without following the videos. So
# please forgive me if my solution is vastly different.

# Tic Tac Toe is a 2 player game played on a 3x3 board. Each player takes a
# turn and marks a square on the board. First player to reach 3 squares in a
# row, including diagonals, wins. If all 9 squares are marked and no player has
# 3 squares in a row, then the game is a tie.

# Game flow:
# 1. Determine who goes first
# 2. Display the initial empty 3x3 board
# 3. Ask turn player to mark square
# 4. Display updated board
# 5. If winner, display win
# 6. If board is full, display draw
# 7. If neither winner nor board is full, swap turn player and go to 3
# 8. Play again?
# 9. If yes, go to #1
# 10. Goodbye

# Flowchart is on the repository /lesson3/tictactoe.diagram.png
require 'yaml'
require 'io/console'

STRINGS = YAML.load_file "tictactoe.yaml"
EMPTY = ' '
COMPUTER = 'O'
USER = 'X'

def display_title
  $stdout.clear_screen
  puts STRINGS["title"]
  puts("\n" + STRINGS["press_a_key"].center(58))
  $stdin.getch
end

def generate_empty_board
  Hash.new(EMPTY)
end

def display_board(board)
  (0..2).each do |row|
    one = row * 3 + 1
    two = row * 3 + 2
    three = row * 3 + 3
    puts format(STRINGS['board_numbered'], one, two, three )
    puts format(STRINGS['board_markers'], board[one], board[two], board[three])
    puts STRING['board_empty']
    puts STRING['board_separator'] unless row == 2
  end
end

# main program
display_title

board = generate_empty_board
display_board(board)
