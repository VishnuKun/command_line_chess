# Command Line Chess

Simple command line chess game where two players can play against each other.

## Table of contents

- [Command Line Chess](#command-line-chess)
  - [Table of contents](#table-of-contents)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Features](#features)

## Installation

1. Clone the repository :
   `git clone https://github.com/VishnuKun/command_line_chess.git`

2. Navigate to the project directory : `cd command_line_chess/`

## Usage

1. Run the `main.rb` from the `lib` directory using : `ruby lib/main.rb`

2. The game will prompt player 1 to make the first move with white troops. Each player on their turn will enter their choices in this format only `piece_square` afterwards `destination_square`. For example, to move the piece on the square `a1` to destinaton `a8` the user will be prompted to enter the `piece_square`, here `a1`, first then `destination_square`, here `a8`.

3. The game will continue asking each player for the squares and updating the board accordingly, until the game is over.

4. The game will display the board state after every move.

5. The game will be over if any of the conditions occur, checkmate or draw(stalemate, repitition, fifty move rule, insufficient material).

## Features

- The two players can load the previous board state and continue from where they left.

- The two players can save the board at any time by typing the `save` at any point. This will save the board state for later.

- Mutual agreement draw is possible , one player has to propose it using the word `agree` and the other will have to type `yes` for it to work though.

- The game also provides the option of resigning using `resign`, the person using it will lose the match.
