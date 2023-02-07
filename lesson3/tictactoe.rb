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
MAGIC_SQUARE = [2, 7, 6, 9, 5, 1, 4, 3, 8]
YES_NO = ['y', 'n']


def wait_for_keypress(center)
  puts("\n" + STRINGS["press_a_key"].center(center))
  $stdin.getch
  nil
end

def display_title
  $stdout.clear_screen
  puts STRINGS["title"]
  wait_for_keypress 58
end

def display_winner(board, player_mark)
  winner = player_mark == USER ? "You" : "Computer"

  $stdout.clear_screen
  display_board board
  puts "\n" + format(STRINGS['game_win'], winner)

  wait_for_keypress 0
end

def display_draw(board)
  $stdout.clear_screen
  display_board board
  puts "\n" + STRINGS['game_draw']

  wait_for_keypress 0
end

def get_specific_key(possible_keys)
  loop do
    key = $stdin.getch
    break key if possible_keys.include? key
    $stdout << "\a" # bell character
  end
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

  nil
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

  key = get_specific_key(empty.map(&:to_s)).to_i

  board[key] = USER
  nil
end

def computer_play_mark(board)
  empty = get_empty_marks board
  board[empty.sample] = COMPUTER
end

def get_player_marks(board, player_mark)
  board.select { |spot, mark| mark == player_mark }.keys
end

def convert_marks_to_magic_square(marks)
  marks.map { |mark| MAGIC_SQUARE[mark - 1] }
end

def convert_magic_square_to_square(magic_square)
  MAGIC_SQUARE.index(magic_square) + 1
end

def get_all_combos(arr1, arr2, arr3)
  new_arr = []

  arr1.product(arr2, arr3) { |combo| new_arr << combo if combo.uniq.size == 3 }

  new_arr
end

def winner?(board, player_mark)
  marks = get_player_marks(board, player_mark)
  marks = convert_marks_to_magic_square marks

  combos = get_all_combos(marks, marks, marks)

  combos.select! { |combo| combo.sum == 15 }
  combos.size > 0
end

def draw?(board)
  board.size == 9
end

# main program =================================================================
display_title
loop do
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

    player_mark = game_state[:user_turn] ? USER : COMPUTER
    if winner?(game_state[:board], player_mark)
      display_winner(game_state[:board], player_mark)
      break
    end

    if draw?(game_state[:board])
      display_draw(game_state[:board])
      break
    end

    game_state[:user_turn] = !game_state[:user_turn]
  end
  print STRINGS['again']
  display_choices(YES_NO)
  break if get_specific_key(YES_NO) == 'n'
end

$stdout.clear_screen
puts STRINGS['goodbye']
