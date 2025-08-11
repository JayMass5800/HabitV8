import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingCompletedKey = 'onboarding_completed';

  /// Check if the user has completed onboarding
  static Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingCompletedKey) ?? false;
    } catch (e) {
      // If there's an error, assume onboarding is not completed
      return false;
    }
  }

  /// Mark onboarding as completed
  static Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
    } catch (e) {
      // Handle error silently - worst case, user sees onboarding again
    }
  }

  /// Reset onboarding status (useful for testing or settings)
  static Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingCompletedKey);
    } catch (e) {
      // Handle error silently
    }
  }
}