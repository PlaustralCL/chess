# Chess
A command line chess game written in Ruby

This is the final project in the Ruby portion of [The Odin Project](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-programming/lessons/ruby-final-project).

## Table of Contents
* [How to Play](#how-to-play)
  * [Play Online](#play-online)
  * [Prerequisites](#prerequisites)
  * [Installing](#installing)
  * [To Play](#to-play)
* [Features](#features)
* [Tests](#tests)
* [Future Opportunities](#future-opportunities)
## How to Play
### Play Online
* The easiest way to try the game is to play the [live version on Replit](https://replit.com/@PlaustralCL/chess).
### Prerequisites
* Ruby 2.5 or greater
### Installing
* [Clone this repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) to your computer.
* Navigate to this project's directory. `cd chess`
### To Play
* Run `ruby lib/main.rb`
* Follow the on screen prompts

Please note that making a move is a two step process. You first enter coordinates of the piece you want to move. Then you enter the coordinates of the destination square. For example, to move a pawn from e2 to e4 you would first enter e4:

`e2`

Followed by:

`e4`

## Features
This program implements all the rules of chess you need to play a basic game.
* Only allowing legal moves
* Require players to get out of check
* Recognizing checkmate and stalemate
* Castling both kingside and queenside
* Updating castling rights as needed based on the play of game.
* En passant captures
* Promote a pawn to another piece if it reaches the end of the board
* Allow pawns to move two squares forward if it is from their starting square
* Draws by insufficent material
  * King vs King
  * King vs King and Bishop
  * King vs King and Knight
* Save the game for later
* Load a saved game
* Choose which color they play at the beginning of the game
* Choose a computer or human opponent
* Play against a simple Computer Opponent

## Tests
* Prerequisites: Rspec >= 3.9
* To run all tests, run `rspec spec/`
* To run individual test files, run 'rspec spec/` and the name of the test file.

## Future Opportunities
* Draw by repetition
* 50 move rule for draws (50 moves with no captures or pawn moves)
* Take back moves
* Rotate the board to change the viewpoint
* A more sophisticated computer opponent
