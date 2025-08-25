// lib/trading_card_game/data/card_game_manager.dart

import 'card_repository.dart';
import 'game_card.dart';

class CardGameManager {
  final CardRepository repo;

  CardGameManager({required this.repo});

  /// Load entire collection from the repository.
  Future<List<GameCard>> fetchCollection() => repo.fetchAll();

  /// Get a single card by id (null if not found).
  Future<GameCard?> getById(String id) => repo.getById(id);

  /// Returns a new list filtered by a case-insensitive name query.
  Future<List<GameCard>> searchByName(String query) async {
    final all = await fetchCollection();
    if (query.trim().isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  /// Sort utilities
  Future<List<GameCard>> sortByName({bool ascending = true}) async {
    final all = [...await fetchCollection()];
    all.sort((a, b) => a.name.compareTo(b.name));
    return ascending ? all : all.reversed.toList();
  }

  Future<List<GameCard>> sortByAttack({bool descending = true}) async {
    final all = [...await fetchCollection()];
    all.sort((a, b) => a.attack.compareTo(b.attack));
    return descending ? all.reversed.toList() : all;
  }

  Future<List<GameCard>> sortByDefense({bool descending = true}) async {
    final all = [...await fetchCollection()];
    all.sort((a, b) => a.defense.compareTo(b.defense));
    return descending ? all.reversed.toList() : all;
  }

  /// Selection helpers (returns a modified copy; original list remains unchanged)
  List<GameCard> toggleSelected(List<GameCard> source, String id) {
    return source
        .map((c) => c.id == id ? _copy(c, isSelected: !c.isSelected) : c)
        .toList(growable: false);
  }

  List<GameCard> setFaceUp(List<GameCard> source, String id, bool value) {
    return source
        .map((c) => c.id == id ? _copy(c, isFaceUp: value) : c)
        .toList(growable: false);
  }

  /// Inventory helpers
  List<GameCard> incrementOwned(List<GameCard> source, String id, {int by = 1}) {
    return source
        .map((c) => c.id == id ? _copy(c, ownedCount: c.ownedCount + by) : c)
        .toList(growable: false);
  }

  List<GameCard> decrementOwned(List<GameCard> source, String id, {int by = 1}) {
    return source
        .map((c) => c.id == id
            ? _copy(c, ownedCount: (c.ownedCount - by).clamp(0, 0x7fffffff))
            : c)
        .toList(growable: false);
  }

  /// Build a deck from selected cards. Enforces max size and ownedCount.
  List<GameCard> buildDeck({
    required List<GameCard> collection,
    int maxSize = 20,
  }) {
    final selected = collection.where((c) => c.isSelected && c.ownedCount > 0).toList();

    // Expand by ownedCount (each copy counts)
    final expanded = <GameCard>[];
    for (final c in selected) {
      for (int i = 0; i < c.ownedCount; i++) {
        expanded.add(c);
      }
    }

    // Deterministic order: strongest first then name
    expanded.sort((a, b) {
      final atkCmp = b.attack.compareTo(a.attack);
      if (atkCmp != 0) return atkCmp;
      final defCmp = b.defense.compareTo(a.defense);
      if (defCmp != 0) return defCmp;
      return a.name.compareTo(b.name);
    });

    return expanded.take(maxSize).toList(growable: false);
  }

  int computeDeckPower(List<GameCard> deck) =>
      deck.fold<int>(0, (sum, c) => sum + c.attack + c.defense);

  // ----- private helper the analyzer couldn't find -----
  GameCard _copy(
    GameCard c, {
    int? ownedCount,
    bool? isSelected,
    bool? isFaceUp,
  }) {
    return GameCard(
      baseCard: c.baseCard, // immutable base model reused
      ownedCount: ownedCount ?? c.ownedCount,
      isSelected: isSelected ?? c.isSelected,
      isFaceUp: isFaceUp ?? c.isFaceUp,
    );
  }
}
