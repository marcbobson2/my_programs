module Display
  def display_msg(msg, pad_before: true, pad_after: true)
    puts if pad_before
    puts msg
    puts if pad_after
  end

  def clear
    system 'clear'
  end

  def press_key_to_continue
    display_msg("Press any key to continue.", \
                pad_before: true, pad_after: false)
    gets.chomp
  end
end

module Hand
  attr_accessor :cards
  def initialize
    remove_cards
  end

  def remove_cards
    @cards = []
  end

  def hand_total
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
    hand_total > 21
  end

  def to_s
    @cards.to_s
  end

  private

  def numeric?(val)
    val.is_a?(Fixnum)
  end

  def deal_with_aces(hand_total)
    return hand_total + 10 if hand_total <= 11
    hand_total
  end
end

class Participant
  include Display
  include Hand

  attr_accessor :name

  def initialize
    @name = ""
  end

  def hit(deck)
    @cards << deck.take_card
  end
end

class Player < Participant
  attr_accessor :games_won, :games_lost, :games_tied

  def initialize
    super
    @name = input_name
    @games_won = 0
    @games_lost = 0
    @games_tied = 0
    quick_welcome
  end

  def show_hand
    print name + ": "
    @cards.each do |card|
      print card[0].to_s + card[1].to_s + " "
    end
    puts format("%10d", hand_total)
  end

  def stand
    display_msg("Very well, you stand!", pad_before: true, pad_after: false)
    press_key_to_continue
  end

  def hit_or_stand
    display_msg("Do you want to hit or stand? (h or s)", \
                pad_before: true, pad_after: false)
    decision = nil
    loop do
      decision = gets.chomp.downcase
      break if decision == "h" || decision == "s"
      display_msg("you must enter either 'h' or 's'", \
                  pad_before: false, pad_after: false)
    end
    decision
  end

  private

  def input_name
    player_name = ""
    loop do
      puts "What's your name?"
      player_name = gets.chomp
      break if player_name.size > 1 && player_name !~ /\d/
      if player_name.size < 2
        puts "You must have more than 1 character in your name!"
      else
        puts "Your name cannot contain numbers!"
      end
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
  # rubocop:disable Metrics/AbcSize
  def show_hand(end_of_game = false)
    print "Dealer: "
    @cards.each do |card|
      if @cards.index(card).zero? && !end_of_game
        print "?? "
      else
        print card[0].to_s + card[1].to_s + " "
      end
    end
    puts format("%10d", hand_total) if end_of_game
    puts if !end_of_game
  end
  # rubocop:enable Metrics/AbcSize
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
      dealer_turn unless @player.busted?
      show_results
      update_scores
      if quit?
        display_msg("Thanks for playing, #{@player.name}!", \
                    pad_before: true, pad_after: false)
        break
      end
    end
  end

  private

  def player_turn
    loop do
      if @player.hit_or_stand == "h"
        clear
        @player.hit(@deck)
        show_hands
        break if @player.busted?
      else
        @player.stand
        break
      end
    end
  end

  def show_hands(show_all_cards: false)
    @player.show_hand
    @dealer.show_hand(show_all_cards)
  end

  def set_up
    @deck.create_deck
    @player.remove_cards
    @dealer.remove_cards
  end

  def quit?
    display_msg(QUIT_MSG, pad_before: true, pad_after: false)
    val = gets.chomp.to_s.upcase
    return false if val != "Q"
    true
  end

  def show_results
    if player_won?
      display_msg("You won!", pad_before: true, pad_after: false)
    elsif player_lost?
      display_msg("You lost!", pad_before: true, pad_after: false)
    else
      display_msg("It's a tie!", pad_before: true, pad_after: false)
    end
  end

  def update_scores
    if player_won?
      @player.games_won += 1
    elsif player_lost?
      @player.games_lost += 1
    else
      @player.games_tied += 1
    end
  end

  def player_lost?
    @player.busted? ||
      (@dealer.hand_total > @player.hand_total && !@dealer.busted?)
  end

  def player_won?
    @dealer.busted? ||
      (@player.hand_total > @dealer.hand_total && !@player.busted?)
  end

  def show_initial_cards
    clear
    show_score
    show_hands
  end

  def dealer_turn
    clear
    loop do
      break if @dealer.busted? || @dealer.hand_total > 16
      @dealer.hit(@deck)
    end
    show_hands(show_all_cards: true)
  end

  def show_score
    player_wins = "Wins: #{@player.games_won}"
    player_losses = "Losses: #{@player.games_lost}"
    player_ties = "Ties: #{@player.games_tied}"
    display_msg("Player Score-->  #{player_wins} #{player_losses}\
  #{player_ties}", pad_before: false, pad_after: true)
  end

  def hand_total(player_type)
    case player_type
    when :player then @player.hand_total
    when :dealer then @dealer.hand_total
    end
  end

  def deal_starting_cards
    2.times do
      @player.hit(@deck)
      @dealer.hit(@deck)
    end
  end
end

Game.new.start
