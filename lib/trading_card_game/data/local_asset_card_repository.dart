import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'card_repository.dart';
import 'game_card.dart';

/// Loads cards from a bundled JSON file. If [assetPath] is null or loading fails,
/// it returns a small mocked list so the app still runs.
class LocalAssetCardRepository implements CardRepository {
  final String? assetPath;
  List<GameCard>? _cache;

  LocalAssetCardRepository({this.assetPath});

  @override
  Future<List<GameCard>> fetchAll() async {
    if (_cache != null) return _cache!;

    if (assetPath == null) {
      _cache = _mock();
      return _cache!;
    }

    try {
      final raw = await rootBundle.loadString(assetPath!);
      final decoded = json.decode(raw);
      final List list = decoded is List
          ? decoded
          : (decoded is Map && decoded['cards'] is List ? decoded['cards'] as List : <dynamic>[]);
      _cache = list
          .map((e) => GameCard.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(growable: false);
      return _cache!;
    } catch (_) {
      _cache = _mock();
      return _cache!;
    }
  }

  @override
  Future<GameCard?> getById(String id) async {
    final all = await fetchAll();
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<GameCard> _mock() => [
        GameCard.fromRaw(
          id: 'c001',
          name: 'Placeholder Card 1',
          description: 'This is a placeholder card.',
          attack: 10,
          defense: 5,
          imageAssetPath: '',
          ownedCount: 2,
        ),
        GameCard.fromRaw(
          id: 'c002',
          name: 'Placeholder Card 2',
          description: 'Another placeholder card.',
          attack: 8,
          defense: 7,
          imageAssetPath: '',
          ownedCount: 1,
        ),
      ];
}
