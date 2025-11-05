import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../core/constants/app_constants.dart';

class ApiService {
  Future<Map<String, dynamic>> getCharacters({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.characterEndpoint}/?page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Character> characters = (data['results'] as List)
            .map((json) => Character.fromJson(json))
            .toList();

        return {
          'characters': characters,
          'info': data['info'],
        };
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Error fetching characters: $e');
    }
  }

  Future<Character> getCharacterById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.characterEndpoint}/$id'),
      );

      if (response.statusCode == 200) {
        return Character.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load character');
      }
    } catch (e) {
      throw Exception('Error fetching character: $e');
    }
  }
}
