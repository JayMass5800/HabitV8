# HabitV8 Developer Guide

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Development Setup](#development-setup)
4. [Building and Deployment](#building-and-deployment)
5. [Code Structure](#code-structure)
6. [Key Components](#key-components)
7. [Database Schema](#database-schema)
8. [API Documentation](#api-documentation)
9. [Testing](#testing)
10. [Contributing](#contributing)
11. [Release Process](#release-process)

---

## Project Overview

### Technology Stack
- **Framework**: Flutter 3.8.1+
- **Language**: Dart
- **State Management**: Riverpod 2.5.1
- **Database**: Hive 2.2.3 (Local NoSQL)
- **Navigation**: GoRouter 16.1.0
- **Charts**: FL Chart 1.0.0
- **AI/ML**: TensorFlow Lite 0.11.0
- **Notifications**: Flutter Local Notifications 18.0.1

### Supported Platforms
- Android (API 26+)
- iOS (12.0+)
- Web (PWA)
- Windows Desktop
- macOS Desktop
- Linux Desktop

### Key Features
- Local-first data storage
- AI-powered insights and recommendations
- Cross-platform compatibility
- Health and calendar integration
- Smart notification system
- Comprehensive analytics

---

## Architecture

### Overall Architecture Pattern
HabitV8 follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── data/           # Data layer (Hive database, repositories)
├── domain/         # Business logic (models, entities)
├── services/       # Application services
└── ui/            # Presentation layer (screens, widgets)
```

### State Management
- **Riverpod**: Primary state management solution
- **Provider Pattern**: For dependency injection
- **Local State**: StatefulWidget for UI-specific state

### Data Flow
1. UI triggers actions through Riverpod providers
2. Providers call service methods
3. Services interact with data repositories
4. Repositories manage Hive database operations
5. State updates propagate back to UI

---

## Development Setup

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions
- Git for version control

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/habitv8/habitv8.git
   cd habitv8
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the Application**
   ```bash
   flutter run
   ```

### IDE Configuration

**VS Code Extensions**
- Flutter
- Dart
- Flutter Riverpod Snippets
- Error Lens
- GitLens

**Android Studio Plugins**
- Flutter
- Dart
- Riverpod Snippets

### Environment Variables
Create a `.env` file in the project root:
```
ENVIRONMENT=development
DEBUG_MODE=true
ANALYTICS_ENABLED=false
```

---

## Building and Deployment

### Development Builds

**Android Debug**
```bash
flutter build apk --debug
```

**iOS Debug**
```bash
flutter build ios --debug
```

**Web Debug**
```bash
flutter build web --debug
```

### Release Builds

**Android Release**
```bash
flutter build apk --release
flutter build appbundle --release  # For Play Store
```

**iOS Release**
```bash
flutter build ios --release
```

**Web Release**
```bash
flutter build web --release --web-renderer canvaskit
```

**Desktop Releases**
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

### Code Signing

**Android**
1. Create keystore: `keytool -genkey -v -keystore habitv8-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias habitv8`
2. Configure in `android/key.properties`
3. Update `android/app/build.gradle.kts`

**iOS**
1. Configure signing in Xcode
2. Set up provisioning profiles
3. Configure in `ios/Runner.xcodeproj`

---

## Code Structure

### Directory Structure
```
lib/
├── data/
│   ├── database.dart              # Hive database setup
│   └── repositories/              # Data repositories
├── domain/
│   └── model/                     # Data models and entities
│       ├── habit.dart
│       ├── habit_completion.dart
│       └── user_preferences.dart
├── services/                      # Business logic services
│   ├── habit_stats_service.dart
│   ├── notification_service.dart
│   ├── smart_recommendations_service.dart
│   └── theme_service.dart
└── ui/                           # User interface
    ├── screens/                  # Full-screen views
    ├── widgets/                  # Reusable UI components
    └── home_screen.dart         # Main application screen
```

### Naming Conventions
- **Files**: snake_case (e.g., `habit_stats_service.dart`)
- **Classes**: PascalCase (e.g., `HabitStatsService`)
- **Variables**: camelCase (e.g., `habitCompletions`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `DEFAULT_REMINDER_TIME`)

### Code Style
- Follow Dart style guide
- Use `flutter_lints` for code analysis
- Maximum line length: 80 characters
- Use trailing commas for better diffs

---

## Key Components

### Data Models

**Habit Model**
```dart
@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  HabitFrequency frequency;
  
  @HiveField(4)
  DateTime createdAt;
  
  @HiveField(5)
  bool isActive;
}
```

**Habit Completion Model**
```dart
@HiveType(typeId: 1)
class HabitCompletion extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String habitId;
  
  @HiveField(2)
  DateTime completedAt;
  
  @HiveField(3)
  bool isCompleted;
  
  @HiveField(4)
  double? value;
}
```

### Services

**Notification Service**
- Manages local notifications
- Handles scheduling and cancellation
- Integrates with platform notification systems

**Smart Recommendations Service**
- Uses TensorFlow Lite for ML predictions
- Analyzes habit patterns
- Provides personalized insights

**Habit Stats Service**
- Calculates streaks and success rates
- Generates analytics data
- Provides trend analysis

### UI Components

**Habit Card Widget**
- Displays individual habit information
- Handles completion toggling
- Shows progress indicators

**Progress Chart Widget**
- Renders habit progress charts
- Supports multiple chart types
- Interactive data visualization

---

## Database Schema

### Hive Boxes
HabitV8 uses several Hive boxes for data storage:

**Habits Box** (`habits`)
- Stores all habit definitions
- Key: Habit ID (String)
- Value: Habit object

**Completions Box** (`completions`)
- Stores habit completion records
- Key: Completion ID (String)
- Value: HabitCompletion object

**Preferences Box** (`preferences`)
- Stores user preferences and settings
- Key: Preference name (String)
- Value: Dynamic preference value

**Cache Box** (`cache`)
- Stores temporary data and computed values
- Key: Cache key (String)
- Value: Cached data

### Data Relationships
```
Habit (1) ←→ (Many) HabitCompletion
User Preferences ←→ App Settings
Cache ←→ Computed Analytics
```

### Migration Strategy
- Version-based migrations
- Backward compatibility maintenance
- Data integrity validation

---

## API Documentation

### Core Services API

**HabitService**
```dart
class HabitService {
  Future<List<Habit>> getAllHabits();
  Future<Habit> createHabit(CreateHabitRequest request);
  Future<Habit> updateHabit(String id, UpdateHabitRequest request);
  Future<void> deleteHabit(String id);
  Future<void> toggleHabitCompletion(String habitId, DateTime date);
}
```

**StatsService**
```dart
class StatsService {
  Future<HabitStats> getHabitStats(String habitId);
  Future<OverallStats> getOverallStats();
  Future<List<TrendData>> getTrendData(String habitId, DateRange range);
}
```

**NotificationService**
```dart
class NotificationService {
  Future<void> scheduleNotification(NotificationRequest request);
  Future<void> cancelNotification(String notificationId);
  Future<void> cancelAllNotifications();
  Future<List<PendingNotification>> getPendingNotifications();
}
```

### Data Transfer Objects

**CreateHabitRequest**
```dart
class CreateHabitRequest {
  final String name;
  final String description;
  final HabitFrequency frequency;
  final List<NotificationTime> reminders;
  final String category;
  final Color color;
}
```

---

## Testing

### Test Structure
```
test/
├── unit/                    # Unit tests
│   ├── services/
│   ├── models/
│   └── utils/
├── widget/                  # Widget tests
│   ├── screens/
│   └── widgets/
└── integration/             # Integration tests
    └── app_test.dart
```

### Running Tests

**All Tests**
```bash
flutter test
```

**Specific Test File**
```bash
flutter test test/unit/services/habit_service_test.dart
```

**Coverage Report**
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Test Guidelines
- Aim for 80%+ code coverage
- Mock external dependencies
- Test both success and failure scenarios
- Use descriptive test names

### Example Test
```dart
group('HabitService', () {
  late HabitService habitService;
  late MockHabitRepository mockRepository;

  setUp(() {
    mockRepository = MockHabitRepository();
    habitService = HabitService(mockRepository);
  });

  test('should create habit successfully', () async {
    // Arrange
    final request = CreateHabitRequest(name: 'Test Habit');
    final expectedHabit = Habit(id: '1', name: 'Test Habit');
    
    when(mockRepository.create(any))
        .thenAnswer((_) async => expectedHabit);

    // Act
    final result = await habitService.createHabit(request);

    // Assert
    expect(result, equals(expectedHabit));
    verify(mockRepository.create(any)).called(1);
  });
});
```

---

## Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make changes and commit: `git commit -m "Add new feature"`
4. Push to branch: `git push origin feature/new-feature`
5. Create a Pull Request

### Code Review Process
1. All changes require code review
2. Automated tests must pass
3. Code coverage must not decrease
4. Follow coding standards
5. Update documentation as needed

### Commit Message Format
```
type(scope): description

[optional body]

[optional footer]
```

**Types**: feat, fix, docs, style, refactor, test, chore

**Example**:
```
feat(habits): add habit completion analytics

- Add streak calculation logic
- Implement success rate computation
- Create trend analysis functions

Closes #123
```

---

## Release Process

### Version Management
- Follow Semantic Versioning (SemVer)
- Update version in `pubspec.yaml`
- Tag releases in Git

### Release Checklist
- [ ] Update version numbers
- [ ] Run full test suite
- [ ] Update CHANGELOG.md
- [ ] Build release artifacts
- [ ] Test on all target platforms
- [ ] Update store listings
- [ ] Create release notes
- [ ] Tag and push release

### Deployment Pipeline
1. **Development**: Continuous integration on feature branches
2. **Staging**: Deploy to internal testing environment
3. **Production**: Deploy to app stores and web

### Store Deployment

**Google Play Store**
1. Build signed AAB: `flutter build appbundle --release`
2. Upload to Play Console
3. Update store listing
4. Submit for review

**Apple App Store**
1. Build iOS release: `flutter build ios --release`
2. Archive in Xcode
3. Upload to App Store Connect
4. Submit for review

**Web Deployment**
1. Build web release: `flutter build web --release`
2. Deploy to hosting service
3. Update PWA manifest
4. Test offline functionality

---

## Performance Optimization

### Best Practices
- Use `const` constructors where possible
- Implement proper widget disposal
- Optimize image assets
- Use lazy loading for large lists
- Profile memory usage regularly

### Database Optimization
- Index frequently queried fields
- Batch database operations
- Use appropriate data types
- Regular database maintenance

### UI Performance
- Minimize widget rebuilds
- Use `RepaintBoundary` for complex widgets
- Optimize animations
- Implement proper scrolling performance

---

## Security Considerations

### Data Protection
- Local data encryption with Hive
- Secure key storage
- No sensitive data in logs
- Regular security audits

### Permissions
- Request minimal necessary permissions
- Explain permission usage to users
- Handle permission denials gracefully
- Regular permission audits

### Privacy
- No data collection without consent
- Local-first architecture
- Transparent privacy policy
- GDPR compliance

---

## Troubleshooting

### Common Development Issues

**Build Failures**
- Clean build: `flutter clean && flutter pub get`
- Regenerate code: `flutter pub run build_runner build --delete-conflicting-outputs`
- Check Flutter version compatibility

**Database Issues**
- Clear Hive boxes during development
- Check type adapter registration
- Verify data model changes

**Platform-Specific Issues**
- Check platform-specific configurations
- Verify permissions in manifest files
- Test on physical devices

### Debug Tools
- Flutter Inspector for UI debugging
- Dart DevTools for performance profiling
- Platform-specific debugging tools
- Custom logging with Logger package

---

## Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Riverpod Documentation](https://riverpod.dev)
- [Hive Documentation](https://docs.hivedb.dev)

### Community
- Flutter Discord
- Stack Overflow
- GitHub Discussions
- Reddit r/FlutterDev

### Tools
- [Flutter Inspector](https://flutter.dev/docs/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [FlutterFire](https://firebase.flutter.dev) (if Firebase integration added)

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Contact

For development questions or contributions:
- **Email**: dev@habitv8.app
- **GitHub**: https://github.com/habitv8/habitv8
- **Discord**: [Development Channel]

---

**Happy coding! 🚀**