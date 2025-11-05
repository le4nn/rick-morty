import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ricky_and_morty/core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../viewmodels/characters_viewmodel.dart';
import 'widgets/character_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesViewModel>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by',
            onSelected: (option) {
              context.read<FavoritesViewModel>().setSortOption(option);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.name,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: AppConstants.spacingS),
                    Text('Sort by Name'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.status,
                child: Row(
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(width: AppConstants.spacingS),
                    Text('Sort by Status'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.species,
                child: Row(
                  children: [
                    Icon(Icons.category),
                    SizedBox(width: AppConstants.spacingS),
                    Text('Sort by Species'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<FavoritesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border,
                    size: 80,
                    color: AppColors.unknown,
                  ),
                  const SizedBox(height: AppConstants.spacingL),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  Text(
                    'Add characters to favorites to see them here',
                    style: TextStyle(color: AppColors.favoriteInactive),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: viewModel.favorites.length,
            itemBuilder: (context, index) {
              final character = viewModel.favorites[index];
              return CharacterCard(
                character: character,
                onFavoriteToggle: () async {
                  await viewModel.removeFromFavorites(character);
                  if (context.mounted) {
                    context.read<CharactersViewModel>().updateFavoriteStatus();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
