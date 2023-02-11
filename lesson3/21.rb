require 'io/console'

# 1. Initialize deck
FACE_VALUES = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
SUITS = %w(♠ ♣ ♥ ♦)

def initialize_deck
  FACE_VALUES.product(SUITS)
end

# 2. Deal cards to player and dealer

def deal_card!(deck, hand, count = 1)
  count.times { hand << deck.delete(deck.sample) }
end

# 3. Player turn
#   - Display Game State
def display_game_state(hands, hide_dealer: true)
  hidden = hide_dealer ? 1 : 0
  $stdout.clear_screen

  puts("Dealer has: #{get_hand_string(hands[:dealer_hand], hidden)}")
  puts("You have: #{get_hand_string(hands[:player_hand])}")
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

#   - Ask player to 'hit' or 'stay'
#      - if 'hit', deal a card.
#   - Check for bust
def bust?(hand)
  evaluate_hand(hand) > 21
end

def get_card_value(card)
  case card[0]
  when 'J', 'Q', 'K' then 10
  when 'A' then 11 # This should never happen, since I split out aces
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
  sum -= 10 if sum > 21
  sum
end
#   - repeat until bust or "stay"

# 4. If player bust, dealer wins.
# 5. Dealer turn: hit or stay
#   - repeat until total >= 17
# 6. If dealer bust, player wins.
# 7. Compare cards and declare winner.
def calculate_winner(hands)
  player = evaluate_hand(hands[:player_hand])
  dealer = evaluate_hand(hands[:dealer_hand])
  return :draw if player == dealer
  return :player if player > dealer
  :dealer
end

def display_winner(winner)
  case winner
  when :draw then puts "It is a draw."
  when :player then puts "You win!"
  when :dealer then puts "Dealer wins!"
  end
end

def play_again?
  puts nil
  puts "Do you want to play again? (yes or no)"
  loop do
    print "=> "
    answer = gets.chomp.downcase
    yes = "yes".start_with?(answer)
    return yes if yes || "no".start_with?(answer)
    puts "Invalid, input yes or no"
  end
end

puts "Welcome to Twenty-One!"
sleep(2)

loop do
# 1. Initialize deck
  deck = initialize_deck

# 2. Deal cards to player and dealer
  hands = {player_hand: [], dealer_hand: []}
  deal_card!(deck, hands[:player_hand], 2)
  deal_card!(deck, hands[:dealer_hand], 2)

# 3. Player turn
  loop do
#   - Display Game State
    display_game_state(hands)

#   - Ask player to 'hit' or 'stay'
    puts("hit or stay?")
    print("=> ")

    answer = gets.chomp.downcase

#      - if 'hit', deal a card.
    if 'hit'.start_with?(answer)
      deal_card!(deck, hands[:player_hand])
      puts "You hit!"
    end

#   - Check for bust
#   - repeat until bust or "stay"
    break if 'stay'.start_with?(answer) or bust?(hands[:player_hand])
  end

  display_game_state(hands)

# 4. If player bust, dealer wins.
  if bust?(hands[:player_hand])
    puts "You busted. Dealer wins!"
    next if play_again?
    break
  end

  puts "You stay."

  # 5. Dealer turn: hit or stay
#   - repeat until total >= 17
  loop do
    display_game_state(hands)
    hand_value = evaluate_hand(hands[:dealer_hand])
    break if hand_value >= 17

    puts "Dealer hits!"
    deal_card!(deck, hands[:dealer_hand])

    sleep(2)
  end

  display_game_state(hands, hide_dealer: false)

# 6. If dealer bust, player wins.
  if bust?(hands[:dealer_hand])
    puts "Dealer busts! You win!"
    next if play_again?
    break
  else
    puts "Dealer stayed."
    sleep(2)
  end

  display_game_state(hands, hide_dealer:false)
# 7. Compare cards and declare winner.
  display_winner(calculate_winner(hands))
  # Ask user to play again?
  break unless play_again?
end

puts "Thank you for playing!"
