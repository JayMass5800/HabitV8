# HabitV8 🚀

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1+-blue.svg)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)](https://flutter.dev/)

**Transform your life one habit at a time with HabitV8** - the intelligent habit tracking app that combines cutting-edge AI technology with beautiful design to help you build lasting positive changes.

## ✨ Features

### 🧠 **AI-Powered Insights**
- Smart recommendations based on your completion patterns
- Optimal timing suggestions for habit execution
- Trend analysis and pattern recognition
- Personalized tips for habit improvement
- Machine learning-powered completion predictions

### 📊 **Comprehensive Tracking**
- Create unlimited habits with flexible frequencies (hourly to yearly)
- Visual progress tracking with beautiful charts and graphs
- Streak tracking with current and best streak records
- Success rate calculations and analytics
- Timeline view of your entire habit journey

### 🔔 **Smart Notifications**
- Intelligent reminder system that adapts to your schedule
- Customizable notification schedules and messages
- Persistent notifications across device restarts
- Quiet hours and focus time respect
- Context-aware reminder content

### 📅 **Calendar Integration**
- Seamlessly integrate with your device calendar
- Visual calendar view of habit completions
- Monthly and weekly progress visualization
- Historical data in calendar format

###  **Beautiful Design**
- Modern Material Design 3 interface
- Dark and light theme support
- Smooth animations and transitions
- Intuitive navigation and user experience
- Responsive design for all screen sizes

### 🔒 **Privacy First**
- All data stored locally on your device
- No cloud dependency required
- Complete data ownership and control
- Encrypted local storage
- GDPR and privacy regulation compliant

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/habitv8/habitv8.git
   cd habitv8
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Platform Support

| Platform | Status | Version |
|----------|--------|---------|
| 🤖 Android | ✅ Supported | API 26+ |
| 🍎 iOS | ✅ Supported | iOS 12.0+ |
| 🌐 Web (PWA) | ✅ Supported | Modern browsers |
| 🪟 Windows | ✅ Supported | Windows 10+ |
| 🍎 macOS | ✅ Supported | macOS 10.14+ |
| 🐧 Linux | ✅ Supported | Ubuntu 18.04+ |

## 🏗️ Architecture

HabitV8 follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── data/           # Data layer (Hive database, repositories)
├── domain/         # Business logic (models, entities)
├── services/       # Application services
└── ui/            # Presentation layer (screens, widgets)
```

### Key Technologies
- **Flutter**: Cross-platform UI framework
- **Riverpod**: State management and dependency injection
- **Hive**: Local NoSQL database
- **GoRouter**: Declarative routing
- **FL Chart**: Beautiful data visualization
- **TensorFlow Lite**: On-device machine learning

## 🎯 Getting Started as a User

1. **Download HabitV8** from your platform's app store
2. **Complete the onboarding** to learn about key features
3. **Create your first habit** using the intuitive creation wizard
4. **Set up reminders** to stay on track
5. **Track your progress** and watch your streaks grow
6. **Analyze insights** to optimize your habit-building journey

## 🛠️ Development

### Building for Different Platforms

**Android**
```bash
flutter build apk --release
flutter build appbundle --release  # For Play Store
```

**iOS**
```bash
flutter build ios --release
```

**Web**
```bash
flutter build web --release
```

**Desktop**
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

### Running Tests
```bash
flutter test                    # Run all tests
flutter test --coverage        # Run with coverage
```

### Code Generation
```bash
# Generate Hive adapters and other generated code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and regenerate automatically
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 📊 Key Features in Detail

### Habit Management
- **Flexible Frequencies**: Daily, weekly, monthly, or custom patterns
- **Rich Descriptions**: Add detailed notes and context to your habits
- **Categories**: Organize habits by health, productivity, personal development, etc.
- **Color Coding**: Visual organization with customizable colors

### Progress Analytics
- **Completion Charts**: Visualize your progress over time
- **Streak Analysis**: Track current and best streaks
- **Success Rates**: Calculate and display completion percentages
- **Trend Identification**: Spot patterns in your habit completion

### AI-Powered Recommendations
- **Optimal Timing**: Discover the best times for your habits
- **Pattern Recognition**: Identify what makes you successful
- **Personalized Tips**: Get custom advice based on your data
- **Predictive Insights**: Anticipate challenges and opportunities

## 🔐 Privacy & Security

HabitV8 is built with privacy as a core principle:

- **Local Storage**: All data stays on your device
- **No Tracking**: We don't collect personal information
- **Encryption**: Local data is encrypted for security
- **Transparency**: Open source code for full transparency
- **Compliance**: GDPR, CCPA, and other privacy regulations

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

1. **Report Bugs**: Found an issue? Let us know!
2. **Suggest Features**: Have ideas for improvements?
3. **Submit Code**: Fix bugs or add new features
4. **Improve Docs**: Help make our documentation better

See our [Contributing Guide](CONTRIBUTING.md) for detailed information.

### Development Setup for Contributors

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and test thoroughly
4. Commit your changes: `git commit -m 'Add amazing feature'`
5. Push to the branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

## 📚 Documentation

- **[User Manual](USER_MANUAL.md)**: Complete guide for users
- **[Developer Guide](DEVELOPER_GUIDE.md)**: Technical documentation for developers
- **[API Documentation](API_DOCS.md)**: Service and component APIs
- **[Contributing Guide](CONTRIBUTING.md)**: How to contribute to the project
- **[Privacy Policy](PRIVACY_POLICY.md)**: Our privacy commitments
- **[Health Permissions Compliance](HEALTH_PERMISSIONS_COMPLIANCE.md)**: Health data privacy and compliance
- **[Terms of Service](TERMS_OF_SERVICE.md)**: Usage terms and conditions

## 🐛 Bug Reports & Feature Requests

Found a bug or have a feature request? We'd love to hear from you!

- **Bug Reports**: [Create an issue](https://github.com/habitv8/habitv8/issues/new?template=bug_report.md)
- **Feature Requests**: [Request a feature](https://github.com/habitv8/habitv8/issues/new?template=feature_request.md)
- **General Discussion**: [Join the discussion](https://github.com/habitv8/habitv8/discussions)

## 📈 Roadmap

### Version 1.1 (Coming Soon)
- [ ] Social features and habit sharing
- [ ] Advanced analytics dashboard
- [ ] Habit templates and community suggestions
- [ ] Enhanced accessibility features

### Version 1.2 (Future)
- [ ] Team and family habit tracking
- [ ] Integration with more health platforms
- [ ] Advanced customization options
- [ ] Habit coaching and guidance

## 🏆 Achievements & Recognition

- 🎯 **Privacy-First Design**: No personal data collection
- 🚀 **Cross-Platform Excellence**: Consistent experience across all platforms
- 🧠 **AI Innovation**: On-device machine learning for personalized insights
- 🎨 **Design Excellence**: Beautiful, intuitive user interface
- 🔒 **Security Focus**: Encrypted local storage and secure practices

## 📞 Support & Community

### Get Help
- **Email Support**: support@habitv8.app
- **Documentation**: Comprehensive guides and tutorials
- **Community Forum**: Connect with other users
- **GitHub Issues**: Technical support and bug reports

### Stay Connected
- **Website**: [habitv8.app](https://habitv8.app)
- **GitHub**: [github.com/habitv8/habitv8](https://github.com/habitv8/habitv8)
- **Twitter**: [@habitv8app](https://twitter.com/habitv8app)
- **Newsletter**: Get updates on new features and tips

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Special thanks to:
- **Flutter Team**: For the amazing cross-platform framework
- **Riverpod Team**: For excellent state management
- **Hive Team**: For efficient local storage
- **Open Source Community**: For the incredible packages and tools
- **Beta Testers**: For valuable feedback and testing
- **Contributors**: Everyone who helps make HabitV8 better

## 📊 Project Stats

![GitHub stars](https://img.shields.io/github/stars/habitv8/habitv8?style=social)
![GitHub forks](https://img.shields.io/github/forks/habitv8/habitv8?style=social)
![GitHub issues](https://img.shields.io/github/issues/habitv8/habitv8)
![GitHub pull requests](https://img.shields.io/github/issues-pr/habitv8/habitv8)
![GitHub last commit](https://img.shields.io/github/last-commit/habitv8/habitv8)

---

**Ready to transform your life?** Download HabitV8 today and start building the habits that will change everything! 🌟

*Made with ❤️ by the HabitV8 team*