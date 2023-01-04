import 'package:battleship/backend/ship.dart';
import 'Location.dart';

class Grid {
  static const int UNSET = -1;
  static const int HORIZONTAL = 0;
  static const int VERTICAL = 1;

  static final List<String> STATUS_STRINGS = ["-", "X", "O"];

  // Constants for number of rows and columns.
  static const int NUM_ROWS = 12;
  static const int NUM_COLS = 12;

  List<List<Location>> grid;

  // Create a new Grid. Initialize each Location in the grid
  // to be a new Location object.
  Grid(this.grid) {
    grid = List.generate(
        NUM_ROWS, (r) => List.generate(NUM_COLS, (c) => Location()));
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
    int length = s.getLength();
    int dir = s.getDirection();

    if (dir == VERTICAL) {
      for (int r = row; r < row + length; r++) {
        if (!inBounds(r, col) || hasShip(r, col)) {
          return false;
        }
      }
    } else {
      for (int c = col; c < col + length; c++) {
        if (!inBounds(row, c) || hasShip(row, c)) {
          return false;
        }
      }
    }

    if (dir == VERTICAL) {
      for (int r = row; r < row + length; r++) {
        setShip(r, col, true);
      }
    } else {
      for (int c = col; c < col + length; c++) {
        setShip(row, c, true);
      }
    }

    return true;
  }

  bool inBounds(int row, int col) {
    return row >= 0 && row < numRows() && col >= 0 && col < numCols();
  }

  // Mark a hit in this location by calling the markHit method
  // on the Location object.
  void markHit(int row, int col) {
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

  List<List<String>> getGridShips() {
    List<List<String>> shipGrid =
        List.generate(NUM_ROWS + 1, (i) => List.filled(NUM_COLS + 1, ""));

    for (int c = 1; c < NUM_COLS + 1; c++) {
      shipGrid[0][c] = c.toStringAsFixed(0);
    }
    for (int r = 0; r < NUM_ROWS; r++) {
      shipGrid[r + 1][0] = String.fromCharCode(65 + r);
      for (int c = 0; c < NUM_COLS; c++) {
        int curStatus = grid[r][c].getStatus();
        shipGrid[r + 1][c + 1] = STATUS_STRINGS[curStatus];
        if (grid[r][c].hasAShip() && curStatus == Location.UNGUESSED) {
          shipGrid[r + 1][c + 1] = "S";
        }
      }
    }
    return shipGrid;
  }

  List<List<String>> getGridStatus() {
    List<List<String>> statusGrid =
        List.generate(NUM_ROWS + 1, (i) => List.filled(NUM_COLS + 1, ""));

    for (int c = 1; c < NUM_COLS + 1; c++) {
      statusGrid[0][c] = c.toStringAsFixed(0);
    }
    for (int r = 0; r < NUM_ROWS; r++) {
      statusGrid[r + 1][0] = String.fromCharCode(65 + r);
      for (int c = 0; c < NUM_COLS; c++) {
        int curStatus = grid[r][c].getStatus();
        statusGrid[r + 1][c + 1] = STATUS_STRINGS[curStatus];
      }
    }
    return statusGrid;
  }
}
