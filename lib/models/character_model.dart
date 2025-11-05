import 'package:hive/hive.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class Character extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String gender;

  @HiveField(6)
  final CharacterLocation origin;

  @HiveField(7)
  final CharacterLocation location;

  @HiveField(8)
  final String image;

  @HiveField(9)
  final List<String> episode;

  @HiveField(10)
  final String url;

  @HiveField(11)
  final String created;

  @HiveField(12)
  bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
    this.isFavorite = false,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'] ?? '',
      gender: json['gender'],
      origin: CharacterLocation.fromJson(json['origin']),
      location: CharacterLocation.fromJson(json['location']),
      image: json['image'],
      episode: List<String>.from(json['episode']),
      url: json['url'],
      created: json['created'],
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': origin.toJson(),
      'location': location.toJson(),
      'image': image,
      'episode': episode,
      'url': url,
      'created': created,
    };
  }

  Character copyWith({bool? isFavorite}) {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      origin: origin,
      location: location,
      image: image,
      episode: episode,
      url: url,
      created: created,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

@HiveType(typeId: 1)
class CharacterLocation {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  CharacterLocation({
    required this.name,
    required this.url,
  });

  factory CharacterLocation.fromJson(Map<String, dynamic> json) {
    return CharacterLocation(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}
