require 'io/console'

FACE_VALUES = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
SUITS = %w(♠ ♣ ♥ ♦)
MAX_TOTAL = 21
AI_LIMIT = 17
ROUND_RESULTS = {
  draw: "It is a draw.", player: "You win the round!",
  dealer: "Dealer wins the round!", player_bust: "You busted! Dealer wins!",
  dealer_bust: "Dealer busted! You win!"
}
STATE_SYMBOLS = {
  player: {hand: :player_hand, total: :player_total, score: :player_score },
  dealer: {hand: :dealer_hand, total: :dealer_total, score: :dealer_score }
}

def prepare_round!(game_state)
  game_state[:deck] = FACE_VALUES.product(SUITS)

  game_state[:player_hand] = []
  game_state[:player_total] = 0

  game_state[:dealer_hand] = []
  game_state[:dealer_total] = 0
end

def initialize_game_state
  { player_score: 0, dealer_score: 0 }
end

def update_total!(game_state, player, card)
  total_symbol = STATE_SYMBOLS[player][:total]
  hand_symbol = STATE_SYMBOLS[player][:hand]

  game_state[total_symbol] += get_card_value(card)

  if game_state[total_symbol] > MAX_TOTAL
    game_state[total_symbol] = evaluate_hand(game_state[hand_symbol])
  end

  nil
end

def deal_card!(game_state, player, count = 1)
  count.times do
    card = game_state[:deck].delete(game_state[:deck].sample)
    game_state[STATE_SYMBOLS[player][:hand]] << card
    update_total!(game_state, player, card)
  end

  nil
end

def display_game_state(game_state, hide_dealer: true, hide_player: false)
  hidden = hide_dealer ? 1 : 0
  $stdout.clear_screen

  puts("Dealer has: #{get_hand_string(game_state[:dealer_hand], hidden)}")
  puts("You have: #{get_hand_string(game_state[:player_hand])}")
  puts(nil)
  puts("You have a total of #{game_state[:player_total]}") if !hide_player
  puts("The dealer has a total of #{game_state[:dealer_total]}") if !hide_dealer
end

def get_hand_string(hand, hidden = 0)
  cards = []

  hand[hidden..-1].each do |card|
    cards << card.join
  end
  cards << "#{hidden} unknown card" unless hidden.zero?

  separator = cards.size < 3 ? ', ' : ' '
  cards[-1] = "and #{cards[-1]}"

  cards.join(separator)
end

def bust?(game_state, player)
  game_state[STATE_SYMBOLS[player][:total]] > MAX_TOTAL
end

def get_card_value(card)
  case card[0]
  when 'J', 'Q', 'K' then 10
  when 'A' then 11
  else card[0].to_i
  end
end

def evaluate_hand(hand)
  card_groups = hand.partition { |card| card[0] != 'A' }
  ace_count = card_groups[1].size

  card_groups[0].map! { |card| get_card_value(card) }
  sum = card_groups[0].sum

  return sum if ace_count == 0
  sum += 10 + ace_count
  sum -= 10 if sum > MAX_TOTAL
  sum
end

def calculate_winner(game_state)
  player = game_state[:player_total]
  dealer = game_state[:dealer_total]
  return :player_bust if bust?(game_state, :player)
  return :dealer_bust if bust?(game_state, :dealer)
  return :draw if player == dealer
  return :player if player > dealer
  :dealer
end

def display_round_winner(game_state, winner)
  display_game_state(game_state, hide_dealer: false)
  puts ROUND_RESULTS[winner]
  sleep(2)
end

def play_again?
  puts nil
  puts "Do you want to play again? (yes or no)"
  loop do
    print "=> "
    answer = gets.chomp.downcase
    yes = "yes".start_with?(answer)
    return yes if yes || "no".start_with?(answer)
    puts "Invalid, please input yes or no"
  end
end

def dealer_turn!(game_state)
  loop do
    display_game_state(game_state, hide_player: true)
    break if game_state[:dealer_total] >= AI_LIMIT

    puts "Dealer hits!"
    deal_card!(game_state, :dealer)

    sleep(1)
  end
  unless bust?(game_state, :dealer)
    puts "Dealer stayed."
    sleep 2
  end
end

def player_turn!(game_state)
  is_hit = true

  loop do
    display_game_state(game_state)

    puts "Please input either hit or stay." if !is_hit

    puts("Hit or Stay?")
    print("=> ")

    answer = gets.chomp.downcase

    is_hit = 'hit'.start_with?(answer)

    deal_card!(game_state, :player) if is_hit

    break if 'stay'.start_with?(answer) || bust?(game_state, :player)
  end
end

def play_round!(game_state)
  prepare_round!(game_state)

  deal_card!(game_state, :player, 2)
  deal_card!(game_state, :dealer, 2)

  player_turn!(game_state)

  dealer_turn!(game_state) unless bust?(game_state, :player)

  display_round_winner(game_state, calculate_winner(game_state))
end

puts "Welcome to Twenty-One!"
sleep(2)

loop do
  game_state = initialize_game_state

  play_round!(game_state)

  break unless play_again?
end

puts "Thank you for playing!"
