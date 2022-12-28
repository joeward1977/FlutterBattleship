import 'package:battleship/screens/GameScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Battleship());
}

class Battleship extends StatelessWidget {
  const Battleship({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Website Title
      title: 'LFA Battleship Project',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF2979FF),
        secondary: const Color(0xFFFFC107),
      )),
      home: const Game(title: 'Battleship'),
    );
  }
}
