// lib/core/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/trading_card_game/data/local_asset_card_repository.dart';
import 'package:provider/provider.dart'; // Import Provider

import 'package:myapp/adventure_2d/screens/adventure_game_screen.dart';
import 'package:myapp/puzzle_mode/presentation/screens/puzzle_game_screen.dart'; // Corrected import path
// Import Trading Card Battle Screen
import 'package:myapp/trading_card_game/presentation/screens/card_game_dashboard_screen.dart'; // Corrected import path for dashboard
import 'package:myapp/trading_card_game/presentation/screens/card_collection_screen.dart'; // Import collection screen
import 'package:myapp/simulation_theory/screens/simulation_theory_screen.dart';
import 'package:myapp/chess_game/screens/chess_game_screen.dart';
import 'package:myapp/battleship_game/screens/battleship_game_screen.dart';
import 'package:myapp/side_scroll_3d_battle/screens/side_scroll_3d_battle_screen.dart';


/// ----------------------------
/// Simple local placeholder UI
/// ----------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/game_modes'),
              child: const Text('Game Modes'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/conspiracy_theory'),
              child: const Text('Conspiracy Theory'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameModesScreen extends StatelessWidget {
  const GameModesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Modes'),
        automaticallyImplyLeading: true, // Show back button
        actions: [
          IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.home)), // Home button
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Button for Trading Card Game Mode (Navigate to dashboard)
            ElevatedButton(
              onPressed: () => context.go('/game_modes/trading_card_battle'),
              child: const Text('Trading Card Battle'),
            ),
            const SizedBox(height: 8),
            // Button for Puzzle Game Mode (Navigate to puzzle screen)
             ElevatedButton(
              onPressed: () => context.go('/game_modes/puzzle'),
              child: const Text('Puzzle'),
            ),
            const SizedBox(height: 8),
             // Existing Buttons
            ElevatedButton(
              onPressed: () => context.go('/game_modes/adventure_2d'),
              child: const Text('2D Adventure'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/game_modes/simulation_theory'),
              child: const Text('Simulation Theory'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/game_modes/chess_game'),
              child: const Text('Chess Game'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/game_modes/battleship_game'),
              child: const Text('Battleship'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/game_modes/side_scroll_2d_battle'),
              child: const Text('Side-Scroll 2D Battle'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConspiracyTheoryScreen extends StatelessWidget {
  const ConspiracyTheoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conspiracy Theory'),
        automaticallyImplyLeading: true, // Show back button
        actions: [
          IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.home)), // Home button
        ],
      ),
    );
  }
}

// Simple placeholder so the settings button doesn’t 404
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Settings')));
  }
}

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/game_modes',
      builder: (BuildContext context, GoRouterState state) => const GameModesScreen(),
    ),
    GoRoute(
      path: '/conspiracy_theory',
      builder: (BuildContext context, GoRouterState state) => const ConspiracyTheoryScreen(),
    ),
    // Puzzle Game Mode Route
    GoRoute(
      path: '/game_modes/puzzle', // Corrected path
      builder: (BuildContext context, GoRouterState state) => const PuzzleGameScreen(), // Corrected screen name
    ),
    // Trading Card Battle Game Mode Route
    GoRoute(
      path: '/game_modes/trading_card_game', // Corrected path
      builder: (BuildContext context, GoRouterState state) => const CardGameDashboardScreen(), // Navigate to dashboard
      routes: [
        GoRoute(
          path: 'collection', // Nested route for collection
          builder: (BuildContext context, GoRouterState state) =>
              // Wrap CardCollectionScreen with Provider for CardRepository
              Provider(
            create: (_) => LocalAssetCardRepository(), // Provide your CardRepository implementation
            child: const CardCollectionScreen(),
          ),
        ),
      ],
    ),
    // Existing Routes
    GoRoute(
      path: '/game_modes/adventure_2d',
      builder: (BuildContext context, GoRouterState state) => const AdventureGameScreen(),
    ),
    GoRoute(
      path: '/game_modes/simulation_theory',
      builder: (BuildContext context, GoRouterState state) => const SimulationTheoryGameScreen(),
    ),
    GoRoute(
      path: '/game_modes/chess_game',
      builder: (BuildContext context, GoRouterState state) => const ChessGameScreen(),
    ),
    GoRoute(
      path: '/game_modes/battleship_game',
      builder: (BuildContext context, GoRouterState state) => const BattleshipGameScreen(),
    ),
    GoRoute(
      path: '/game_modes/side_scroll_2d_battle',
      builder: (BuildContext context, GoRouterState state) => const SideScroll3dBattleScreen(),
    ),
  ],
);
