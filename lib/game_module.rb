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

  # Deletes the state files if the game finishes or the game is over
  def delete_state_files
    # Specify the filenames for the state files
    save_filename = 'game_state.sav'
    load_filename = 'game_state_load.sav'

    # Check if the game is over or the game finishes
    if game_over?
      # Delete the state files
      File.delete(save_filename) if File.exist?(save_filename)
      File.delete(load_filename) if File.exist?(load_filename)
    end
  end  
end