import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SimulationTheoryGameScreen extends StatelessWidget {
  const SimulationTheoryGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Add back button
        title: const Text('Simulation Theory Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home), // Add home button
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Simulation Theory Game Placeholder',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}