import 'dart:math';
import 'Ship.dart';

import 'Grid.dart';

class Player {
  static final List<int> SHIP_LENGTHS = [2, 3, 3, 4, 5];
  Grid playerGrid;
  List<Ship> ships;
  int numShipsPlaced;
  int hitsRemaining;

  Player()
      : playerGrid = Grid([[]]),
        ships = [],
        numShipsPlaced = 0,
        hitsRemaining = 0;

  void clearShips() {
    playerGrid = Grid([[]]);
    ships = [];
    numShipsPlaced = 0;
    hitsRemaining = 0;
  }

  bool addShip(int row, int col, int dir) {
    int len = SHIP_LENGTHS[numShipsPlaced];
    Ship curShip = Ship.withVariables(row, col, dir, len);
    if (playerGrid.addShip(curShip)) {
      ships.add(curShip);
      hitsRemaining += len;
      numShipsPlaced++;
      return true;
    } else {
      return false;
    }
  }

  int getNumShipsPlaced() {
    return numShipsPlaced;
  }

  Grid getGrid() {
    return playerGrid;
  }

  int getHitsRemaining() {
    return hitsRemaining;
  }

  bool alreadyGuessed(int row, int col) {
    return playerGrid.alreadyGuessed(row, col);
  }

  bool recordOpponentGuess(int row, int col) {
    if (playerGrid.alreadyGuessed(row, col)) {
      return false;
    }
    if (playerGrid.hasShip(row, col)) {
      playerGrid.markHit(row, col);
      hitsRemaining--;
      return true;
    } else {
      playerGrid.markMiss(row, col);
      return false;
    }
  }

  void initializeShipsRandomly() {
    var rng = Random();
    int numShipsAdded = 0;
    while (numShipsAdded < Player.SHIP_LENGTHS.length) {
      int row = rng.nextInt(Grid.NUM_ROWS);
      int col = rng.nextInt(Grid.NUM_COLS);
      int dir = rng.nextInt(2);
      bool shipAdded = addShip(row, col, dir);
      if (shipAdded) {
        numShipsAdded++;
      }
    }
  }

  // Method not used
  void chooseShipLocation(Ship s, int row, int col, int direction) {
    s.setDirection(direction);
    s.setLocation(row, col);
    playerGrid.addShip(s);
    ships[numShipsPlaced] = s;
    numShipsPlaced++;
  }
}
