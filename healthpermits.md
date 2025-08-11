Android 16 introduces a new, more granular set of health permissions managed through Health Connect, moving away from the broader BODY_SENSORS permission. These new permissions allow users to have more precise control over what health and fitness data they share with apps.

Here is a comprehensive list of the health-related permissions as defined in the android.permissions.health package, which apps must now request to access specific health data types:

Health and Fitness Permissions

android.permission.health.READ_ACTIVITY_INTENSITY: Allows an app to read the user's activity intensity data.

android.permission.health.READ_BASAL_BODY_TEMPERATURE: Allows an app to read the user's basal body temperature data.

android.permission.health.READ_BLOOD_GLUCOSE: Allows an app to read the user's blood glucose levels.

android.permission.health.READ_BLOOD_PRESSURE: Allows an app to read the user's blood pressure data.

android.permission.health.READ_HEART_RATE: Required for reading heart rate data, replacing the older BODY_SENSORS permission.

android.permission.health.READ_OXYGEN_SATURATION: Allows an app to read the user's oxygen saturation levels.

android.permission.health.READ_RESPIRATORY_RATE: Allows an app to read the user's respiratory rate data.

android.permission.health.READ_BODY_TEMPERATURE: Allows an app to read the user's body temperature data.

android.permission.health.READ_EXERCISE: Allows an app to read exercise and workout data.

android.permission.health.READ_NUTRITION: Allows an app to read nutrition and hydration data.

android.permission.health.READ_SLEEP: Allows an app to read sleep data, including sleep stages and duration.

android.permission.health.READ_STEPS: Allows an app to read the user's step count.

Medical Records Permissions

Android 16 also introduces a new set of APIs and permissions for handling medical records in the FHIR format.

android.permission.health.READ_MEDICAL_DATA_IMMUNIZATION: Allows an app to read immunization records.

android.permission.health.WRITE_MEDICAL_DATA_IMMUNIZATION: Allows an app to write immunization records.

android.permission.health.READ_MEDICAL_DATA: A more general permission for reading medical data, which may be expanded to cover more record types in the future (e.g., lab results, medications).

android.permission.health.WRITE_MEDICAL_DATA: A more general permission for writing medical data to Health Connect.

Permissions for Background Access

android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND: This is the new permission for accessing sensor data in the background, replacing BODY_SENSORS_BACKGROUND.

It is important to note that developers must also provide a clear rationale in their app's manifest for why these permissions are needed. The system will prompt the user to grant these permissions at runtime, and the user has the ability to deny or revoke access at any time.