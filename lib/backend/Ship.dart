import 'package:flutter/material.dart';

class Ship {
  // Instance variables
  int row;
  int col;
  int length;
  int direction;

  // Direction constants
  static const int UNSET = -1;
  static const int HORIZONTAL = 0;
  static const int VERTICAL = 1;
  static final List<String> directionStrings = [
    "unset direction",
    "horizontal",
    "vertical"
  ];

  // Constructor. Create a ship and set the length.
  Ship(int length) : this.withVariables(UNSET, UNSET, UNSET, length);
  Ship.withVariables(this.row, this.col, this.direction, this.length);

  // Has the location been initialized
  bool isLocationSet() {
    return (row != UNSET && col != UNSET);
  }

  // Has the direction been initialized
  bool isDirectionSet() {
    return (direction != UNSET);
  }

  // Set the location of the ship
  void setLocation(int row, int col) {
    this.row = row;
    this.col = col;
  }

  // Set the direction of the ship
  void setDirection(int direction) {
    this.direction = direction;
  }

  // Getter for the row value
  int getRow() {
    return row;
  }

  // Getter for the column value
  int getCol() {
    return col;
  }

  // Getter for the length of the ship
  int getLength() {
    return length;
  }

  // Getter for the direction
  int getDirection() {
    return direction;
  }

  // Helper method to get a string value from the direction
  String directionToString() {
    return directionStrings[direction + 1];
  }

  // Helper method to get a (row, col) string value from the location
  String locationToString() {
    if (isLocationSet()) {
      return "($row, $col)";
    } else {
      return "(unset location)";
    }
  }

  // toString value for this Ship
  @override
  String toString() {
    return "${directionToString()} ship of length $length at ${locationToString()}";
  }
}
