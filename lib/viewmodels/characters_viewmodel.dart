import 'package:flutter/foundation.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';

class CharactersViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final HiveService _hiveService = HiveService();

  List<Character> _characters = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMorePages = true;

  List<Character> get characters => _characters;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMorePages => _hasMorePages;

  CharactersViewModel() {
    _loadCachedCharacters();
    loadCharacters();
  }

  void _loadCachedCharacters() {
    _characters = _hiveService.getCharacters();
    if (_characters.isNotEmpty) {
      notifyListeners();
    }
  }

  Future<void> loadCharacters({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _characters.clear();
      _hasMorePages = true;
    }

    if (_isLoading || _isLoadingMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getCharacters(page: _currentPage);
      final List<Character> newCharacters = result['characters'];
      final info = result['info'];

      final favoriteIds = _hiveService.getFavoriteIds();
      for (var character in newCharacters) {
        character.isFavorite = favoriteIds.contains(character.id);
      }

      if (refresh) {
        _characters = newCharacters;
      } else {
        _characters.addAll(newCharacters);
      }

      _hasMorePages = info['next'] != null;

      await _hiveService.saveCharacters(newCharacters);
    } catch (e) {
      _error = e.toString();
      if (_characters.isEmpty) {
        _loadCachedCharacters();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreCharacters() async {
    if (_isLoadingMore || !_hasMorePages || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final result = await _apiService.getCharacters(page: _currentPage);
      final List<Character> newCharacters = result['characters'];
      final info = result['info'];

      final favoriteIds = _hiveService.getFavoriteIds();
      for (var character in newCharacters) {
        character.isFavorite = favoriteIds.contains(character.id);
      }

      _characters.addAll(newCharacters);
      _hasMorePages = info['next'] != null;

      await _hiveService.saveCharacters(newCharacters);
    } catch (e) {
      _error = e.toString();
      _currentPage--;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Character character) async {
    try {
      if (character.isFavorite) {
        await _hiveService.removeFromFavorites(character.id);
      } else {
        await _hiveService.addToFavorites(character.id);
      }

      final index = _characters.indexWhere((c) => c.id == character.id);
      if (index != -1) {
        _characters[index].isFavorite = !character.isFavorite;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadCharacters(refresh: true);
  }

  void updateFavoriteStatus() {
    final favoriteIds = _hiveService.getFavoriteIds();
    for (var character in _characters) {
      character.isFavorite = favoriteIds.contains(character.id);
    }
    notifyListeners();
  }
}
