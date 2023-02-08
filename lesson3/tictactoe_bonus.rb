# This file is just for implementing the bonus features assignment. If you want
# to look at what I started with, it is in /lesson3/tictactoe.rb

# Bonus Feature 1: joinor implementation
# Bonus Feature 2: Scoring
#   - Added Menu, so we could change how many games a match we play
#   - Added initialize_score that adds/resets :score in game_state
#   - Changed display_game_state to display score
#   - Reset Score in play_match
#   - match_won? checks score to see if match is won
# Bonus Feature 3: Computer AI Defense
#   - Added get_ai_defensive_move which finds out if an opponent wins
#   - Added check in make_computer_mark to check defense first
# Bonus Feature 4: Computer AI Offense
#   - Changed get_ai_defensive_move to find_possible_win
#     - This is more useful and given a board and a mark, will find a possible
#       winning spot
#     - Changed so I could use it to detect offensive moves as well as
#       defensive moves
# Bonus Feature 5: Computer Turn Refinements
#   a. Reverse offense and defense steps.
#     - I went ahead and added a difficulty level to the menu and readded just
#       random moves as 'RANDOM' and the one that choses moves based on state as
#       'NORMAL'
#     - make_computer_move now checks difficulty and runs random_ai_mark or
#       normal_ai mark based on difficulty setting
#     - I changed the normal_ai_mark method to do offense prior to defense
#   b. Make AI chose 5 if available
#     - I changed the normal_ai_mark method to do this
#   c. Change the game so that the computer can move first. Ask user who should
#      play first.
#     - Already had it implemented either player could start, though it was just
#       through a coin flip. Adding menu option
#   d. Can you add another "who goes first" option that lets the computer
#      choose who goes first?
#     - when I added the menu option in c, this was already done as coin flip
#       was my default option
# Bonus Feature 6: Remove superfluous code from game loop.
#   - I used a different loop, but I already have an implementation to use a
#     method for both players. The two breaks I have for breaking if draw or win
#     make sense to me, so I'm not going to go out of my way to turn that into
#     one break.
# Extra Features:
# 1. Minimax: maybe
# 2. Bigger Boards
#   - I would have to define Magic Squares for each size and their sums
#   - I would also have to define keys for indexes
#     - With my current Input system, I could go up to 6x6 comfortably
#       (26 alpha, 10 numeric)
#   - I would have to draw it...
#   - Everything else is ready to scale as long as those three things are fixed
# 3. More players
#   - I'm not interested in that right now, but adding more marks would do it
#   - would have to have a round robin instead of flipping
#   - Would probably change mark constants to an array of marks, so that player
#     index = mark
#   - could feasibly change what I got now to do it, but again not interested

require 'yaml'
require 'io/console'

STRINGS = YAML.load_file "tictactoe_bonus.yaml"
TITLE_WIDTH = STRINGS['title'][0].size
TERMINAL_WIDTH = 80
MENU_KEYS = ['p', 'm', 'f', 'd', 'q']
MATCH_LENGTHS = [1, 3, 5, 7, 9]
MINIMUM_COIN_TURNS = 20
EMPTY = ' '
COMPUTER_MARK = 'O'
USER_MARK = 'X'
MAGIC_SQUARE = [2, 7, 6, 9, 5, 1, 4, 3, 8]
MAGIC_SUM = 15
YES_NO = ['y', 'n']
ANIMATION_TIME = 0.1
BOARD_SIZE = 3

# Invoked on line 464
def program_loop
  game_state = { match_len: 1, difficulty: 1, user_first: true, random: true }

  loop do # program loop
    break if loop do # menu loop
      display_menu game_state
      choice = get_filtered_keypress MENU_KEYS

      menu_do(game_state, choice)

      break true if game_state[:menu_action] == :quit_action
      break false unless game_state[:menu_action] == :option_action
    end

    play_match game_state
  end

  display_goodbye
end

def menu_do(game_state, choice)
  case choice
  when 'q' then
    game_state[:menu_action] = :quit_action
    return
  when 'p' then
    game_state[:menu_action] = :play_action
    return
  when 'd' then change_difficulty game_state
  when 'f' then change_first_player game_state
  when 'm' then change_match_len game_state
  end
  game_state[:menu_action] = :option_action
  nil
end

def play_match(game_state)
  loop do
    choose_first_player game_state
    initialize_score game_state

    loop do
      initialize_board game_state

      play_game(game_state)
      break if match_won? game_state

      flip_turn_player game_state
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

    flip_turn_player game_state
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
  puts nil
  display_strings generate_menu_strings(game_state)
end

def choose_first_player(game_state)
  if game_state[:random]
    game_state[:user_turn] = flip_coin
    display_coin_flip_animation(game_state[:user_turn])
    display_coin_flip_winner(game_state[:user_turn])
  else
    game_state[:user_turn] = game_state[:user_first]
  end

  nil
end

def display_board(board)
  BOARD_SIZE.times do |row|
    nums = (1..BOARD_SIZE).map { |num| row * BOARD_SIZE + num }
    display_strings format(STRINGS['board_numbered'], *nums)
    display_strings format(STRINGS['board_markers'],
                           *(nums.map { |num| board[num] }))
    display_strings STRINGS['board_empty']
    display_strings STRINGS['board_separator'] unless row == BOARD_SIZE - 1
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

  combos = find_all_marking_combos(BOARD_SIZE, marks)

  combos.select! { |combo| combo_wins? combo }
  combos.size > 0
end

# Because I set the board hashes default to an empty space, we don't have to
# count empty squares as they don't technically have keys yet. So, we just
# gotta check if all the squares are filled.
def draw?(game_state)
  game_state[:board].size == BOARD_SIZE**2
end

def make_turn_mark(game_state)
  if game_state[:user_turn]
    make_user_mark game_state[:board]
  else
    make_computer_mark game_state
  end
end

def make_computer_mark(game_state)
  mark = case game_state[:difficulty]
         when 0 then random_ai_mark game_state[:board]
         when 1 then normal_ai_mark game_state[:board]
         end
  game_state[:board][mark] = COMPUTER_MARK
end

def normal_ai_mark(board)
  offensive = find_possible_win(board, COMPUTER_MARK)
  defensive = find_possible_win(board, USER_MARK)

  return offensive if offensive
  return defensive if defensive

  empty = get_empty_marks board
  middle = (BOARD_SIZE**2 / 2.0).ceil
  return middle if empty.include?(middle) && BOARD_SIZE.odd?
  empty.sample
end

def random_ai_mark(board)
  empty = get_empty_marks board
  empty.sample
end

def make_user_mark(board)
  display_strings STRINGS['choose_a_square']
  empty = get_empty_marks board
  display_choices empty

  key = get_filtered_keypress(empty.map(&:to_s)).to_i

  board[key] = USER_MARK
  nil
end

def find_possible_win(board, mark)
  empty = convert_marks_to_magic_square get_empty_marks(board)

  marks = convert_marks_to_magic_square get_player_marks(board, mark)

  # get all 2 mark comboes
  combos = find_all_marking_combos(BOARD_SIZE - 1, marks)

  # product with empty marks, so that empty marks are the first in the sub array
  possible_wins = empty.product(combos).map(&:flatten)

  # Filter wins
  possible_wins.select! { |combo| combo_wins? combo }

  if possible_wins.size > 0
    convert_magic_square_to_square possible_wins.sample[0]
  end
end

def change_match_len(game_state)
  next_index = MATCH_LENGTHS.index(game_state[:match_len]) + 1
  next_index = 0 if next_index == MATCH_LENGTHS.size
  game_state[:match_len] = MATCH_LENGTHS[next_index]

  nil
end

def change_difficulty(game_state)
  next_index = game_state[:difficulty] + 1
  next_index = 0 if next_index >= STRINGS['ai_difficulties'].size
  game_state[:difficulty] = next_index

  nil
end

def change_first_player(game_state)
  if game_state[:random]
    game_state[:random] = false
    game_state[:user_first] = true
  elsif game_state[:user_first]
    game_state[:user_first] = false
  else
    game_state[:random] = true
  end

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

def generate_menu_strings(game_state)
  menu_strings = []
  menu_strings << STRINGS['menu_play_game'].ljust(TITLE_WIDTH)
  menu_strings << get_match_len_str(game_state[:match_len]).ljust(TITLE_WIDTH)
  menu_strings << get_difficulty_str(game_state[:difficulty]).ljust(TITLE_WIDTH)
  menu_strings << get_first_player_str(game_state).ljust(TITLE_WIDTH)
  menu_strings << STRINGS['menu_quit'].ljust(TITLE_WIDTH)
end

def get_match_len_str(length)
  best_of = format(STRINGS['best_of'], length)
  format(STRINGS['menu_match_len'], best_of)
end

def get_difficulty_str(index)
  format(STRINGS['menu_difficulty'], STRINGS['ai_difficulties'][index])
end

def get_first_player_str(game_state)
  player = if game_state[:random]
             'Coin Flip'
           elsif game_state[:user_first]
             'You'
           else
             'Computer'
           end
  format(STRINGS['menu_first'], player)
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
  (1..BOARD_SIZE**2).select { |spot| board[spot] == EMPTY }
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
  combo.sum == MAGIC_SUM
end

def flip_turn_player(game_state)
  game_state[:user_turn] = !game_state[:user_turn]

  nil
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
    out += first.product(rest).map(&:flatten)

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
