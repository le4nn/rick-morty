import 'package:hive_flutter/hive_flutter.dart';
import '../models/character_model.dart';
import '../core/constants/app_constants.dart';

class HiveService {

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(CharacterLocationAdapter());
    await Hive.openBox<Character>(AppConstants.charactersBox);
    await Hive.openBox<int>(AppConstants.favoritesBox);
  }

  Future<void> saveCharacters(List<Character> characters) async {
    final box = Hive.box<Character>(AppConstants.charactersBox);
    for (var character in characters) {
      await box.put(character.id, character);
    }
  }

  List<Character> getCharacters() {
    final box = Hive.box<Character>(AppConstants.charactersBox);
    return box.values.toList();
  }

  Future<void> updateCharacter(Character character) async {
    final box = Hive.box<Character>(AppConstants.charactersBox);
    await box.put(character.id, character);
  }

  Character? getCharacterById(int id) {
    final box = Hive.box<Character>(AppConstants.charactersBox);
    return box.get(id);
  }

  Future<void> addToFavorites(int characterId) async {
    final box = Hive.box<int>(AppConstants.favoritesBox);
    if (!box.values.contains(characterId)) {
      await box.add(characterId);
    }
    
    final character = getCharacterById(characterId);
    if (character != null) {
      character.isFavorite = true;
      await updateCharacter(character);
    }
  }

  Future<void> removeFromFavorites(int characterId) async {
    final box = Hive.box<int>(AppConstants.favoritesBox);
    final key = box.keys.firstWhere(
      (key) => box.get(key) == characterId,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
    }

    final character = getCharacterById(characterId);
    if (character != null) {
      character.isFavorite = false;
      await updateCharacter(character);
    }
  }

  List<int> getFavoriteIds() {
    final box = Hive.box<int>(AppConstants.favoritesBox);
    return box.values.toList();
  }

  List<Character> getFavoriteCharacters() {
    final favoriteIds = getFavoriteIds();
    final box = Hive.box<Character>(AppConstants.charactersBox);
    return favoriteIds
        .map((id) => box.get(id))
        .where((character) => character != null)
        .cast<Character>()
        .toList();
  }

  bool isFavorite(int characterId) {
    final box = Hive.box<int>(AppConstants.favoritesBox);
    return box.values.contains(characterId);
  }

  Future<void> clearAll() async {
    await Hive.box<Character>(AppConstants.charactersBox).clear();
    await Hive.box<int>(AppConstants.favoritesBox).clear();
  }
}
