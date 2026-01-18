/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Blur';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl =
      'https://api.blur.app'; // TODO: Update with real API
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'current_user';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';

  // RevenueCat
  static const String revenueCatApiKeyIos = ''; // TODO: Add iOS API key
  static const String revenueCatApiKeyAndroid = ''; // TODO: Add Android API key

  // Remote Config Defaults
  static const int minAppVersion = 1;
  static const bool forceUpdate = false;

  // Chat Constants
  static const int maxMessageLength = 1000;
  static const int maxPhotos = 6;
  static const int maxPrivatePhotos = 3;

  // Validation
  static const int minAge = 18;
  static const int maxAge = 100;
  static const int minBioLength = 0;
  static const int maxBioLength = 500;
}
