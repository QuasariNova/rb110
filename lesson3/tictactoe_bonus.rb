# This file is just for implementing the bonus features assignment. If you want
# to look at what I started with, it is in /lesson3/tictactoe.rb

# Bonus Feature 1: joinor implementation on 351 line
# Bonus Feature 2: Scoring
#   - Added Menu, so we could change how many games a match we play
#   - Added initialize_score on line 299, that adds/resets :score in game_state
#   - Changed display_game_state on line 108 to display score
#   - Reset Score in play_match on line 56
#   - match_won? checks score to see if match is won on line 183
# Bonus Feature 3: Computer AI Defense
#   - Added get_ai_defensive_move on 241, which finds out if an opponent
#   - Added check in make_computer_mark on line 220 to check defense first

require 'yaml'
require 'io/console'

STRINGS = YAML.load_file "tictactoe_bonus.yaml"
TITLE_WIDTH = STRINGS['title'][0].size
TERMINAL_WIDTH = 80
MENU_KEYS = ['p', 'm', 'q']
MATCH_LENGTHS = [1, 3, 5, 7, 9]
MINIMUM_COIN_TURNS = 20
EMPTY = ' '
COMPUTER_MARK = 'O'
USER_MARK = 'X'
MAGIC_SQUARE = [2, 7, 6, 9, 5, 1, 4, 3, 8]
YES_NO = ['y', 'n']
ANIMATION_TIME = 0.1

# Invoked on line 310
def program_loop
  game_state = { match_len: 1 }

  loop do # program loop
    break if loop do # menu loop
      display_menu game_state
      choice = get_filtered_keypress MENU_KEYS

      case choice
      when 'q' then break true
      when 'p' then break false
      when 'm' then change_match_len game_state
      end
    end

    play_match game_state
  end

  display_goodbye
end

def play_match(game_state)
  loop do
    choose_first_player game_state
    initialize_score game_state

    loop do
      initialize_board game_state

      play_game(game_state)
      break if match_won? game_state
    end
    display_match_winner game_state

    display_strings STRINGS['again']
    display_choices(YES_NO)
    break if get_filtered_keypress(YES_NO) == 'n'
  end
end

def play_game(game_state)
  loop do
    display_game_state game_state

    make_turn_mark game_state

    if won?(game_state)
      game_state[:score][game_state[:user_turn]] += 1
      break display_game_winner(game_state)
    end

    break display_draw(game_state) if draw?(game_state)

    game_state[:user_turn] = !game_state[:user_turn]
  end
end

def display_draw(game_state)
  display_game_state game_state
  display_strings STRINGS['game_draw']

  wait_for_keypress
end

def display_game_winner(game_state)
  winner = game_state[:user_turn] ? 'You' : 'Computer'

  display_game_state game_state
  display_strings format(STRINGS['game_win'], winner)

  wait_for_keypress unless match_won? game_state
end

def display_game_state(game_state)
  $stdout.clear_screen

  display_score(game_state[:score]) if game_state[:match_len] > 1

  display_board(game_state[:board])
end

def display_match_winner(game_state)
  winner = game_state[:user_turn] ? 'You' : 'Computer'

  display_strings format(STRINGS['match_win'], winner)

  wait_for_keypress
end

def display_menu(game_state)
  $stdout.clear_screen
  display_strings STRINGS['title']
  puts ''
  display_strings STRINGS['menu_play_game'].ljust(TITLE_WIDTH)
  display_strings get_match_len_str(game_state[:match_len]).ljust(TITLE_WIDTH)
  display_strings STRINGS['menu_quit'].ljust(TITLE_WIDTH)
end

def choose_first_player(game_state)
  game_state[:user_turn] = flip_coin
  display_coin_flip_animation(game_state[:user_turn])
  display_coin_flip_winner(game_state[:user_turn])
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

def display_choices(choices)
  choice_str = joinor(choices)
  display_strings "(#{choice_str})"
end

def display_coin_flip_animation(result)
  coin_turns = MINIMUM_COIN_TURNS

  loop do
    $stdout.clear_screen

    display_strings STRINGS['coin_flip']
    display_strings coin_turns.even? ? STRINGS['heads'] : STRINGS['tails']

    break if coin_turns <= 0 && coin_turns.even? == result
    coin_turns -= 1
    sleep(ANIMATION_TIME)
  end
end

def display_coin_flip_winner(result)
  display_strings format(STRINGS['coin_flip_win'], result ? 'You' : 'Computer')
  wait_for_keypress
end

def display_goodbye
  $stdout.clear_screen
  display_strings STRINGS['goodbye']
end

def display_score(score)
  display_strings format(STRINGS['score'], score[true], score[false])
end

def match_won?(game_state)
  target_wins = (game_state[:match_len] / 2.0).ceil
  game_state[:score][game_state[:user_turn]] >= target_wins
end

# I use a 3x3 Magic Square to tell if a user has won. Basically, a Magic Square
# has all it's rows, columns, and regular diagonals sum up to the same number.
# In the case of the 3x3 one, the sum is 15. Because of how it is set up, these
# are the only trios of values in the square that add up to that value, so if
# if any three squares when converted to their magic square value sum up to 15
# we know that there was a line made!
def won?(game_state)
  player_mark = game_state[:user_turn] ? USER_MARK : COMPUTER_MARK
  marks = get_player_marks(game_state[:board], player_mark)
  marks = convert_marks_to_magic_square marks

  combos = find_all_marking_combos(3, marks)

  combos.select! { |combo| combo_wins? combo }
  combos.size > 0
end

# Because I set the board hashes default to an empty space, we don't have to
# count empty squares as they don't technically have keys yet. So, we just
# gotta check if all the squares are filled.
def draw?(game_state)
  game_state[:board].size == 9
end

def make_turn_mark(game_state)
  if game_state[:user_turn]
    make_user_mark game_state[:board]
  else
    make_computer_mark game_state[:board]
  end
end

def make_computer_mark(board)
  empty = get_empty_marks board
  defensive = get_ai_defensive_move board
  if defensive
    board[defensive] = COMPUTER_MARK
  else
    board[empty.sample] = COMPUTER_MARK
  end
end

def make_user_mark(board)
  display_strings STRINGS['choose_a_square']
  empty = get_empty_marks board
  display_choices empty

  key = get_filtered_keypress(empty.map(&:to_s)).to_i

  board[key] = USER_MARK
  nil
end

def get_ai_defensive_move(board)
  empty = convert_marks_to_magic_square get_empty_marks(board)

  enemy_marks = convert_marks_to_magic_square get_player_marks(board, USER_MARK)

  # get all 2 mark comboes
  enemy_combos = find_all_marking_combos(2, enemy_marks)

  # product with empty marks
  possible_losses = empty.product(enemy_combos).map { |sub| sub.flatten }

  # Filter wins
  possible_losses.select! { |combo| combo_wins? combo }

  if possible_losses.size > 0
    convert_magic_square_to_square possible_losses.sample[0]
  else
    nil
  end
end

def change_match_len(game_state)
  next_index = MATCH_LENGTHS.index(game_state[:match_len]) + 1
  next_index = 0 if next_index == MATCH_LENGTHS.size
  game_state[:match_len] = MATCH_LENGTHS[next_index]

  nil
end

def get_filtered_keypress(possible_keys)
  loop do
    key = $stdin.getch
    break key if possible_keys.include? key
    $stdout << "\a" # bell character
  end
end

def wait_for_keypress
  display_strings STRINGS['press_a_key']
  $stdin.getch
  nil
end

def get_match_len_str(length)
  best_of = format(STRINGS['best_of'], length)
  format(STRINGS['menu_match_len'], best_of)
end

def display_strings(strings)
  strings = [strings] if strings.instance_of?(String)

  puts(strings.map { |string| string.center(TERMINAL_WIDTH) })
end

def initialize_board(game_state)
  game_state[:board] = Hash.new(EMPTY)
end

def initialize_score(game_state)
  game_state[:score] = { true => 0, false => 0 }
end

def flip_coin
  [true, false].sample
end

def get_empty_marks(board)
  (1..9).select { |spot| board[spot] == EMPTY }
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

def combo_wins?(combo)
  combo.sum == 15
end

# find_all_marking_combos does what it says. When you pass in an array of marks
# and how many marks_in_line it takes to make a line, it returns every
# combination of marks_in_line marks as a nested_array. I did work on this
# algorithm in /lesson3/ttt/find_all_marking_combos.rb. My original way was
# couldn't scale and wasn't as usable for the AI functions.
def find_all_marking_combos(marks_in_line, marks)
  return [] if marks.size < marks_in_line
  return marks if marks_in_line == 1

  position = 0
  out = []

  until position > marks.size - marks_in_line
    first = [marks[position]]
    rest = find_all_marking_combos(marks_in_line - 1, marks[(position + 1)..-1])
    out += first.product(rest).map { |sub| sub.flatten }

    position += 1
  end

  out
end

# Bonus Feature 1: I PEDACed it in /lesson3/ttt/bonus1.rb
def joinor(arr, sep=', ', word='or')
  return '' if arr.size < 1
  return arr.first.to_s if arr.size == 1
  return "#{arr.first} #{word} #{arr.last}" if arr.size == 2
  "#{arr[0...-1].join(sep)}#{sep}#{word} #{arr.last}"
end

# main program =================================================================
program_loop
