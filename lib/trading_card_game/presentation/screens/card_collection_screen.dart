import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/trading_card_game/data/card_repository.dart';
import 'package:myapp/trading_card_game/data/game_card.dart';
import 'package:myapp/trading_card_game/presentation/widgets/card_widget.dart';

class CardCollectionScreen extends StatefulWidget {
  const CardCollectionScreen({super.key});

  @override
  State<CardCollectionScreen> createState() => _CardCollectionScreenState();
}

class _CardCollectionScreenState extends State<CardCollectionScreen> {
  late Future<List<GameCard>> _futureCards;

  @override
  void initState() {
    super.initState();
    final repository = context.read<CardRepository>();
    _futureCards = repository.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Card Collection')),
      body: FutureBuilder<List<GameCard>>(
        future: _futureCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading cards: ${snapshot.error}'));
          }

          final cards = snapshot.data ?? const <GameCard>[];
          if (cards.isEmpty) {
            return const Center(child: Text('No cards in collection.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: cards.length,
            itemBuilder: (context, i) => CardWidget(card: cards[i]),
          );
        },
      ),
    );
  }
}
