import 'package:battleship/backend/ship.dart';
import 'Location.dart';

class Grid {
  List<List<Location>> grid;

  static const int UNSET = -1;
  static const int HORIZONTAL = 0;
  static const int VERTICAL = 1;

  // Constants for number of rows and columns.
  static const int NUM_ROWS = 10;
  static const int NUM_COLS = 10;

  int hitsRemaining;

  // Create a new Grid. Initialize each Location in the grid
  // to be a new Location object.
  Grid(this.grid, this.hitsRemaining) {
    grid = List.generate(10, (i) => List.generate(10, (i) => Location()));

    hitsRemaining = 0;
  }

  // /**
  //  * This method can be called on your own grid. To add a ship
  //  * we will go to the ships location and mark a true value
  //  * in every location that the ship takes up.
  //  *
  //  * @param s Ship to add to Grid (must have set location, row, and directions
  //  * @return whether ship was able to be added
  //  */
  bool addShip(Ship s) {
    int row = s.getRow();
    int col = s.getCol();

    if (s.getDirection() == VERTICAL) {
      for (int i = row; i < row + s.getLength(); i++) {
        if (!inBounds(i, col) || hasShip(i, col)) {
          return false;
        }
      }
    } else {
      for (int i = col; i < col + s.getLength(); i++) {
        if (!inBounds(row, i) || hasShip(row, i)) {
          return false;
        }
      }
    }

    int length = s.getLength();
    int dir = s.getDirection();
    if (dir == 0) {
      for (int i = 0; i < length; i++) {
        setShip(row, col, true);
        col++;
      }
    } else {
      for (int i = 0; i < length; i++) {
        setShip(row, col, true);
        row++;
      }
    }
    hitsRemaining += length;
    return true;
  }

  int theHitsRemaining() {
    return hitsRemaining;
  }

  // Mark a hit in this location by calling the markHit method
  // on the Location object.
  void markHit(int row, int col) {
    hitsRemaining -= 1;
    grid[row][col].markHit();
  }

  // Mark a miss on this location.
  void markMiss(int row, int col) {
    grid[row][col].markMiss();
  }

  // Set the status of this location object.
  void setStatus(int row, int col, int status) {
    grid[row][col].setStatus(status);
  }

  // Get the status of this location in the grid
  int getStatus(int row, int col) {
    return grid[row][col].getStatus();
  }

  // Return whether or not this Location has already been guessed.
  bool alreadyGuessed(int row, int col) {
    return !grid[row][col].isUnguessed();
  }

  // Set whether or not there is a ship at this location to the val
  void setShip(int row, int col, bool val) {
    grid[row][col].setShip(val);
  }

  // Return whether or not there is a ship here
  bool hasShip(int row, int col) {
    return grid[row][col].hasAShip();
  }

  // Get the Location object at this row and column position
  Location get(int row, int col) {
    return grid[row][col];
  }

  // Return the number of rows in the Grid
  int numRows() {
    return NUM_ROWS;
  }

  // Return the number of columns in the grid
  int numCols() {
    return NUM_COLS;
  }

  bool inBounds(int row, int col) {
    return row >= 0 && row < numRows() && col >= 0 && col < numCols();
  }

  List<List<String>> getGridShips() {
    List<List<String>> shipGrid = List.generate(11, (i) => List.filled(11, ""));

    for (int c = 1; c < 11; c++) {
      shipGrid[0][c] = c.toStringAsFixed(0);
    }

    for (int r = 0; r < NUM_ROWS; r++) {
      shipGrid[r + 1][0] = String.fromCharCode(65 + r);
      for (int c = 0; c < NUM_COLS; c++) {
        int curStatus = grid[r][c].getStatus();
        switch (curStatus) {
          case Location.MISSED:
            shipGrid[r + 1][c + 1] = "O";
            break;
          case Location.HIT:
            shipGrid[r + 1][c + 1] = "X";
            break;
          default:
            if (grid[r][c].hasAShip()) {
              shipGrid[r + 1][c + 1] = "S";
            } else {
              shipGrid[r + 1][c + 1] = "-";
            }
            break;
        }
      }
    }
    return shipGrid;
  }

  List<List<String>> getGridStatus() {
    List<List<String>> statusGrid =
        List.generate(11, (i) => List.filled(11, ""));
    //List.filled(11, List.filled(11, " "));

    for (int c = 1; c < 11; c++) {
      statusGrid[0][c] = c.toStringAsFixed(0);
    }
    for (int r = 0; r < NUM_ROWS; r++) {
      statusGrid[r + 1][0] = String.fromCharCode(65 + r);
      for (int c = 0; c < NUM_COLS; c++) {
        int curStatus = grid[r][c].getStatus();
        switch (curStatus) {
          case Location.MISSED:
            statusGrid[r + 1][c + 1] = "O";
            break;
          case Location.HIT:
            statusGrid[r + 1][c + 1] = "X";
            break;
          default:
            statusGrid[r + 1][c + 1] = "-";
            break;
        }
      }
    }
    return statusGrid;
  }
}
