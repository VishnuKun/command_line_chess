# frozen_string_literal: true

# lib/game_module.rb

# contains general methods for game class
module GameModule
  # method for saving game state
  def save_board(filename)
    File.open(filename, 'wb') do |file|
      file.write(Marshal.dump(game_board))
    end
  end

  # loads previous game state
  def load_board(filename)
    File.open(filename, 'rb') do |file|
      self.game_board = Marshal.load(file.read)
    end
  end
end
