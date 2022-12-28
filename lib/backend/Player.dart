import 'package:battleship/backend/ship.dart';

import 'Grid.dart';

class Player {
  static final List<int> SHIP_LENGTHS = [2, 3, 3, 4, 5];
  Grid playerGrid;
  List<Ship> ships;
  int numShips;

  Player()
      : playerGrid = Grid([[]], 0),
        ships = [],
        numShips = 0;

  void clearShips() {
    playerGrid = Grid([[]], 0);
    ships = [];
    numShips = 0;
  }

  bool addShip(int row, int col, int dir) {
    if (ships.length <= numShips) {
      ships.add(Ship.withVariables(row, col, dir, SHIP_LENGTHS[numShips]));
    } else {
      ships[numShips] =
          Ship.withVariables(row, col, dir, SHIP_LENGTHS[numShips]);
    }
    if (playerGrid.addShip(ships[numShips])) {
      numShips++;
      return true;
    } else {
      return false;
    }
  }

  int getNumShipsAdded() {
    return numShips;
  }

  int getShipLength() {
    return SHIP_LENGTHS[numShips];
  }

  Grid getGrid() {
    return playerGrid;
  }

  bool alreadyGuessed(int row, int col) {
    return playerGrid.alreadyGuessed(row, col);
  }

  void recordOpponentGuess(int row, int col) {
    if (playerGrid.hasShip(row, col)) {
      playerGrid.markHit(row, col);
    } else {
      playerGrid.markMiss(row, col);
    }
  }

  // Method not used
  void chooseShipLocation(Ship s, int row, int col, int direction) {
    s.setDirection(direction);
    s.setLocation(row, col);
    playerGrid.addShip(s);
    ships[numShips] = s;
    numShips++;
  }

  int getHitsRemaining() {
    return playerGrid.theHitsRemaining();
  }
}
