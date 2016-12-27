require 'pry'

module AIMoveLogic
  WIN_LINES_PER_SQUARE = { 1 => [[2, 3], [4, 7], [5, 9]],
                           2 => [[1, 3], [5, 8]],
                           3 => [[1, 2], [5, 7], [6, 9]],
                           4 => [[1, 7], [5, 6]],
                           5 => [[1, 9], [2, 8], [4, 6], [7, 3]],
                           6 => [[3, 9], [4, 5]],
                           7 => [[1, 4], [3, 5], [8, 9]],
                           8 => [[2, 5], [7, 9]],
                           9 => [[1, 5], [3, 6], [7, 8]] }.freeze

  CENTER_SQUARE = 5
  CORNER_SQUARES = [1, 3, 7, 9].freeze

  def find_best_move(computer_marker, human_marker)
    [computer_marker, human_marker].each do |marker|
      key = must_do_move?(marker)
      return key if key
    end

    [computer_marker, human_marker].each do |marker|
      key = attack_or_defend?(marker)
      return key if key
    end

    return CENTER_SQUARE if @squares[CENTER_SQUARE].marker \
      == Square::INITIAL_MARKER
    unmarked_keys.sample
  end

  private

  def must_do_move?(marker)
    unmarked_keys.each do |key|
      WIN_LINES_PER_SQUARE[key].each do |win_line|
        return key if winning_move?(win_line, marker)
      end
    end
    false
  end

  def winning_move?(win_line, marker)
    @squares[win_line[0]].marker == marker && \
      @squares[win_line[1]].marker == marker
  end

  def attack_or_defend?(marker)
    [2, 1].each do |lines_to_eval|
      possible_moves = []
      unmarked_keys.each do |key|
        possible_moves << key \
          if line_win?(WIN_LINES_PER_SQUARE[key], marker, lines_to_eval)
      end
      return choose_best_move(possible_moves) if !possible_moves.empty?
    end
    false
  end

  def choose_best_move(possible_moves)
    return CENTER_SQUARE if possible_moves.include?(CENTER_SQUARE)
    return (possible_moves & CORNER_SQUARES).sample \
      if !(possible_moves & CORNER_SQUARES).empty!
    possible_moves.sample
  end

  def line_win?(win_lines, marker, required_lines)
    valid_lines = 0
    win_lines.each do |win_line|
      valid_lines += 1 if one_occupied_square?(win_line, marker)
    end
    valid_lines >= required_lines
  end

  def one_occupied_square?(win_line, marker)
    markers_in_line = []
    markers_in_line << @squares[win_line[0]].marker \
      << @squares[win_line[1]].marker
    markers_in_line.count(marker) == 1 && \
      markers_in_line.count(Square::INITIAL_MARKER) == 1
  end
end

class Board
  include AIMoveLogic

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]].freeze

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " ".freeze

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :name

  def initialize(marker, name)
    @marker = marker
    @name = name
  end
end

class TTTGame
  DEFAULT_COMPUTER_MARKER = "O".freeze
  DEFAULT_HUMAN_MARKER = "X".freeze
  COMPUTER_NAME_OPTIONS = ["Tom", "Robert", "Sigfried", "Lionel", "Tito"].freeze
  MAX_GAMES = 2

  attr_accessor :board, :human, :computer, \
                :human_marker, :computer_marker, :human_name

  def initialize
    @board = Board.new
    display_welcome_message
    assign_human_marker
    @first_to_move = computer_marker
    @human = Player.new(human_marker, human_name)
    @computer = Player.new(computer_marker, COMPUTER_NAME_OPTIONS.sample)
    @current_marker = @first_to_move
    @games_won = { human: 0, computer: 0 }
  end

  def play
    clear

    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board
      end

      display_result
      ready_to_continue?
      break if game_limit_reached?
      # break unless play_again?
      reset
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def ready_to_continue?
    puts "Enter any key to continue"
    gets.chomp
  end

  def game_limit_reached?
    @games_won.value?(MAX_GAMES)
  end

  def assign_human_marker
    @human_marker = choose_desired_marker

    @computer_marker = if @human_marker == DEFAULT_COMPUTER_MARKER
                         DEFAULT_HUMAN_MARKER
                       else
                         DEFAULT_COMPUTER_MARKER
                       end
  end

  def choose_desired_marker
    marker = nil
    loop do
      puts "Enter any single-character marker you want:"
      marker = gets.chomp.to_s
      break if valid_marker?(marker)
      puts "Your marker must be a single character!"
    end
    marker
  end

  def valid_marker?(marker)
    marker.size == 1
  end

  def display_welcome_message
    puts "Welcome to tic tac toe"
    choose_human_name
  end

  def choose_human_name
    loop do
      puts "Please enter your name:"
      @human_name = gets.chomp.to_s
      break if !@human_name.empty?
      puts "You must enter at least 1 character!"
    end
  end

  def display_goodbye_message
    display_score
    puts "Goodbye #{human.name}. play again soon."
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_score
    puts "#{human.name}, you have won #{@games_won[:human]} games. \
      #{computer.name} has won #{@games_won[:computer]} games."
  end

  def display_board
    puts "#{human.name}, you are a #{human.marker} and \
      #{computer.name} is a #{computer.marker}"
    display_score
    puts ""
    board.draw
    puts ""
  end

  def joinor(arr, separator = ",", concat_word = "or")
    return arr[0].to_s if arr.size == 1
    last_element = arr.pop.to_s
    arr.join("#{separator} ") + " #{concat_word} #{last_element}"
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys, ';', 'and')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, #{human.name}, this is not a valid choice!"
    end
    board[square] = human.marker
  end

  def computer_moves
    board[board.find_best_move(@computer_marker, @human_marker)] \
      = computer_marker
  end

  def current_player_moves
    if @current_marker == human_marker
      human_moves
      @current_marker = computer_marker
    else
      computer_moves
      @current_marker = human_marker
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name}, you won!"
      @games_won[:human] += 1
    when computer.marker
      puts "#{computer.name} won! Another victory for AI!"
      @games_won[:computer] += 1
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "would u like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "sorry, must be y or n"
    end
    answer == "y"
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    @current_marker = @first_to_move
    clear
  end

  def display_play_again_message
    puts "lets play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
