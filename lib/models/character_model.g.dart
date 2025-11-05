part of 'character_model.dart';

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 0;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      id: fields[0] as int,
      name: fields[1] as String,
      status: fields[2] as String,
      species: fields[3] as String,
      type: fields[4] as String,
      gender: fields[5] as String,
      origin: fields[6] as CharacterLocation,
      location: fields[7] as CharacterLocation,
      image: fields[8] as String,
      episode: (fields[9] as List).cast<String>(),
      url: fields[10] as String,
      created: fields[11] as String,
      isFavorite: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.species)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.origin)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.image)
      ..writeByte(9)
      ..write(obj.episode)
      ..writeByte(10)
      ..write(obj.url)
      ..writeByte(11)
      ..write(obj.created)
      ..writeByte(12)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CharacterLocationAdapter extends TypeAdapter<CharacterLocation> {
  @override
  final int typeId = 1;

  @override
  CharacterLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterLocation(
      name: fields[0] as String,
      url: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterLocation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
