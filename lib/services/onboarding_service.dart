import 'preferences_service.dart';

class OnboardingService {
  static const String _onboardingCompletedKey = 'onboarding_completed';

  /// Check if the user has completed onboarding
  static Future<bool> isOnboardingCompleted() async {
    try {
      return await PreferencesService.getBoolOrDefault(
          _onboardingCompletedKey, false);
    } catch (e) {
      // If there's an error, assume onboarding is not completed
      return false;
    }
  }

  /// Mark onboarding as completed
  static Future<void> completeOnboarding() async {
    try {
      await PreferencesService.setBool(_onboardingCompletedKey, true);
    } catch (e) {
      // Handle error silently - worst case, user sees onboarding again
    }
  }

  /// Reset onboarding status (useful for testing or settings)
  static Future<void> resetOnboarding() async {
    try {
      await PreferencesService.remove(_onboardingCompletedKey);
    } catch (e) {
      // Handle error silently
    }
  }
}
