class Mastermind
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
    return game_finished?(win = true) if @cpu_secret_code.eql?(reference)

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
      if (@cpu_secret_code.index(code) == reference.index(code) && reference[count] == code)
        correct_color_and_position += 1
      elsif (@cpu_secret_code.index(code) == reference.index(code))
        correct_position += 1
      elsif (@cpu_secret_code.include?(reference[count]))
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

game = Mastermind.new

loop do
  break if game.game_won == true

  puts "\nTurn #{game.game_turn} - Enter your guess: "
  guess = gets.chomp
  game.make_guess(guess)
end

if (game_won)
  puts "\nYou've guessed the code! Press ENTER to exit."
else
  puts "\nYou didn't guess the code. Press ENTER to exit."
end
gets