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
MINIMUM_COIN_TURNS = 20
EMPTY = ' '
COMPUTER = 'O'
USER = 'X'


def wait_for_keypress(center)
  puts("\n" + STRINGS["press_a_key"].center(center))
  $stdin.getch
end

def display_title
  $stdout.clear_screen
  puts STRINGS["title"]
  wait_for_keypress 58
end

# coin flip methods ============================================================
def flip_coin()
  [true, false].sample
end

def display_coin_flip(result)
  coin_turns = MINIMUM_COIN_TURNS
  coin_side = true
  loop do
    $stdout.clear_screen

    puts STRINGS['coin_flip'].center(30)
    puts coin_side ? STRINGS['heads'] : STRINGS['tails']

    coin_turns -= 1
    break if coin_turns <= 0 && coin_side == result
    coin_side = !coin_side
    sleep(0.1)
  end
end

def display_coin_flip_winner(result)
  puts format(STRINGS['coin_flip_win'], result ? 'You' : 'Computer').center(30)
  wait_for_keypress 30
end

# board related methods ========================================================
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
    puts STRINGS['board_empty']
    puts STRINGS['board_separator'] unless row == 2
  end
end

# main program
display_title

game_state = {}
game_state[:user_turn] = flip_coin()
display_coin_flip(game_state[:user_turn])
display_coin_flip_winner(game_state[:user_turn])

$stdout.clear_screen
board = generate_empty_board
display_board(board)
