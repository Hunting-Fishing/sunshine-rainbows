import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardGameDashboardScreen extends StatelessWidget {
  const CardGameDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trading Card Game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/game_modes/trading_card_game/collection'),
              child: const Text('View Collection'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/game_modes/trading_card_game/campaign'),
              child: const Text('Start Campaign'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/game_modes/trading_card_game/pvp'),
              child: const Text('Start PVP Battle'),
            ),
          ],
        ),
      ),
    );
  }
}
