import 'game_card.dart';

/// Repository contract (interface)
abstract class CardRepository {
  Future<List<GameCard>> fetchAll();
  Future<GameCard?> getById(String id);
}
