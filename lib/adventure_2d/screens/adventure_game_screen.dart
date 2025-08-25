import 'package:flutter/material.dart';
import 'package:flame/game.dart'; // Assuming Flame is a dependency
import 'package:myapp/adventure_2d/game.dart'; // Corrected import path

class AdventureGameScreen extends StatelessWidget {
  const AdventureGameScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2D Adventure Game'),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
      body: GameWidget(game: AdventureGame()),
    );
  }
}