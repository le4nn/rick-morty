import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/characters_viewmodel.dart';
import 'characters_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const CharactersScreen();
      case 1:
        return const FavoritesScreen();
      default:
        return const CharactersScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            context.read<FavoritesViewModel>().refresh();
          } else if (index == 0) {
            context.read<CharactersViewModel>().updateFavoriteStatus();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
