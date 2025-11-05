import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/character_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onFavoriteToggle;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onFavoriteToggle,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return AppColors.alive;
      case 'dead':
        return AppColors.dead;
      default:
        return AppColors.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingL,
        vertical: AppConstants.spacingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        onTap: () {
          _showCharacterDetails(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character Image
              Hero(
                tag: 'character_${character.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.imageBorderRadius),
                  child: CachedNetworkImage(
                    imageUrl: character.image,
                    width: AppConstants.characterImageSize,
                    height: AppConstants.characterImageSize,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: AppConstants.characterImageSize,
                      height: AppConstants.characterImageSize,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: AppConstants.characterImageSize,
                      height: AppConstants.characterImageSize,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              // Character Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.spacingXS),
                    Row(
                      children: [
                        Container(
                          width: AppConstants.statusIndicatorSize,
                          height: AppConstants.statusIndicatorSize,
                          decoration: BoxDecoration(
                            color: _getStatusColor(character.status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingXS + 2),
                        Text(
                          '${character.status} - ${character.species}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'Last known location:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      character.location.name,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Favorite Button
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: AppConstants.animationDuration),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    character.isFavorite ? Icons.star : Icons.star_border,
                    key: ValueKey(character.isFavorite),
                    color: character.isFavorite 
                        ? AppColors.favoriteActive 
                        : AppColors.favoriteInactive,
                    size: AppConstants.favoriteIconSize,
                  ),
                ),
                onPressed: onFavoriteToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCharacterDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppConstants.spacingL),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppConstants.spacingL),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Center(
                child: Hero(
                  tag: 'character_${character.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                    child: CachedNetworkImage(
                      imageUrl: character.image,
                      width: AppConstants.characterDetailImageSize,
                      height: AppConstants.characterDetailImageSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingL),
              Text(
                character.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingXL),
              _buildDetailRow('Status', character.status),
              _buildDetailRow('Species', character.species),
              _buildDetailRow('Gender', character.gender),
              if (character.type.isNotEmpty)
                _buildDetailRow('Type', character.type),
              _buildDetailRow('Origin', character.origin.name),
              _buildDetailRow('Location', character.location.name),
              _buildDetailRow('Episodes', character.episode.length.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
