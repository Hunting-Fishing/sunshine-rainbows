import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChessGameScreen extends StatelessWidget {
  const ChessGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Chess Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              context.go('/');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Chess Game Mode Placeholder'),
      ),
    );
  }
}