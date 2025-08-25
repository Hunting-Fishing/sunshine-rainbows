import 'card.dart';

/// Gameplay/UI wrapper around the base data card.
class GameCard {
  final TcgCard baseCard;
  int ownedCount;
  bool isSelected;
  bool isFaceUp;

  GameCard({
    required this.baseCard,
    this.ownedCount = 0,
    this.isSelected = false,
    this.isFaceUp = false,
  });

  /// Back-compat constructor so older code that created GameCard with fields keeps working.
  factory GameCard.fromRaw({
    required String id,
    required String name,
    required String description,
    required int attack,
    required int defense,
    required String imageAssetPath,
    int ownedCount = 0,
  }) {
    return GameCard(
      baseCard: TcgCard(
        id: id,
        name: name,
        description: description,
        attack: attack,
        defense: defense,
        imageAssetPath: imageAssetPath,
      ),
      ownedCount: ownedCount,
    );
  }

  factory GameCard.fromJson(Map<String, dynamic> json) {
    return GameCard(
      baseCard: TcgCard.fromJson(json),
      ownedCount: (json['ownedCount'] as num?)?.toInt() ?? 0,
      isSelected: json['isSelected'] == true,
      isFaceUp: json['isFaceUp'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        ...baseCard.toJson(),
        'ownedCount': ownedCount,
        'isSelected': isSelected,
        'isFaceUp': isFaceUp,
      };

  // UI-friendly getters
  String get id => baseCard.id;
  String get name => baseCard.name;
  String get description => baseCard.description;
  int get attack => baseCard.attack;
  int get defense => baseCard.defense;
  String get imageAssetPath => baseCard.imageAssetPath;
}
