class Digimon {
  final String name;
  final String picture;
  final String level;

  Digimon({
    required this.name,
    required this.picture,
    required this.level,
  });

  factory Digimon.fromJson(Map<String, dynamic> json) {
    return Digimon(
      name: json['name'],
      picture: json['img'],
      level: json['level'],
    );
  }
}