import 'package:flutter/foundation.dart';
import '../models/character_model.dart';
import '../services/hive_service.dart';

enum SortOption {
  name,
  status,
  species,
}

class FavoritesViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  List<Character> _favorites = [];
  SortOption _currentSort = SortOption.name;

  List<Character> get favorites => _favorites;
  SortOption get currentSort => _currentSort;

  FavoritesViewModel() {
    loadFavorites();
  }

  void loadFavorites() {
    _favorites = _hiveService.getFavoriteCharacters();
    _sortFavorites();
    notifyListeners();
  }

  Future<void> removeFromFavorites(Character character) async {
    try {
      await _hiveService.removeFromFavorites(character.id);
      _favorites.removeWhere((c) => c.id == character.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
    }
  }

  void setSortOption(SortOption option) {
    _currentSort = option;
    _sortFavorites();
    notifyListeners();
  }

  void _sortFavorites() {
    switch (_currentSort) {
      case SortOption.name:
        _favorites.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.status:
        _favorites.sort((a, b) {
          final statusOrder = {'Alive': 0, 'Dead': 1, 'unknown': 2};
          return (statusOrder[a.status] ?? 3)
              .compareTo(statusOrder[b.status] ?? 3);
        });
        break;
      case SortOption.species:
        _favorites.sort((a, b) => a.species.compareTo(b.species));
        break;
    }
  }

  void refresh() {
    loadFavorites();
  }
}
