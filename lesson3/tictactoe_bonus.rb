# This file is just for implementing the bonus features assignment. If you want
# to look at what I started with, it is in /lesson3/tictactoe.rb

require 'yaml'
require 'io/console'

STRINGS = YAML.load_file "tictactoe.yaml"
MINIMUM_COIN_TURNS = 20
EMPTY = ' '
COMPUTER_MARK = 'O'
USER_MARK = 'X'
MAGIC_SQUARE = [2, 7, 6, 9, 5, 1, 4, 3, 8]
YES_NO = ['y', 'n']
TERMINAL_WIDTH = 80

def display_strings(strings)
  strings = [strings] if strings.instance_of?(String)

  puts(strings.map { |string| string.center(TERMINAL_WIDTH) })
end

def wait_for_keypress
  display_strings STRINGS['press_a_key']
  $stdin.getch
  nil
end

def display_title
  $stdout.clear_screen
  display_strings STRINGS['title']
  wait_for_keypress
end

def display_winner(board, player_mark)
  winner = player_mark == USER_MARK ? 'You' : 'Computer'

  $stdout.clear_screen
  display_board board
  display_strings format(STRINGS['game_win'], winner)

  wait_for_keypress
end

def display_draw(board)
  $stdout.clear_screen
  display_board board
  display_strings STRINGS['game_draw']

  wait_for_keypress
end

def get_specific_key(possible_keys)
  loop do
    key = $stdin.getch
    break key if possible_keys.include? key
    $stdout << "\a" # bell character
  end
end

# coin flip methods ============================================================
def flip_coin
  [true, false].sample
end

def animate_coin_flip(result)
  coin_turns = MINIMUM_COIN_TURNS

  loop do
    $stdout.clear_screen

    display_strings STRINGS['coin_flip']
    display_strings coin_turns.even? ? STRINGS['heads'] : STRINGS['tails']

    break if coin_turns <= 0 && coin_turns.even? == result
    coin_turns -= 1
    sleep(0.1)
  end
end

def display_coin_flip_winner(result)
  display_strings format(STRINGS['coin_flip_win'], result ? 'You' : 'Computer')
  wait_for_keypress
end

# board related methods ========================================================
def initialize_board
  Hash.new(EMPTY)
end

def display_board(board)
  3.times do |row|
    nums = (1..3).map { |num| row * 3 + num }
    display_strings format(STRINGS['board_numbered'], *nums)
    display_strings format(STRINGS['board_markers'],
                           *(nums.map { |num| board[num] }))
    display_strings STRINGS['board_empty']
    display_strings STRINGS['board_separator'] unless row == 2
  end

  nil
end

def get_empty_marks(board)
  (1..9).select { |spot| board[spot] == EMPTY }
end

def display_choices(choices)
  choice_str = if choices.size > 1
                 "#{choices[0...-1].join(', ')}, or #{choices[-1]}"
               else
                 choices.first
               end
  display_strings "(#{choice_str})"
end

def make_user_mark(board)
  display_strings STRINGS['choose_a_square']
  empty = get_empty_marks board
  display_choices empty

  key = get_specific_key(empty.map(&:to_s)).to_i

  board[key] = USER_MARK
  nil
end

def make_computer_mark(board)
  empty = get_empty_marks board
  board[empty.sample] = COMPUTER_MARK
end

def get_player_marks(board, player_mark)
  board.select { |_, mark| mark == player_mark }.keys
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
  game_state[:user_turn] = flip_coin
  animate_coin_flip(game_state[:user_turn])
  display_coin_flip_winner(game_state[:user_turn])

  game_state[:board] = initialize_board

  loop do
    $stdout.clear_screen
    display_board game_state[:board]

    if game_state[:user_turn]
      make_user_mark game_state[:board]
    else
      make_computer_mark game_state[:board]
    end

    player_mark = game_state[:user_turn] ? USER_MARK : COMPUTER_MARK
    if winner?(game_state[:board], player_mark)
      display_winner(game_state[:board], player_mark)
      break
    end

    if draw? game_state[:board]
      display_draw game_state[:board]
      break
    end

    game_state[:user_turn] = !game_state[:user_turn]
  end
  display_strings STRINGS['again']
  display_choices(YES_NO)
  break if get_specific_key(YES_NO) == 'n'
end

$stdout.clear_screen
display_strings STRINGS['goodbye']
