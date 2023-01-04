import 'dart:math';
import '../backend/Grid.dart';
import '../backend/Player.dart';
import 'package:flutter/material.dart';
import '../screens/GridScreen.dart';

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
  int row = rng.nextInt(Grid.NUM_ROWS);
  int col = rng.nextInt(Grid.NUM_COLS);
  while (human.alreadyGuessed(row, col)) {
    row = rng.nextInt(Grid.NUM_ROWS);
    col = rng.nextInt(Grid.NUM_COLS);
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
  current.initializeShipsRandomly();
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
    updateGameState(startGame);
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
        body: Center(
      child: Column(
        children: <Widget>[
          // GRIDS
          // This is where the grids for the game are shown
          SizedBox(
            height: 390,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.title),
                  actions: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        updateGameState(startGame);
                        setState(
                          () {
                            humanGrid = GridScreen(
                                grid: human.getGrid().getGridShips(),
                                type: 0,
                                notifyParent: refresh);
                            computerGrid = GridScreen(
                                grid: computer.getGrid().getGridStatus(),
                                type: 1,
                                notifyParent: refresh);
                          },
                        );
                      },
                      icon: const Icon(
                        // <-- Icon
                        Icons.refresh,
                        size: 24.0,
                      ),
                      label: const Text('Restart'), // <-- Text
                    ),
                  ],
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Player Grid'),
                      Tab(text: 'Computer Grid'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    Column(children: <Widget>[
                      const SizedBox(height: 10),
                      SizedBox(width: 250, height: 250, child: humanGrid),
                      Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Column contents vertically,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //Center Column contents horizontally,
                          children: [
                            Text(
                              "Your Hits Left: $playerHitsRemaining",
                              style: const TextStyle(
                                  color: Color(0xFF2979FF), fontSize: 14),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "CPU Hits Left: $computerHitsRemaining",
                              style: const TextStyle(
                                  color: Color(0xFF2979FF), fontSize: 14),
                            ),
                          ])
                    ]),
                    Column(children: <Widget>[
                      const SizedBox(height: 10),
                      SizedBox(width: 250, height: 250, child: computerGrid),
                      Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Column contents vertically,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //Center Column contents horizontally,
                          children: [
                            Text(
                              "Your Hits Left: $playerHitsRemaining",
                              style: const TextStyle(
                                  color: Color(0xFF2979FF), fontSize: 14),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "CPU Hits Left: $computerHitsRemaining",
                              style: const TextStyle(
                                  color: Color(0xFF2979FF), fontSize: 14),
                            ),
                          ])
                    ])
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Text(
            theText,
            style: const TextStyle(
                color: Color(0xFF2979FF),
                fontWeight: FontWeight.bold,
                fontSize: 16),
            selectionColor: const Color(0xFF2979FF),
          ),
          const SizedBox(height: 10),

          /// BUTTONS
          /// Here is where the buttons will be displayed
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Column contents vertically,
              crossAxisAlignment: CrossAxisAlignment
                  .center, //Center Column contents horizontally,
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
                const SizedBox(width: 5),
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
                        child: Text(buttonTwoText)))
              ]),
        ],
      ),
    ));
  }
}

void updateGameState(int theState) {
  gameState = theState;
  if (gameState == startGame) {
    newGame();
    buttonOneText = 'User Selected';
    buttonTwoText = 'Randomly Selected';
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

String buttonOneText = 'User Selected';
String buttonTwoText = 'Randomly Selected';
bool visibleButtons = true;
