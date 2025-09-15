import 'package:flutter/material.dart';

/// A dialog widget that displays document content (Terms of Service, Privacy Policy, etc.)
/// with proper scrolling and a close button
class DocumentPopupDialog extends StatelessWidget {
  final String title;
  final String content;

  const DocumentPopupDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
        ),
        child: Column(
          children: [
            // Header with title and close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.primary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            // Bottom close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the Terms of Service dialog
  static Future<void> showTermsOfService(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const DocumentPopupDialog(
          title: 'Terms of Service',
          content: _termsOfServiceContent,
        );
      },
    );
  }

  /// Shows the Privacy Policy dialog
  static Future<void> showPrivacyPolicy(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const DocumentPopupDialog(
          title: 'Privacy Policy',
          content: _privacyPolicyContent,
        );
      },
    );
  }

  // Terms of Service content
  static const String _termsOfServiceContent = '''# Terms of Service for HabitV8

**Last Updated**: September 15, 2025  
**Effective Date**: September 15, 2025

## 1. Acceptance of Terms

By downloading, installing, accessing, or using HabitV8 ("the App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, do not download, install, or use the App.

These Terms constitute a legally binding agreement between you ("User," "you," or "your") and DapperCatsInc ("Company," "we," "our," or "us") regarding your use of the App.

## 2. Description of Service

### 2.1 App Overview
HabitV8 is a privacy-first habit tracking application designed to help users build and maintain positive habits through:

- **Habit Creation and Tracking**: Create, manage, and track unlimited personal habits
- **AI-Powered Insights**: Receive personalized recommendations and analytics
- **Progress Visualization**: View detailed charts, statistics, and progress reports
- **Smart Notifications**: Receive intelligent reminders and notifications
- **Health Integration**: Optional integration with device health platforms
- **Calendar Integration**: Optional synchronization with device calendar applications
- **Achievement System**: Earn rewards and track progress through gamification
- **Data Export**: Export personal data for backup or analysis purposes

### 2.2 Local Data Storage
The App operates using local data storage on your device. All habit data, preferences, and personal information are stored locally and are not transmitted to external servers unless you explicitly enable optional features that require external API access.

### 2.3 Optional Features
Certain features require explicit user consent and may involve limited data transmission:
- **External AI Services**: Optional integration with third-party AI APIs (user-provided API keys)
- **Calendar Integration**: Optional synchronization with device calendar applications

## 3. User Accounts and Registration

### 3.1 No Account Required
The App does not require user account registration or personal information collection. All functionality is available without creating an online account or providing personal details.

### 3.2 Device Security
You are responsible for:
- Maintaining the security of your device and access credentials
- Ensuring that unauthorized users cannot access your device or the App
- Protecting your device with appropriate security measures (passcode, biometric authentication, etc.)
- Safeguarding any API keys you choose to configure for optional external services

### 3.3 Data Responsibility
Since all data is stored locally on your device, you are responsible for:
- Creating backups of important habit data using the App's export features
- Protecting your device from loss, theft, or damage
- Understanding that uninstalling the App will permanently delete all local data

## 4. Acceptable Use

### 4.1 Permitted Uses
You may use the App to:
- Track personal habits and routines for self-improvement purposes
- View personal progress analytics and insights
- Export your own data for personal backup or analysis
- Customize the App according to your preferences and needs
- Share general feedback and suggestions for App improvement

### 4.2 Prohibited Uses
You may not use the App to:

#### Legal Violations
- Engage in any illegal activities or track habits that violate local, state, or federal laws
- Use the App in any manner that violates applicable laws or regulations
- Track activities related to illegal substance use or other criminal behavior

#### Technical Misuse
- Attempt to reverse engineer, decompile, or disassemble the App
- Modify, adapt, or create derivative works based on the App
- Bypass, disable, or interfere with security features or access controls
- Attempt to gain unauthorized access to other users' data or devices
- Use automated tools or scripts to interact with the App

#### Harmful Activities
- Use the App to track self-harm or dangerous behaviors
- Share or promote harmful content through any App features
- Attempt to use the App in ways that could harm other users or the service
- Use the App to violate the privacy or rights of others

#### Commercial Misuse
- Redistribute, sell, or sublicense the App without explicit permission
- Use the App for commercial purposes without appropriate licensing
- Incorporate the App into commercial products or services without permission

### 4.3 Health and Safety Disclaimer
The App is designed for general habit tracking and is not intended for:
- Medical diagnosis, treatment, or health advice
- Tracking critical medical regimens without professional oversight
- Emergency situations or time-sensitive health matters
- Replacement of professional medical or therapeutic services

## 5. Health and Medical Disclaimer

### 5.1 Not a Medical Device
**IMPORTANT**: HabitV8 is not a medical device and is not intended to diagnose, treat, cure, or prevent any disease or medical condition. The App is designed for general wellness and habit tracking purposes only.

### 5.2 Health Integration Limitations
If you choose to enable health platform integration:
- Health data is used solely for habit correlation and personal insights
- The App does not provide medical advice or health recommendations
- Health insights are for informational purposes only
- You should consult healthcare professionals for medical decisions

### 5.3 Medical Professional Consultation
You should consult with qualified healthcare professionals regarding:
- Any health-related habits or goals you wish to track
- Interpretation of health data or trends
- Changes to medication schedules or health routines
- Any health concerns or symptoms you may experience

### 5.4 Emergency Situations
The App is not designed for emergency situations. In case of medical emergencies, contact emergency services immediately rather than relying on the App.

### 5.5 Accuracy Disclaimer
While we strive for accuracy, we cannot guarantee that:
- Health data integration will be error-free or completely accurate
- Habit tracking data perfectly reflects actual behavior
- AI insights or recommendations are medically appropriate for your situation

## 6. Privacy and Data Protection

### 6.1 Privacy-First Design
Our privacy practices are detailed in our Privacy Policy, which is incorporated by reference into these Terms. Key principles include:
- All personal data stored locally on your device
- No collection of personal information by default
- Optional integrations require explicit user consent
- Complete user control over data access and sharing

### 6.2 Data Ownership
You retain complete ownership of all data created or stored through your use of the App, including:
- Habit information and completion records
- Personal preferences and settings
- Achievement and progress data
- Exported data files

### 6.3 Data Security
We implement appropriate technical and organizational measures to protect your data:
- Local encryption of sensitive data
- Secure storage using platform-approved methods
- Regular security updates and vulnerability assessments
- No unauthorized access to user data

### 6.4 Third-Party Services
If you choose to use optional third-party integrations:
- You are responsible for understanding third-party privacy policies
- We are not responsible for third-party data handling practices
- You can revoke third-party access at any time through App settings

## 7. Intellectual Property Rights

### 7.1 App Ownership
The App, including all software, algorithms, user interface designs, graphics, text, and other content, is owned by DapperCatsInc and is protected by copyright, trademark, and other intellectual property laws.

### 7.2 User License
Subject to these Terms, we grant you a limited, non-exclusive, non-transferable, revocable license to:
- Download and install the App on your personal devices
- Use the App for personal, non-commercial purposes
- Access App features and functionality as intended

### 7.3 License Restrictions
You may not:
- Copy, modify, or distribute the App or its components
- Create derivative works based on the App
- Use the App's branding, trademarks, or intellectual property
- Remove or modify copyright, trademark, or other proprietary notices

### 7.4 User Content
Any content you create within the App (habit names, descriptions, notes, etc.) remains your property. By using the App, you grant us a limited license to store and process this content locally on your device to provide App functionality.

### 7.5 Feedback and Suggestions
If you provide feedback, suggestions, or ideas about the App, you grant us the right to use such feedback to improve the App without compensation or attribution requirements.

## 8. App Updates and Modifications

### 8.1 Automatic Updates
The App may include features that check for and install updates automatically. You can control update preferences through your device settings or App store preferences.

### 8.2 Update Requirements
To maintain security and functionality, we may require that you install updates to continue using certain features or the entire App.

### 8.3 Service Modifications
We reserve the right to:
- Modify, update, or discontinue App features
- Change the user interface or user experience
- Add new features or functionality
- Remove features that are no longer supported

### 8.4 Backward Compatibility
We will make reasonable efforts to maintain backward compatibility and provide migration tools for your data when significant changes are made.

## 9. Disclaimers and Limitations of Liability

### 9.1 Service Availability
The App is provided "as is" and "as available." We do not guarantee that:
- The App will be available at all times or function without interruption
- All features will work perfectly on every device or operating system version
- The App will meet all of your specific requirements or expectations
- Data synchronization with third-party services will be error-free
- Third-party integrations will remain available or function consistently

### 9.2 Technical Limitations
We disclaim liability for:
- Device compatibility issues or operating system conflicts
- Data loss due to device failure, software bugs, or user error
- Performance issues related to device specifications or network connectivity
- Third-party service availability or functionality
- Accuracy of AI-generated insights or recommendations

### 9.3 Health and Medical Disclaimers
We specifically disclaim any responsibility for:
- Medical decisions made based on App data or insights
- Health outcomes resulting from habit tracking or behavior changes
- Accuracy of health data integration or analysis
- Compatibility with medical devices or treatments

## 10. Limitation of Liability

### 10.1 General Limitations
TO THE MAXIMUM EXTENT PERMITTED BY LAW, DAPPERCATSINC SHALL NOT BE LIABLE FOR ANY:
- INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES
- LOSS OF PROFITS, DATA, OR BUSINESS OPPORTUNITIES
- DAMAGES RESULTING FROM USE OR INABILITY TO USE THE APP
- DAMAGES FROM THIRD-PARTY SERVICES OR INTEGRATIONS
- DAMAGES EXCEEDING THE AMOUNT PAID FOR THE APP (IF ANY)

### 10.2 Exceptions
Some jurisdictions do not allow the exclusion of certain warranties or limitation of liability. In such cases, our liability is limited to the maximum extent permitted by law.

## 11. Indemnification

You agree to indemnify and hold harmless DapperCatsInc and its officers, directors, employees, and agents from any claims, damages, or expenses arising from:
- Your use of the App in violation of these Terms
- Your violation of any applicable laws or regulations
- Infringement of third-party rights through your use of the App
- Content you submit or actions you take within the App

## 12. Termination

### 12.1 Termination by User
You may stop using the App at any time by uninstalling it from your device. Uninstalling the App will permanently delete all local data.

### 12.2 Termination by Company
We may terminate or suspend your access to the App if you violate these Terms or engage in harmful behavior.

### 12.3 Effect of Termination
Upon termination:
- Your license to use the App immediately ends
- You must cease all use of the App
- Local data remains on your device until manually deleted
- Provisions regarding intellectual property, disclaimers, and limitations of liability survive termination

## 13. Governing Law and Dispute Resolution

### 13.1 Governing Law
These Terms are governed by the laws of [Jurisdiction] without regard to conflict of law principles.

### 13.2 Dispute Resolution
Any disputes arising from these Terms or your use of the App will be resolved through:
1. Good faith negotiation
2. Binding arbitration if negotiation fails
3. Courts of [Jurisdiction] for matters not subject to arbitration

### 13.3 Class Action Waiver
You agree that any disputes will be resolved individually and waive any right to participate in class action lawsuits.

## 14. General Provisions

### 14.1 Entire Agreement
These Terms, together with our Privacy Policy, constitute the entire agreement between you and DapperCatsInc regarding the App.

### 14.2 Severability
If any provision of these Terms is found to be unenforceable, the remaining provisions will remain in full force and effect.

### 14.3 No Waiver
Our failure to enforce any right or provision of these Terms does not constitute a waiver of such right or provision.

### 14.4 Assignment
You may not assign your rights under these Terms. We may assign our rights to any affiliate or successor entity.

### 14.5 Contact Information
If you have questions about these Terms, please contact us at:
- Email: support@dappercatsinc.com
- Website: https://dappercatsinc.com
- Address: [Company Address]

---

**By using HabitV8, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.**''';

  // Privacy Policy content
  static const String _privacyPolicyContent = '''# Privacy Policy for HabitV8

**Last Updated**: September 15, 2025  
**Effective Date**: September 15, 2025

## Introduction

HabitV8 ("we," "our," or "us") is committed to protecting your privacy and ensuring you have complete control over your personal information. This Privacy Policy explains how we collect, use, and protect your information when you use our habit tracking application ("the App").

**Privacy First Design**: HabitV8 is designed with privacy as a core principle. All your data is stored locally on your device, and we do not collect, transmit, or store your personal information on external servers.

## Information We Collect

### Data Stored Locally on Your Device

HabitV8 stores all your information locally on your device using encrypted local storage. This information includes:

#### Habit Data
- **Habit Information**: Habit names, descriptions, categories, and custom settings
- **Completion Records**: Timestamps and completion status for each habit instance
- **Streak Information**: Current and best streak records
- **Progress Statistics**: Success rates, completion trends, and performance metrics
- **Achievement Data**: Unlocked achievements, XP points, and milestone records

#### App Settings and Preferences
- **User Interface Settings**: Theme preferences, notification settings, and layout choices
- **Notification Preferences**: Reminder schedules, sound choices, and quiet hours
- **Integration Settings**: Health app and calendar integration preferences
- **AI Settings**: Local AI processing preferences and insight configurations

#### Analytics Data (Local Only)
- **Usage Patterns**: App usage statistics for performance optimization (stored locally only)
- **Performance Metrics**: App performance data for bug detection and optimization
- **Feature Usage**: Which features you use to improve app design (local analysis only)

#### Optional Integration Data
- **Calendar Data**: If you choose to enable calendar integration (see Calendar Integration section)

### Data We Explicitly DO NOT Collect

We want to be completely transparent about what we don't collect:

- **Personal Identifiers**: No names, email addresses, phone numbers, or contact information
- **Location Data**: No location tracking or GPS data collection
- **Device Identifiers**: No device IDs, advertising IDs, or unique device fingerprints
- **Usage Analytics**: No usage data transmitted to external servers or analytics services
- **Crash Reports**: No automatic crash reporting to external services
- **Network Activity**: No tracking of your internet usage or browsing behavior
- **Social Media Data**: No access to social media accounts or profiles
- **Contact Lists**: No access to your contacts or communication data
- **Financial Information**: No payment information (payments handled by app stores)

## How We Use Your Information

Your data is used exclusively on your device to provide app functionality:

### Core Functionality
- **Habit Tracking**: Store and manage your habit information and completion records
- **Progress Visualization**: Generate charts, statistics, and progress visualizations
- **Notification Delivery**: Send local reminders and habit notifications
- **Achievement Tracking**: Award achievements and track XP progress
- **AI Insights**: Provide personalized recommendations using local AI processing

### App Improvement
- **Performance Optimization**: Improve app speed and efficiency based on local usage patterns
- **Feature Enhancement**: Optimize features based on local usage data
- **Bug Detection**: Identify and fix issues using local error logging

### Data Processing Location
**All data processing occurs locally on your device**. No data is transmitted to external servers for processing, analysis, or storage.

## Calendar Integration (Optional)

### Calendar Access
If you choose to enable calendar integration:

#### Data Access
- **Read Access**: View existing calendar events to avoid scheduling conflicts
- **Write Access**: Create habit-related calendar events and reminders
- **Event Data**: Access event titles, times, and basic information for habit-related events only

#### Data Usage
- **Habit Scheduling**: Create calendar events for scheduled habits
- **Conflict Avoidance**: Suggest habit timing that doesn't conflict with existing events
- **Progress Visualization**: Show habit completions alongside calendar events
- **Reminder Integration**: Coordinate habit reminders with calendar scheduling

#### Privacy Protection
- **Minimal Access**: Only access calendar data necessary for habit scheduling
- **Local Processing**: All calendar data analysis performed on device
- **No External Storage**: Calendar data not stored or transmitted externally
- **User Control**: Calendar integration can be disabled at any time

## Data Storage and Security

### Local Encryption
- **Database Encryption**: All habit data stored in encrypted Hive database
- **Secure Storage**: Sensitive data encrypted using Flutter Secure Storage
- **Key Management**: Encryption keys managed by your device's secure enclave
- **Data Integrity**: Regular integrity checks to prevent data corruption

### Device Security
- **System Protection**: Data protected by your device's security measures (passcode, biometrics)
- **App Sandboxing**: App data isolated from other applications
- **Secure APIs**: All data access through secure, platform-approved APIs
- **No Root Access**: No attempts to access system-level data or bypass security

### Data Backup
- **Local Backup**: Built-in local backup capabilities for data protection
- **User Control**: You control when and how backups are created
- **No Cloud Backup**: No automatic cloud backup to external services
- **Export Options**: Manual export options for your own backup purposes

## Third-Party Services

### Services We Do NOT Use
- **Analytics Services**: No Google Analytics, Firebase Analytics, or similar services
- **Crash Reporting**: No Crashlytics, Bugsnag, or external crash reporting
- **Advertising Networks**: No ad networks or advertising SDKs
- **Social Media SDKs**: No Facebook, Twitter, or other social media integrations
- **Cloud Storage**: No Google Drive, iCloud, or external cloud storage services
- **User Tracking**: No user behavior tracking or profiling services

### Platform Services We Do Use

#### App Store Services (Apple/Google)
- **Purpose**: App distribution, updates, and purchase processing
- **Data Shared**: Only app installation and update information
- **Control**: Managed by Apple App Store and Google Play Store privacy policies

#### Operating System APIs
- **Notification Services**: For delivering habit reminders (local notifications only)
- **Health APIs**: Optional integration with HealthKit/Health Connect (user consent required)
- **Calendar APIs**: Optional integration with device calendar (user consent required)
- **File System**: For local data storage and backup functionality

### AI Processing (Optional)

#### Local AI Processing
- **TensorFlow Lite**: On-device machine learning for habit insights
- **Processing Location**: All AI analysis performed locally on your device
- **No External APIs**: No data sent to external AI services by default

#### Optional External AI APIs
- **User Choice**: You can optionally configure external AI services (OpenAI, Google Gemini)
- **API Key Control**: You provide and control your own API keys
- **Data Transmission**: If enabled, only anonymized habit patterns are sent (no personal data)
- **Secure Storage**: API keys stored in encrypted secure storage
- **Revocation**: Can be disabled and keys deleted at any time

## Your Rights and Choices

### Data Access and Control
- **View All Data**: Access all your stored data within the app
- **Edit Data**: Modify or correct any habit or completion data
- **Delete Data**: Remove individual habits, completions, or entire data sets
- **Export Data**: Export your data in standard formats (CSV, JSON)
- **Complete Removal**: Uninstalling the app removes all data permanently

### Privacy Settings
- **Notification Controls**: Customize all notification preferences
- **Integration Controls**: Enable/disable health and calendar integrations
- **Theme and Interface**: Control visual and interface preferences
- **Data Export Settings**: Control what data is included in exports

### Consent Management
- **Health Data Consent**: Granular control over each health data type
- **Calendar Consent**: Control calendar access permissions
- **AI Processing Consent**: Choose between local and external AI processing
- **Notification Consent**: Control all notification permissions

## Data Retention

### Retention Policy
- **User Control**: You decide how long to keep your data
- **No Automatic Deletion**: Data is retained until you choose to delete it
- **Local Storage Only**: Data remains on your device indefinitely or until you remove it
- **App Uninstall**: All data is permanently deleted when you uninstall the app

### Data Cleanup
- **Automatic Cleanup**: Old notification data and temporary files cleaned automatically
- **Manual Cleanup**: Tools provided for manual data cleanup
- **Storage Optimization**: Automatic compression and optimization of stored data
- **User Choice**: Full control over what data to keep or remove

## Children's Privacy

### Age Restrictions
- **General Audience**: App suitable for all ages (4+)
- **No Child-Specific Features**: No features specifically designed for children
- **No Data Collection**: Since we don't collect personal data, no special child protections needed
- **Parental Control**: Parents can monitor app usage through device parental controls

### COPPA Compliance
- **No Personal Information**: We don't collect personal information from users of any age
- **Local Storage Only**: All data remains on the device under parental control
- **No Online Features**: No chat, social, or online interaction features
- **Safe Content**: All content appropriate for all ages

## International Data Transfers

### No Data Transfers
- **Local Storage Only**: Since all data remains on your device, no international transfers occur
- **No Cloud Storage**: No data sent to servers in any jurisdiction
- **User Control**: You control where your device and data are located
- **Regional Compliance**: App complies with privacy laws in all regions where available

## Changes to This Privacy Policy

### Notification of Changes
- **App Updates**: Privacy policy changes communicated through app updates
- **Effective Date**: Changes take effect on the date specified in the updated policy
- **User Choice**: Continued use of the app constitutes acceptance of changes
- **Significant Changes**: Material changes will be highlighted prominently

### Version History
- **Change Tracking**: Previous versions of privacy policy available upon request
- **Transparency**: Clear documentation of what changes were made and why
- **User Access**: Users can request information about specific changes

## Contact Information

### Questions and Concerns
If you have any questions about this Privacy Policy or our privacy practices, please contact us:

- **Email**: privacy@dappercatsinc.com
- **Website**: https://dappercatsinc.com/privacy
- **Support**: support@dappercatsinc.com
- **Address**: [Company Address]

### Response Time
- **Email Responses**: We aim to respond to privacy inquiries within 48 hours
- **Complex Issues**: More complex privacy matters may take up to 5 business days
- **Urgent Concerns**: For urgent privacy concerns, please mark emails as "Urgent Privacy Matter"

## Compliance and Certifications

### Privacy Law Compliance
This privacy policy and our app design comply with:
- **GDPR**: European Union General Data Protection Regulation
- **CCPA**: California Consumer Privacy Act
- **COPPA**: Children's Online Privacy Protection Act
- **PIPEDA**: Personal Information Protection and Electronic Documents Act (Canada)
- **Other Regional Laws**: Applicable privacy laws in regions where the app is available

### Security Standards
- **Industry Standards**: We follow industry-standard security practices
- **Regular Audits**: Privacy and security practices reviewed regularly
- **Continuous Improvement**: Ongoing updates to maintain highest privacy standards
- **Third-Party Verification**: Independent security assessments when applicable

---

**By using HabitV8, you acknowledge that you have read and understood this Privacy Policy and agree to our privacy practices.**''';
}
