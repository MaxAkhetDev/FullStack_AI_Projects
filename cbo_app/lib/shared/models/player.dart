class Player {
  final String id;
  final String name;
  final int score;
  final String level;
  final List<Map<String, dynamic>> rounds;

  const Player({
    required this.id,
    required this.name,
    required this.score,
    required this.level,
    required this.rounds,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'] as String,
        name: json['name'] as String,
        score: json['score'] as int,
        level: json['level'] as String,
        rounds: List<Map<String, dynamic>>.unmodifiable(
          (json['rounds'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList(),
        ),
      );

  Player copyWith({String? name, int? score, String? level, List<Map<String, dynamic>>? rounds}) =>
      Player(
        id: id,
        name: name ?? this.name,
        score: score ?? this.score,
        level: level ?? this.level,
        rounds: rounds ?? this.rounds,
      );
}
