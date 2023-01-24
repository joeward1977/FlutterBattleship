import '../backend/Grid.dart';
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
        crossAxisCount: Grid.NUM_COLS + 1,
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
                      backgroundColor: (index < (Grid.NUM_COLS + 1) ||
                              index % (Grid.NUM_COLS + 1) == 0)
                          ? const Color.fromARGB(255, 19, 16, 82)
                          : widget.grid[(index / (Grid.NUM_ROWS + 1)).floor()]
                                      [index % (Grid.NUM_COLS + 1)] ==
                                  'X'
                              ? Colors.red
                              : widget.grid[(index / (Grid.NUM_ROWS + 1)).floor()]
                                          [index % (Grid.NUM_COLS + 1)] ==
                                      'S'
                                  ? Colors.green
                                  : const Color(0xFF2979FF)),
                  onPressed: () {
                    var row = (index / (Grid.NUM_COLS + 1)).floor() - 1;
                    var col = index % (Grid.NUM_COLS + 1) - 1;
                    if (widget.type == 0) {
                      if (gameState == placeShips &&
                          shipPlacementDirection != -1) {
                        human.addShip(row, col, shipPlacementDirection);
                        if (human.numShipsPlaced == 5) {
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
                      child: Text(
                          widget.grid[(index / (Grid.NUM_COLS + 1)).floor()]
                              [index % (Grid.NUM_COLS + 1)],
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
