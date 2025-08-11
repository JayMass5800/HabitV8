# Contributing to HabitV8

Thank you for your interest in contributing to HabitV8! We welcome contributions from the community and are excited to work with you to make HabitV8 even better.

## Table of Contents
1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [How to Contribute](#how-to-contribute)
4. [Development Setup](#development-setup)
5. [Coding Standards](#coding-standards)
6. [Submitting Changes](#submitting-changes)
7. [Issue Guidelines](#issue-guidelines)
8. [Pull Request Process](#pull-request-process)
9. [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

### Our Pledge
We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards
Examples of behavior that contributes to creating a positive environment include:
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

### Enforcement
Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by contacting the project team at conduct@habitv8.app.

## Getting Started

### Prerequisites
Before you begin, ensure you have:
- Flutter SDK 3.8.1 or higher
- Dart SDK (included with Flutter)
- Git for version control
- A code editor (VS Code or Android Studio recommended)
- Basic knowledge of Flutter and Dart

### First Contribution
Looking for a good first issue? Check out issues labeled with:
- `good first issue` - Perfect for newcomers
- `help wanted` - We need community help on these
- `documentation` - Help improve our docs
- `bug` - Fix existing issues

## How to Contribute

There are many ways to contribute to HabitV8:

### 🐛 Bug Reports
Found a bug? Help us fix it by:
1. Checking if the issue already exists
2. Creating a detailed bug report
3. Including steps to reproduce
4. Providing system information

### 💡 Feature Requests
Have an idea for a new feature?
1. Check existing feature requests
2. Create a detailed feature request
3. Explain the use case and benefits
4. Discuss implementation approaches

### 📝 Documentation
Help improve our documentation:
- Fix typos and grammar
- Add missing information
- Create tutorials and guides
- Improve code comments

### 🔧 Code Contributions
Contribute code improvements:
- Bug fixes
- New features
- Performance improvements
- Code refactoring
- Test coverage improvements

### 🎨 Design Contributions
Help with design and UX:
- UI/UX improvements
- Icon and asset creation
- Accessibility enhancements
- Design system improvements

## Development Setup

### 1. Fork and Clone
```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/habitv8.git
cd habitv8
```

### 2. Set Up Development Environment
```bash
# Install dependencies
flutter pub get

# Generate code (for Hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests to ensure everything works
flutter test
```

### 3. Create a Branch
```bash
# Create a new branch for your feature/fix
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-number
```

### 4. Set Up IDE
**VS Code Extensions:**
- Flutter
- Dart
- Flutter Riverpod Snippets
- Error Lens
- GitLens

**Android Studio Plugins:**
- Flutter
- Dart
- Riverpod Snippets

## Coding Standards

### Dart Style Guide
We follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) with these additions:

### Code Formatting
- Use `dart format` to format your code
- Maximum line length: 80 characters
- Use trailing commas for better diffs
- Follow Flutter's widget formatting conventions

### Naming Conventions
- **Files**: `snake_case` (e.g., `habit_service.dart`)
- **Classes**: `PascalCase` (e.g., `HabitService`)
- **Variables/Functions**: `camelCase` (e.g., `habitList`)
- **Constants**: `SCREAMING_SNAKE_CASE` (e.g., `DEFAULT_TIMEOUT`)

### Documentation
- Document all public APIs
- Use `///` for documentation comments
- Include examples for complex functions
- Keep comments up to date with code changes

### Example Code Style
```dart
/// Service for managing habit operations.
/// 
/// This service provides methods for creating, updating, and deleting habits,
/// as well as tracking habit completions.
/// 
/// Example:
/// ```dart
/// final habitService = HabitService();
/// final habit = await habitService.createHabit(
///   name: 'Drink Water',
///   frequency: HabitFrequency.daily,
/// );
/// ```
class HabitService {
  /// Creates a new habit with the given parameters.
  Future<Habit> createHabit({
    required String name,
    required HabitFrequency frequency,
    String? description,
  }) async {
    // Implementation
  }
}
```

### Testing Standards
- Write tests for all new functionality
- Maintain or improve test coverage
- Use descriptive test names
- Follow the AAA pattern (Arrange, Act, Assert)

```dart
group('HabitService', () {
  test('should create habit with valid parameters', () async {
    // Arrange
    final service = HabitService();
    const habitName = 'Test Habit';
    
    // Act
    final result = await service.createHabit(name: habitName);
    
    // Assert
    expect(result.name, equals(habitName));
    expect(result.id, isNotEmpty);
  });
});
```

## Submitting Changes

### Before Submitting
1. **Run Tests**: Ensure all tests pass
   ```bash
   flutter test
   ```

2. **Format Code**: Format your code
   ```bash
   dart format .
   ```

3. **Analyze Code**: Check for issues
   ```bash
   flutter analyze
   ```

4. **Update Documentation**: Update relevant documentation

### Commit Messages
Use clear, descriptive commit messages following this format:

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(habits): add habit completion analytics

- Implement streak calculation
- Add success rate computation
- Create trend analysis functions

Closes #123

fix(notifications): resolve notification scheduling bug

The notification service was not properly handling timezone changes.
This fix ensures notifications are scheduled in the correct timezone.

Fixes #456
```

## Issue Guidelines

### Bug Reports
When reporting bugs, please include:

**Template:**
```markdown
## Bug Description
A clear description of what the bug is.

## Steps to Reproduce
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Screenshots
If applicable, add screenshots.

## Environment
- Device: [e.g. iPhone 12, Pixel 5]
- OS: [e.g. iOS 15.0, Android 12]
- App Version: [e.g. 1.0.0]
- Flutter Version: [e.g. 3.8.1]

## Additional Context
Any other context about the problem.
```

### Feature Requests
When requesting features, please include:

**Template:**
```markdown
## Feature Description
A clear description of the feature you'd like to see.

## Problem Statement
What problem does this feature solve?

## Proposed Solution
How do you envision this feature working?

## Alternatives Considered
What alternatives have you considered?

## Additional Context
Any other context, mockups, or examples.
```

## Pull Request Process

### 1. Create Pull Request
- Use a clear, descriptive title
- Reference related issues
- Provide detailed description of changes
- Include screenshots for UI changes

### 2. Pull Request Template
```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issues
Closes #123

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots of UI changes.

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

### 3. Review Process
1. **Automated Checks**: CI/CD pipeline runs tests and analysis
2. **Code Review**: Maintainers review your code
3. **Feedback**: Address any requested changes
4. **Approval**: Once approved, your PR will be merged

### 4. After Merge
- Delete your feature branch
- Pull latest changes to your fork
- Consider contributing to related issues

## Community

### Communication Channels
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General discussions and questions
- **Email**: dev@habitv8.app for development questions

### Getting Help
- Check existing issues and discussions
- Read the documentation
- Ask questions in GitHub Discussions
- Contact maintainers via email

### Recognition
Contributors are recognized in:
- CHANGELOG.md for significant contributions
- GitHub contributors list
- Special mentions in release notes
- Community highlights

## Development Guidelines

### Architecture Principles
- **Local-First**: All data stored locally
- **Privacy-Focused**: No unnecessary data collection
- **Cross-Platform**: Consistent experience across platforms
- **Accessible**: Inclusive design for all users
- **Performant**: Smooth, responsive user experience

### Code Organization
```
lib/
├── data/           # Data layer (repositories, database)
├── domain/         # Business logic (models, entities)
├── services/       # Application services
└── ui/            # Presentation layer (screens, widgets)
```

### State Management
- Use Riverpod for state management
- Follow provider patterns
- Minimize widget rebuilds
- Handle loading and error states

### Testing Strategy
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows
- Aim for 80%+ code coverage

## Release Process

### Version Management
- Follow Semantic Versioning (SemVer)
- Update CHANGELOG.md for each release
- Tag releases in Git

### Release Types
- **Patch** (1.0.1): Bug fixes
- **Minor** (1.1.0): New features, backward compatible
- **Major** (2.0.0): Breaking changes

## Legal

### License
By contributing to HabitV8, you agree that your contributions will be licensed under the MIT License.

### Copyright
- You retain copyright of your contributions
- You grant us a license to use your contributions
- Ensure you have rights to contribute any code

### Third-Party Code
- Only include code you have rights to contribute
- Properly attribute third-party code
- Ensure compatible licenses

## Questions?

If you have questions about contributing:
- Check our [FAQ](FAQ.md)
- Browse [GitHub Discussions](https://github.com/habitv8/habitv8/discussions)
- Email us at dev@habitv8.app

Thank you for contributing to HabitV8! 🚀