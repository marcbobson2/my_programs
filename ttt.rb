require 'pry'

module AIMoveLogic
  CENTER_SQUARE = 5
  CORNER_SQUARES = [1, 3, 7, 9].freeze
  PROMISING_WIN_LINES = [2, 1].freeze

  def find_best_move(computer_marker, human_marker)
    winning_move = check_for_winning_move(computer_marker)
    return winning_move if winning_move

    defend_against_winning_move = check_for_winning_move(human_marker)
    return defend_against_winning_move if defend_against_winning_move

    make_attacking_move = attack_or_defend?(computer_marker)
    return make_attacking_move if make_attacking_move

    make_defensive_move = attack_or_defend?(human_marker)
    return make_defensive_move if make_defensive_move

    choose_best_move_from_set(unmarked_keys)
  end

  private

  def check_for_winning_move(marker)
    unmarked_keys.each do |key|
      identify_all_win_lines_per_square(key).each do |win_line|
        return key if winning_move?(win_line, marker)
      end
    end
    false
  end

  def winning_move?(win_line, marker)
    @squares[win_line[0]].marker == marker && \
      @squares[win_line[1]].marker == marker
  end

  def choose_best_move_from_set(possible_moves)
    return CENTER_SQUARE if possible_moves.include?(CENTER_SQUARE)

    return (possible_moves & CORNER_SQUARES).sample \
      if !(possible_moves & CORNER_SQUARES).empty?

    possible_moves.sample
  end

  def identify_all_win_lines_per_square(square)
    win_lines_dup = Board::WINNING_LINES.map(&:dup)
    win_lines_per_square =
      identify_each_win_line_per_square(win_lines_dup, square)
    remove_active_square_from_win_line_array(win_lines_per_square, square)
  end

  def identify_each_win_line_per_square(win_lines_dup, square)
    win_lines_per_square = []
    win_lines_dup.each do |win_line|
      win_lines_per_square << win_line if win_line.include?(square)
    end
    win_lines_per_square
  end

  def remove_active_square_from_win_line_array(win_lines_per_square, square)
    win_lines_per_square.each { |line| line.delete(square) }
  end

  def attack_or_defend?(marker)
    PROMISING_WIN_LINES.each do |promising_win_line|
      set_of_possible_moves = []
      unmarked_keys.each do |key|
        set_of_possible_moves << key \
          if win_line_meets_criteria?(identify_all_win_lines_per_square(key), \
                                      marker, promising_win_line)
      end
      return choose_best_move_from_set(set_of_possible_moves) \
        if !set_of_possible_moves.empty?
    end
    false
  end

  def win_line_meets_criteria?(win_lines, marker, required_lines)
    valid_lines = 0
    win_lines.each do |win_line|
      valid_lines += 1 \
        if markers_per_win_line(win_line, marker).positive? && \
           markers_per_win_line(win_line, Square::INITIAL_MARKER).zero?
    end
    valid_lines >= required_lines
  end

  def markers_per_win_line(win_line, marker_type)
    marker_count = 0
    win_line.each do |square_key|
      marker_count += 1 if @squares[square_key].marker == marker_type
    end
    marker_count
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

  def initialize
  end
end

class Human < Player
  def initialize
    set_name
    choose_marker
  end

  def set_name
    loop do
      puts "Please enter your name:"
      @name = gets.chomp.to_s
      break if !@name.empty?
      puts "You must enter at least 1 character!"
    end
  end

  def choose_marker
    @marker = nil
    loop do
      puts "Enter any single-character marker you want:"
      @marker = gets.chomp.to_s
      break if valid_marker?(@marker)
      puts "Your marker must be a single character, and not a space."
    end
  end

  def valid_marker?(marker)
    marker.size == 1 && marker != " "
  end

  def move(board)
    puts "Choose a square (#{joinor(board.unmarked_keys, ';', 'and')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, #{@name}, this is not a valid choice!"
    end
    board[square] = @marker
  end

  def joinor(arr, separator = ",", concat_word = "or")
    return arr[0].to_s if arr.size == 1
    last_element = arr.pop.to_s
    arr.join("#{separator} ") + " #{concat_word} #{last_element}"
  end
end

class Computer < Player
  COMPUTER_MARKER_CHOICES = ("A".."Z").to_a
  COMPUTER_NAME_OPTIONS = ["Tom", "Robert", "Sigfried", "Lionel", "Tito"].freeze

  attr_accessor :name

  def initialize(human_marker)
    set_name
    choose_marker(human_marker)
  end

  def set_name
    @name = COMPUTER_NAME_OPTIONS.sample
  end

  def move(board, human_marker)
    board[board.find_best_move(@marker, human_marker)] \
      = @marker
  end

  def choose_marker(human_marker)
    loop do
      @marker = COMPUTER_MARKER_CHOICES.sample
      break if @marker != human_marker.upcase
    end
  end
end

class TTTGame
  DEFAULT_COMPUTER_MARKER = "O".freeze
  DEFAULT_HUMAN_MARKER = "X".freeze

  MAX_GAMES = 2

  attr_accessor :board, :human, :computer, \
                :human_marker, :computer_marker, :human_name

  def initialize
    @board = Board.new
    display_welcome_message
    @human = Human.new
    @computer = Computer.new(@human.marker)
    @first_to_move = @human.marker
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

  def display_welcome_message
    puts "Welcome to tic tac toe"
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
    puts "#{human.name}, you have won #{@games_won[:human]} games. "\
         "#{computer.name} has won #{@games_won[:computer]} games."
  end

  def display_board
    puts "#{human.name}, you are an #{human.marker} and "\
         "#{computer.name} is an #{computer.marker}"
    display_score
    puts ""
    board.draw
    puts ""
  end

  def current_player_moves
    if @current_marker == human.marker
      human.move(@board)
      @current_marker = computer.marker
    else
      computer.move(@board, human.marker)
      @current_marker = human.marker
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
