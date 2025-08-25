// Renamed data model to avoid confusion with Flutter's Material Card widget.
class TcgCard {
  final String id;
  final String name;
  final String description;
  final int attack;
  final int defense;
  final String imageAssetPath;

  const TcgCard({
    required this.id,
    required this.name,
    required this.description,
    required this.attack,
    required this.defense,
    required this.imageAssetPath,
  });

  factory TcgCard.fromJson(Map<String, dynamic> json) {
    return TcgCard(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      attack: (json['attack'] as num?)?.toInt() ?? 0,
      defense: (json['defense'] as num?)?.toInt() ?? 0,
      imageAssetPath: (json['imageAssetPath'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'attack': attack,
        'defense': defense,
        'imageAssetPath': imageAssetPath,
      };
}
