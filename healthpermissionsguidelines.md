Android Health Permissions: Guidance and FAQs
This page provides detailed guidance and answers frequently asked questions regarding the use of Android permissions that access sensitive health and fitness data. These permissions include but are not limited to the following:

A. Health Connect permissions: Health Connect provides a centralized and standardized way for apps to store and share health and fitness data while maintaining user privacy and security. It allows apps to request access to specific data types rather than broad permissions, supporting more transparency and control. Examples of Health Connect permissions include:

android.permission.health.READ_HEART_RATE

android.permission.health.READ_BLOOD_PRESSURE

More information on Health Connect, including getting started, can be found on our Health Connect developer page. For details on health permissions, refer to  Android Health permissions.

B. Body Sensors: Android also provides permissions to access data directly from on-body sensors, such as heart rate monitors, pulse oximeters, and skin temperature sensors. (using android.permission.BODY_SENSORS, or starting in Android 16, more granular android.permission.health.* permissions, like android.permission.health.READ_HEART_RATE.

For more information on the transition, see Behavior changes: Apps targeting Android 16 or higher.

C. Other relevant permissions include:

Specific health-related permissions such as READ_HEALTH_DATA_IN_BACKGROUND and READ_HEALTH_DATA_HISTORY

Standard Android permissions (for example, Location, Camera, Microphone, Bluetooth, Background Execution) used within a health app to collect or infer sensitive health information, are also subject to the core principles outlined here (user consent, data minimization, purpose limitation, security) and the User Data policy.

Data access and use: Requirements and guidance
Access and use of health permissions is subject to the following key principles. These apply whether data comes from Health Connect, Body Sensors, or other relevant health, fitness and wellness permissions, and supplement the full requirements of the User Data policy and Health apps policy.

Your app's access to health and fitness data obtained through Android permissions must be directly tied to providing a clear benefit to the user within the scope of approved use cases detailed in this guidance.

You must comply with all detailed requirements for consent, runtime permission requests, and prominent disclosure outlined in the Google Play User Data policy.

Only request permissions and access data types that support the specific, user-facing health features you offer. Do not request broader access than necessary.

Maintain a comprehensive and accurate privacy policy, easily accessible from your app and Play Store listing, that clearly explains:

What health and fitness data your app collects and accesses.

How the data is used, stored, and potentially shared (including with any third parties).

Your data retention and deletion policies.

Your security practices.

Your app's functionality, Play Store listing, and any in-app disclosures related to health data access must accurately represent your data practices and intended use.

You must implement robust technical, administrative, and physical security measures to protect sensitive health data from unauthorized access, use, disclosure, modification, loss, or destruction. This includes, at minimum, data encryption both at rest and in transit, strong access controls within your systems, and secure development practices and vulnerability management.

You are solely responsible for identifying and complying with all applicable laws, regulations, and industry standards related to health data in every region where your app is distributed. This includes, but is not limited to, requirements like:

HIPAA in the United States for Protected Health Information (PHI).

GDPR in Europe regarding personal data processing and in particular the processing of special categories of data.

Regulations concerning Software as a Medical Device (SaMD) if your app meets the relevant criteria.

Local data privacy and health information laws.

For a comprehensive list of prohibited uses of Android health and fitness data, refer to the "Prohibited uses of Android Health and Fitness data" section below.

Approved use cases for Android health permissions
Accessing sensitive health and fitness data through Android permissions is strictly limited to apps providing clear user benefit within specific, approved use cases. Your declared use case(s) in the Play Console must accurately reflect your app's functionality that requires health and fitness data.

This section provides detailed descriptions and examples for the primary approved use cases. Note that the suitability of data from Health Connect or Body Sensors may vary depending on the specific feature.

Fitness, wellness and coaching
Rewards
Corporate wellness
Medical care
Human-subjects research
Health-integrated games
Prohibited uses of Android Health and Fitness data
Given the sensitive nature of health, fitness, and wellness data, certain uses are strictly prohibited in order to protect user privacy and safety. Using data accessed via Android health permissions (including Health Connect, Body Sensors or other relevant permissions) for any of the following purposes is forbidden:

Commercial exploitation and advertising
Transferring or selling user health or fitness data to third parties like advertising platforms, data brokers, or any information resellers.
Transferring, selling, or using user health and fitness data for serving ads, including personalized or interest-based advertising.
Transferring, selling, or using user health and fitness data to determine credit-worthiness or for lending purposes.
Sharing health data with third parties without explicit, informed user consent.
Unauthorized or unsafe applications
Transferring, selling, or using user health and fitness data with any product or service that may qualify as a medical device, unless the medical device app complies with all applicable regulations, including obtaining necessary clearances or approvals from relevant regulatory bodies (for example, U.S. FDA) for its intended use of health and fitness data, and the user has provided explicit consent for such use.
Transferring, selling, or using user health and fitness data for any purpose or in any manner involving sensitive health information governed by specific privacy regulations (for example, Protected Health Information under HIPAA) unless user-initiated and in compliance with all such applicable laws and regulations.
Do not use health and fitness data in developing, or for incorporation into, applications, environments or activities where the use or failure of health data could reasonably be expected to lead to death, personal injury, harm to individuals, or environmental or property damage.
Do not access data obtained through Android health permissions using headless apps. Apps must display a clearly identifiable icon in the app tray, device app settings, notification icons, etc.
Do not use health and fitness data APIs with apps that sync data between incompatible devices or platforms.
Do not use Android health permissions to connect to applications, services or features that solely target children.
How do I request access to data from health and fitness permissions?
Review the relevant policies: Review and understand the approved use cases and requirements for accessing, sharing, and protecting health and fitness user data. To know more, read the Health Permissions by Androidpolicy and the guidance mentioned on this page.
Request permissions in Play Console: When submitting your app in Play Console, request the specific permissions required for the data types your app needs to support its features.
When requesting permissions, bear the following in mind:

For each permission requested, provide a clear and detailed justification explaining how your app will use the data to benefit the user.
If your app does not require access to specific data types, then you must not request access to these data types.
Be as detailed as possible in documenting the purpose for your access requests.
Request the minimum data types needed and provide a valid use case for each request.
For a visual guide on managing Health & Fitness permissions, you might find the following video helpful.

Examples of a good justification:

Permission requested: Access to physical activity data.
Justification: “Our app provides personalized workout plans. Access to physical activity data allows us to tailor recommendations based on users' current activity levels, enhancing their fitness journey.”
Permission Requested (Body Sensors): android.permission.health.READ_HEART_RATE
Justification: “Our app provides real-time heart rate monitoring during workouts to provide feedback to the user and allow them to adjust their workout intensity.”
Example of an incomplete justification:

Permission requested: Access to physical activity data.
Justification: “Needed for app functionality.” (This is too broad and lacks specific justification)
Describe privacy & security practices: Provide a comprehensive privacy policy that:
Provides an overview of your app's data collection, usage, and sharing practices. Include details about what data is collected, how it's used and stored, user controls, and data sharing practices.
Describes the security measures implemented to protect user data, such as encryption, access controls, and regular security assessments.
All access requests for health & fitness and body sensor permissions will be subject to review so that the use of this sensitive data aligns with approved use cases.