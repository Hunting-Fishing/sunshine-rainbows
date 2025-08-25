import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:my_app/side_scroll_3d_battle/side_scroll_2d_battle_game.dart'; // Assuming your project name is my_app

class SideScroll3dBattleScreen extends StatelessWidget {
  const SideScroll3dBattleScreen({super.key});

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: const Text('2D Side-Scroll Battle'),
        automaticallyImplyLeading: true, // Show back button
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              context.go('/'); // Navigate to home route
            },
          ),
        ],
      ),
      // body: GameWidget(
      //   game: SideScroll2dBattleGame(), // Host the FlameGame widget
      // ),
      body: Center(child: Text('Side Scroll 3D Battle Screen Placeholder')),
    );
  }
}