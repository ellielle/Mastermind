class MastermindCodeBreaker
  attr_reader :game_turn
  attr_reader :game_won

  def initialize
    @cpu_secret_code = []
    @colors = {}
    @game_turn = 1
    @game_won = false
    set_game_colors
    generate_secret_code
    game_instructions
  end

  def game_finished?(win = false)
    @game_won = true if win
    return true if win
    return true if @game_turn > 12
  end

  def make_guess(reference)
    reference = reference.split(' ')
    reference.each { |g| g.upcase!.slice!(1..-1) }
    return invalid_input unless guess_valid?(reference) == true
    return game_finished?(true) if @cpu_secret_code.eql?(reference)

    check_guess_against_code(reference)
  end

  private

  def game_instructions
    puts 'Welcome to Mastermind! You will need to guess a combination of 4'\
          ' colors in correct order to win.'
    puts 'You will be given feedback after each round of guesses to help you'\
          ' refine your choices.'
    puts 'You may enter your guesses with either the first letter of the'\
          ' color, or the full word, separated by a single space.'
    puts 'The colors are as follows: green, pink, white, black, violet,'\
          ' orange, yellow, and cyan.'
  end

  def generate_secret_code
    @cpu_secret_code = @colors.values.to_a.sample(4)
    @cpu_secret_code.each { |c| c.upcase!.slice!(1..-1) }
  end

  def next_turn
    @game_turn += 1
  end

  def set_game_colors
    @colors = { G: 'green',
                P: 'pink',
                W: 'white',
                B: 'black',
                V: 'violet',
                O: 'orange',
                Y: 'yellow',
                C: 'cyan' }
  end

  def invalid_input
    puts "\nInvalid input."
  end

  def guess_valid?(reference)
    guess = true
    reference.map do |r|
      return false unless @colors.key?(r.to_sym)
    end
    guess
  end

  def check_guess_against_code(reference)
    correct_color = 0
    correct_position = 0
    correct_color_and_position = 0
    count = 0

    reference.each do |code|
      if (@cpu_secret_code[count] == reference[count])
        correct_color_and_position += 1
      elsif (@cpu_secret_code.index(code) == reference.index(code) && @cpu_secret_code.index(code).to_i == count)
        correct_position += 1
      elsif (@cpu_secret_code.include?(reference[count]) && @cpu_secret_code.index(code).to_i >= count)
        correct_color += 1
      end
      count += 1
    end
    give_feedback(correct_color, correct_position, correct_color_and_position)
  end

  def give_feedback(correct_color, correct_position, correct_color_and_position)
    puts "\nYou guessed #{correct_color_and_position} colors at the correct position." if correct_color_and_position > 0
    puts "\nYou guessed #{correct_position} position#{"s" if correct_position > 1} correct." if correct_position > 0
    puts "\nYou guessed #{correct_color} color#{"s" if correct_color > 1} correct." if correct_color > 0
    puts "\nYou guessed nothing correctly" if correct_color == 0 && correct_position == 0 && correct_color_and_position == 0
    next_turn
  end
end

class MastermindCodeMaster < MastermindCodeBreaker
  attr_reader :cpu_guess

  def initialize
    @cpu_guess = []
    @player_code
    @game_turn = 1
    @game_won = false
    set_game_colors
    game_instructions
    create_code
    computer_guess
  end

  def computer_turn
    return game_finished?(true) if @cpu_guess.eql?(@player_code)
    correct = check_previous_guess
    computer_guess(correct)
    next_turn
    game_finished?
  end

  private

  def check_previous_guess
    count = 0
    correct_guesses = []
    @cpu_guess.each do
      @cpu_guess[count] == @player_code[count] ? correct_guesses[count] = true : correct_guesses[count] = false
      count += 1
    end
    correct_guesses
  end

  def computer_guess(correct = [false, false, false, false])
    count = 0
    correct.each do |c|
      @cpu_guess[count] = @colors.values.to_a.sample(1) unless c
      count += 1
    end
    @cpu_guess.flatten!
    @cpu_guess.each do |c| 
      c.upcase!
      c.slice!(1..-1) if c.length > 1
    end
  end

  def create_code
    loop do
      puts "\nEnter your secret code: "
      player_guess = gets.chomp
      @player_code = player_guess.upcase.split(' ')
      break if guess_valid?(@player_code) == true
      puts "\nInvalid code sequence."
    end
  end

  def game_instructions
    puts 'Welcome to Mastermind! You will need to create a combination of 4'\
    ' colors to create a code.'
    puts 'The computer will be given feedback after each round of guesses attempt to'\
    ' make a better guess.'
    puts 'You may enter your code with either the first letter of the'\
    ' color, or the full word, separated by a single space.'
    puts 'The colors are as follows: green, pink, white, black, violet,'\
    ' orange, yellow, and cyan.'
  end
end

def check_choose_game(choice)
  choose_game(choice) if choice == "B" || choice == "M"
  return if choice == "X"

  return puts "Invalid game mode choice. Please enter (B) for code breaker or (M) for code master: "
end

def choose_game(choice)
  code_breaker(game = MastermindCodeBreaker.new) if choice == "B"
  code_master(game = MastermindCodeMaster.new) if choice == "M"
end

def code_breaker(game)
  loop do
    break if game.game_won == true
    break if game.game_turn > 12

    puts "\nTurn #{game.game_turn} - Enter your guess: "
    guess = gets.chomp
    game.make_guess(guess)
  end

  end_game(game)
end

def code_master(game)
  loop do
    break if game.game_won == true
    break if game.game_turn > 12

    puts "\nTurn #{game.game_turn}: The computer guesses #{game.cpu_guess.join(" ")}."
    game.computer_turn
    puts "Press ENTER for the next turn"
    gets
  end

  end_game(game)
end

def end_game(game)
  if game == "X"
  elsif game.game_won
    puts "\nYou've guessed the code! Press ENTER to exit." if choice == "B"
    puts "\nThe computer guessed the code! Press ENTER to exit." if choice == "M"
  else
    puts "\nYou didn't guess the code. Press ENTER to exit." if choice == "B"
    puts "\nThe computer didn't guess the code. Press ENTER to exit." if choice == "M"
  end
  gets if game != "X"
end

choice = ""
puts "\nWould you like to play as the code breaker(B) or the code master(M)? (X) to Exit: "

loop do
  break if choice == "B" || choice == "M" || choice == "X"

  choice = gets.chomp
  choice.upcase!
  check_choose_game(choice)
end
end_game(choice)
