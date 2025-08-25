import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BattleshipGameScreen extends StatelessWidget {
  const BattleshipGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battleship'),
        automaticallyImplyLeading: true, // Show back button
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'), // Navigate to home route
          ),
        ],
      ),
      body: const Center(
        child: Text('Battleship Game Screen Placeholder'),
      ),
    );
  }
}