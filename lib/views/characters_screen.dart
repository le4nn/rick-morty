import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../viewmodels/characters_viewmodel.dart';
import '../viewmodels/favorites_viewmodel.dart';
import '../core/constants/app_constants.dart';
import 'widgets/character_card.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * AppConstants.scrollThreshold) {
      final viewModel = context.read<CharactersViewModel>();
      viewModel.loadMoreCharacters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
        centerTitle: true,
      ),
      body: Consumer<CharactersViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.characters.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.error != null && viewModel.characters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: AppConstants.spacingL),
                  Text(
                    'Error loading characters',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXXL),
                    child: Text(
                      viewModel.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingL),
                  ElevatedButton.icon(
                    onPressed: () => viewModel.refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.characters.isEmpty) {
            return const Center(
              child: Text('No characters found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.refresh(),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: viewModel.characters.length + 1,
              itemBuilder: (context, index) {
                if (index == viewModel.characters.length) {
                  if (viewModel.isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (!viewModel.hasMorePages) {
                    return Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingL),
                      child: Center(
                        child: Text(
                          'No more characters',
                          style: TextStyle(color: AppColors.favoriteInactive),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final character = viewModel.characters[index];
                return CharacterCard(
                  character: character,
                  onFavoriteToggle: () async {
                    await viewModel.toggleFavorite(character);
                    if (context.mounted) {
                      context.read<FavoritesViewModel>().refresh();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
