import 'dart:math';
import 'package:battleship/backend/Player.dart';
import 'package:flutter/material.dart';
import 'package:battleship/screens/GridScreen.dart';

/// Code for students to know
/// Here are the players in the game
/// The state of the game
/// Some other information to keep holf of during game play
Player human = Player();
Player computer = Player();
int gameState = startGame;
String theText = "Play";
int playerHitsRemaining = 0;
int computerHitsRemaining = 0;
int shipPlacementDirection = -1;

/// When a new game is started
void newGame() {
  human = Player();
  computer = Player();
}

void computerMove() {
  var rng = Random();
  int row = rng.nextInt(10);
  int col = rng.nextInt(10);
  while (human.alreadyGuessed(row, col)) {
    row = rng.nextInt(10);
    col = rng.nextInt(10);
  }
  human.recordOpponentGuess(row, col);

  playerHitsRemaining = human.getHitsRemaining();
  if (playerHitsRemaining == 0) {
    theText = 'Game Over...You Lose:-(';
    gameState = endGame;
  }
}

void playerMove(int row, int col) {
  computer.recordOpponentGuess(row, col);

  computerHitsRemaining = computer.getHitsRemaining();
  if (computerHitsRemaining == 0) {
    theText = 'Game Over...You Win!';
    gameState = endGame;
  }
}

void randomShipLocations(Player current) {
  current.clearShips();
  var rng = Random();
  int numShipsAdded = 0;
  while (numShipsAdded < Player.SHIP_LENGTHS.length) {
    int row = rng.nextInt(10);
    int col = rng.nextInt(10);
    int dir = rng.nextInt(2);
    bool shipAdded = current.addShip(row, col, dir);
    if (shipAdded) {
      numShipsAdded++;
    }
  }
}

class Game extends StatefulWidget {
  const Game({super.key, required this.title});
  final String title;

  @override
  State<Game> createState() => _GameState();
}

// The GUI
class _GameState extends State<Game> {
  late GridScreen humanGrid;
  late GridScreen computerGrid;

  @override
  void initState() {
    humanGrid = GridScreen(
        grid: human.getGrid().getGridShips(), type: 0, notifyParent: refresh);
    computerGrid = GridScreen(
        grid: computer.getGrid().getGridStatus(),
        type: 1,
        notifyParent: refresh);
    newGame();
    super.initState();
  }

  refresh() {
    setState(() {
      humanGrid = GridScreen(
          grid: human.getGrid().getGridShips(), type: 0, notifyParent: refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              //
              const SizedBox(height: 20),
              Text(
                theText,
                style: const TextStyle(
                    color: Color(0xFF2979FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                selectionColor: const Color(0xFF2979FF),
              ),
              const SizedBox(height: 20),
              // GRIDS
              // This is where the grids for the game are shown
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(children: <Widget>[
                      SizedBox(width: 300, height: 300, child: humanGrid),
                      Text("Player Hits Remaining: $playerHitsRemaining"),
                    ]),
                    const SizedBox(width: 20),
                    Column(children: <Widget>[
                      SizedBox(width: 300, height: 300, child: computerGrid),
                      Text("Computer Hits Remaining: $computerHitsRemaining")
                    ])
                  ]),
              const SizedBox(height: 20),

              /// BUTTONS
              /// Here is where the buttons will be displayed
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: visibleButtons,
                      child: ElevatedButton(
                          onPressed: () {
                            if (gameState == placeShips) {
                              shipPlacementDirection = 1;
                            }
                            if (gameState == startGame) {
                              updateGameState(placeShips);
                            }
                            setState(() {
                              humanGrid = GridScreen(
                                  grid: human.getGrid().getGridShips(),
                                  type: 0,
                                  notifyParent: refresh);
                              computerGrid = GridScreen(
                                  grid: computer.getGrid().getGridStatus(),
                                  type: 1,
                                  notifyParent: refresh);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: shipPlacementDirection == 1
                                  ? Colors.red
                                  : const Color(0xFF2979FF)),
                          child: Text(buttonOneText)),
                    ),
                    const SizedBox(width: 20),
                    Visibility(
                        visible: visibleButtons,
                        child: ElevatedButton(
                            onPressed: () {
                              if (gameState == placeShips) {
                                shipPlacementDirection = 0;
                              }
                              if (gameState == startGame) {
                                randomShipLocations(human);
                                updateGameState(playGame);
                              }
                              setState(() {
                                humanGrid = GridScreen(
                                    grid: human.getGrid().getGridShips(),
                                    type: 0,
                                    notifyParent: refresh);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: shipPlacementDirection == 0
                                    ? Colors.red
                                    : const Color(0xFF2979FF)),
                            child: Text(buttonTwoText))),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          updateGameState(startGame);
                          setState(() {
                            humanGrid = GridScreen(
                                grid: human.getGrid().getGridShips(),
                                type: 0,
                                notifyParent: refresh);
                            computerGrid = GridScreen(
                                grid: computer.getGrid().getGridStatus(),
                                type: 1,
                                notifyParent: refresh);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2979FF)),
                        child: const Text('Restart Game')),
                  ])
            ],
          ),
        ));
  }
}

void updateGameState(int theState) {
  gameState = theState;
  if (gameState == startGame) {
    newGame();
    buttonOneText = 'User Selected Ships';
    buttonTwoText = 'Randomly Selected Ships';
    playerHitsRemaining = human.getHitsRemaining();
    computerHitsRemaining = computer.getHitsRemaining();
    visibleButtons = true;
    theText = "Ship Placement Type";
  }
  if (gameState == placeShips) {
    buttonOneText = 'Vertical';
    buttonTwoText = 'Horizontal';
    visibleButtons = true;
    theText = "Ship Placement";
  }
  if (gameState == playGame) {
    randomShipLocations(computer);
    visibleButtons = false;
    playerHitsRemaining = human.getHitsRemaining();
    computerHitsRemaining = computer.getHitsRemaining();
    theText = "Play Game";
  }
  if (gameState == endGame) {
    visibleButtons = false;
    theText = "Game Over";
  }
}

const int startGame = 0;
const int placeShips = 1;
const int playGame = 2;
const int endGame = 3;

String buttonOneText = 'User Selected Ships';
String buttonTwoText = 'Randomly Selected Ships';
bool visibleButtons = true;
