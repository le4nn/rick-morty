class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const String characterEndpoint = '/character';
  
  // Hive
  static const String charactersBox = 'characters';
  static const String favoritesBox = 'favorites';
  
  // Pagination
  static const double scrollThreshold = 0.9;
  
  // UI
  static const double cardElevation = 4.0;
  static const double cardBorderRadius = 12.0;
  static const double imageBorderRadius = 8.0;
  static const double characterImageSize = 100.0;
  static const double characterDetailImageSize = 200.0;
  static const double statusIndicatorSize = 10.0;
  static const double favoriteIconSize = 28.0;
  
  // Animation
  static const int animationDuration = 300;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 24.0;
  static const double spacingXXL = 32.0;
}
