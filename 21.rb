module Display
  def display_msg(msg, pad_before = true, pad_after = true)
    puts if pad_before
    puts msg
    puts if pad_after
  end

  def clear
    system 'clear'
  end

  def press_key_to_continue
    display_msg("Press any key to continue.", true, false)
    gets.chomp
  end
end

class Hand
  attr_accessor :cards
  def initialize
    remove_cards
  end

  def remove_cards
    @cards = []
  end

  def value
    hand_total = 0
    has_aces = false
    @cards.each do |card|
      if numeric?(card[0])
        hand_total += card[0]
      elsif ["J", "Q", "K"].include?(card[0])
        hand_total += 10
      else
        hand_total += 1
        has_aces = true
      end
    end
    hand_total = deal_with_aces(hand_total) if has_aces
    hand_total
  end

  def busted?
    value > 21
  end

  def to_s
    @cards.to_s
  end

  private

  def numeric?(val)
    val.class == ::Fixnum
  end

  def deal_with_aces(hand_total)
    return hand_total + 10 if hand_total <= 11
    hand_total
  end
end

class Participant
  include Display
  attr_accessor :hand, :name

  def initialize
    @hand = Hand.new
    @name = ""
  end
end

class Player < Participant
  attr_accessor :games_won, :games_lost, :games_tied

  def initialize
    super
    @name = set_name
    @games_won = 0
    @games_lost = 0
    @games_tied = 0
    quick_welcome
  end

  def turn(deck, dealer)
    loop do
      if hit_or_stand? == "h"
        clear
        hit(deck)
        show_hand
        dealer.show_hand
        if hand.busted?
          break
        end
      else
        stand
        break
      end
    end
  end

  def show_hand
    print name + ": "
    hand.cards.each do |card|
      print card[0].to_s + card[1].to_s + " "
    end
    puts format("%10d", hand.value)
  end

  def hit(deck)
    hand.cards << deck.take_card
  end

  private

  def stand
    display_msg("Very well, you stand!", true, false)
    press_key_to_continue
  end

  def hit_or_stand?
    display_msg("Do you want to hit or stand? (h or s)", true, false)
    decision = nil
    loop do
      decision = gets.chomp.downcase
      break if decision == "h" || decision == "s"
      display_msg("you must enter either 'h' or 's'", false, false)
    end
    decision
  end

  def set_name
    player_name = ""
    loop do
      puts "What's your name?"
      player_name = gets.chomp
      break if player_name.size > 1 && player_name =~ /[a-zA-Z]/
      puts "You must have more than 1 character in your name!" \
        if player_name.size < 2
      puts "Your name must contain at least 1 letter!" \
        if player_name =~ /[^a-zA-Z]/
    end
    puts
    player_name
  end

  def quick_welcome
    puts "Welcome, #{name}!. Press any key to begin."
    gets.chomp
  end
end

class Dealer < Participant
  def initialize
    super
  end

  def deal_starting_hands(player, deck)
    2.times do |_|
      player.hit(deck)
      hit(deck)
    end
  end

  def turn(deck, player)
    loop do
      break if hand.busted? || hand.value > 16
      hit(deck)
    end
    player.show_hand
    show_hand(true)
  end

  # rubocop:disable Metrics/AbcSize
  def show_hand(end_of_game = false)
    print "Dealer: "
    hand.cards.each do |card|
      if hand.cards.index(card).zero? && !end_of_game
        print "?? "
      else
        print card[0].to_s + card[1].to_s + " "
      end
    end
    puts format("%10d", hand.value) if end_of_game
    puts
  end
  # rubocop:enable Metrics/AbcSize

  private

  def hit(deck)
    hand.cards << deck.take_card
  end
end

class Deck
  VALUES = ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"].freeze
  SUITS = ["\u2665", "\u2660", "\u2666", "\u2663"].freeze

  attr_reader :cards

  def create_deck
    @cards = VALUES.product(SUITS)
    @cards.shuffle!
  end

  def take_card
    @cards.pop
  end

  def to_s
    @cards.to_s
  end
end

class Game
  include Display

  QUIT_MSG = "Press Q to quit, or any other key to play another hand.".freeze

  def initialize
    clear
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def start
    loop do
      set_up
      deal_starting_cards
      show_initial_cards
      player_turn
      dealer_turn if !@player.hand.busted?
      show_results
      break if quit?
    end
  end

  private

  def set_up
    @deck.create_deck
    @player.hand.remove_cards
    @dealer.hand.remove_cards
  end

  def quit?
    display_msg(QUIT_MSG, true, false)
    val = gets.chomp.to_s.upcase
    return false if val != "Q"
    display_msg("Thanks for playing, #{@player.name}!", true, false)
    true
  end

  def show_results
    if player_won?
      @player.games_won += 1
      display_msg("You won!", false, false)
    elsif player_lost?
      @player.games_lost += 1
      display_msg("You lost!", false, false)
    else
      @player.games_tied += 1
      display_msg("It's a tie!", false, false)
    end
  end

  def player_lost?
    @player.hand.busted? ||
      (@dealer.hand.value > @player.hand.value && !@dealer.hand.busted?)
  end

  def player_won?
    @dealer.hand.busted? ||
      (@player.hand.value > @dealer.hand.value && !@player.hand.busted?)
  end

  def show_initial_cards
    clear
    show_score
    @player.show_hand
    @dealer.show_hand(false)
  end

  def player_turn
    @player.turn(@deck, @dealer)
  end

  def dealer_turn
    clear
    @dealer.turn(@deck, @player)
  end

  def show_score
    player_wins = "Wins: #{@player.games_won}"
    player_losses = "Losses: #{@player.games_lost}"
    player_ties = "Ties: #{@player.games_tied}"
    display_msg("Player Score-->  #{player_wins} #{player_losses}\
  #{player_ties}", false, true)
  end

  def hand_total(player_type)
    case player_type
    when :player then @player.hand.value
    when :dealer then @dealer.hand.value
    end
  end

  def deal_starting_cards
    @dealer.deal_starting_hands(@player, @deck)
  end
end

Game.new.start
