import 'package:battleship/main.dart';
import 'package:flutter/material.dart';
import "dart:core";
import 'GameScreen.dart';

class GridScreen extends StatefulWidget {
  final Function() notifyParent;
  late List<List<String>> grid;
  final int type;

  GridScreen(
      {Key? key,
      required this.grid,
      required this.type,
      required this.notifyParent})
      : super(key: key);

  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  late List<List<String>> grid;
  late int type;

  @override
  void initState() {
    grid = widget.grid;
    type = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        // Create a grid with 11 columns.
        crossAxisCount: 11,
        childAspectRatio: 1,
        padding: const EdgeInsets.all(1),
        children: List.generate(
          widget.grid.length * widget.grid[0].length,
          (index) {
            return Container(
              padding: const EdgeInsets.all(1),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(1),
                    backgroundColor: const Color(0xFF2979FF),
                  ),
                  onPressed: () {
                    var row = (index / 11).floor() - 1;
                    var col = index % 11 - 1;
                    if (widget.type == 0) {
                      if (gameState == placeShips &&
                          shipPlacementDirection != -1) {
                        human.addShip(row, col, shipPlacementDirection);
                        if (human.numShips == 5) {
                          updateGameState(playGame);
                        }
                        shipPlacementDirection = -1;
                        widget.notifyParent();
                      }
                    } else {
                      if (gameState == playGame) {
                        playerMove(row, col);
                        computerMove();
                        widget.notifyParent();
                      }
                    }
                    setState(() {
                      widget.grid = getGrid(widget.type);
                    });
                  },
                  child: Center(
                      child: Text(widget.grid[(index / 11).floor()][index % 11],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10)))),
            );
          },
        ));
  }
}

List<List<String>> getGrid(int type) {
  if (type == 0) {
    return human.getGrid().getGridShips();
  } else {
    return computer.getGrid().getGridStatus();
  }
}