class Participant
  attr_accessor :hand
  
  def initialize
   @hand = []
  end
  # what goes in here? all the redundant behaviors from Player and Dealer?
end

class Player < Participant

  def initialize
    super
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # definitely looks like we need to know about "cards" to produce some total
  end
end

class Dealer < Participant
  def initialize
    super
  end

  def deal
    # does the dealer or the deck deal?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Deck
  VALUES = ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"].freeze
  SUITS = ["hearts", "spades", "diamonds", "clubs"].freeze
  
  attr_reader :cards
  
  
  def initialize
   create_deck
  end
  
  def create_deck
    @cards = VALUES.product(SUITS)
    @cards.shuffle!
  end
  
  def get_card
    @cards.pop
  end

  def deal
    # does the dealer or the deck deal?
  end
  
  def to_s
    @cards
  end
end

class Card
  def initialize
    # what are the "states" of a card?
  end
end

class Game
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end
  
  def start
    shuffle_deck
    deal_cards
    #show_initial_cards
    #player_turn
    #dealer_turn
    #show_result
  end

  def deal_cards
    @player.hand << @deck.get_card
    puts "player hand = #{@player.hand}"
    puts "new deck: #{@deck}"

  end
  
  def shuffle_deck
    puts @deck
  end
  
end

Game.new.start