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

def get_empty_marks(board)
  (1..9).select { |spot| board[spot] == EMPTY }
end

def display_choices(choices)
  choice_str = if choices.size > 1
                 choices[0...-1].join(', ') + ', ' + choices[-1].to_s
               else
                 choices.first
               end
  puts "(#{choice_str})"
end

def get_user_mark(board)
  print STRINGS['choose_a_square']
  empty = get_empty_marks board
  display_choices empty

  key = loop do
    key_press = $stdin.getch.to_i
    break key_press if empty.include? key_press
    $stdout << "\a" # bell character
  end

  board[key] = USER
  nil
end

def computer_play_mark(board)
  empty = get_empty_marks board
  board[empty.sample] = COMPUTER
end

# main program
display_title

game_state = {}
game_state[:user_turn] = flip_coin()
display_coin_flip(game_state[:user_turn])
display_coin_flip_winner(game_state[:user_turn])

game_state[:board] = generate_empty_board

loop do
  $stdout.clear_screen

  display_board game_state[:board]
  if game_state[:user_turn]
    get_user_mark game_state[:board]
  else
    computer_play_mark game_state[:board]
  end

  game_state[:user_turn] = !game_state[:user_turn]
end
