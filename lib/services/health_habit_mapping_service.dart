import 'dart:io';
import 'dart:math' as math;
import '../domain/model/habit.dart';
import 'health_service.dart';
import 'logging_service.dart';

/// Health-Habit Mapping Service
///
/// This service provides intelligent mapping between health metrics and habits,
/// enabling automatic completion based on health data patterns and thresholds.
class HealthHabitMappingService {
  /// Map of health data types to their corresponding habit keywords and thresholds
  static const Map<String, HealthHabitMapping> healthMappings = {
    'STEPS': HealthHabitMapping(
      keywords: [
        // Basic walking terms
        'walk', 'walking', 'walked', 'step', 'steps', 'stepping',
        // Running and jogging
        'run', 'running', 'jog', 'jogging', 'sprint', 'sprinting',
        // Movement and activity
        'move',
        'movement',
        'moving',
        'active',
        'activity',
        'stroll',
        'strolling',
        'hike', 'hiking', 'trek', 'trekking', 'march', 'marching',
        // Exercise terms that involve steps
        'exercise', 'cardio', 'fitness', 'aerobic', 'aerobics',
        // Specific activities
        'treadmill', 'elliptical', 'stepper', 'stairs', 'climbing',
        // Daily activities
        'commute', 'commuting', 'errands', 'shopping', 'patrol', 'patrolling',
        // Medical/recovery terms
        'recovery', 'rehab', 'rehabilitation', 'therapy', 'physical', 'medical',
        'healing',
        'mobility',
        'assisted',
        'gentle',
        'slow',
        'basic',
        'beginner',
        'post-surgery', 'injury', 'limited', 'wheelchair', 'walker', 'cane',
        // Distance terms (often correlate with steps)
        'distance', 'mile', 'miles', 'km', 'kilometer', 'meters',
        // Health category terms that often involve movement
        'health', 'healthy', 'wellness', 'wellbeing',
        // Category-related terms for better recognition
        'outdoor', 'nature', 'park', 'trail', 'path', 'sidewalk', 'street',
        'morning', 'evening', 'daily', 'routine', 'habit', 'goal', 'target',
        'pace', 'speed', 'brisk', 'leisurely', 'casual', 'power',
        // Sports and activities that involve steps
        'sport', 'sports', 'athletic', 'athletics', 'competition', 'training',
        'practice', 'drill', 'warmup', 'cooldown', 'stretch', 'stretching',
      ],
      thresholds: {
        'recovery': 500, // Medical recovery/rehabilitation
        'minimal': 2000, // Light activity
        'moderate': 5000, // Moderate activity
        'active': 8000, // Active lifestyle
        'very_active': 12000, // Very active
      },
      unit: 'steps',
      description: 'Daily step count for walking and movement habits',
    ),

    'ACTIVE_ENERGY_BURNED': HealthHabitMapping(
      keywords: [
        // General exercise terms
        'exercise', 'exercising', 'workout', 'working', 'train', 'training',
        'fitness', 'fit', 'active', 'activity', 'sport', 'sports',
        // Gym and equipment
        'gym', 'gymnasium', 'weights', 'lifting', 'strength', 'resistance',
        'dumbbell', 'barbell', 'kettlebell', 'machine', 'equipment',
        // Cardio activities
        'cardio', 'cardiovascular', 'aerobic', 'aerobics', 'hiit',
        'run', 'running', 'jog', 'jogging', 'sprint', 'bike', 'biking',
        'cycle', 'cycling', 'swim', 'swimming', 'row', 'rowing',
        // Specific workouts
        'crossfit', 'pilates', 'yoga', 'zumba', 'dance', 'dancing',
        'boxing', 'kickboxing', 'martial', 'karate', 'taekwondo',
        // Equipment and activities
        'treadmill',
        'elliptical',
        'stepper',
        'climber',
        'vibration',
        'plate',
        'vibrating',
        'tennis', 'basketball', 'football', 'soccer', 'volleyball',
        'badminton', 'squash', 'racquet', 'golf', 'baseball',
        // Outdoor activities
        'hike', 'hiking', 'climb', 'climbing', 'ski', 'skiing',
        'surf', 'surfing', 'kayak', 'kayaking', 'paddle',
        // Body parts (often in exercise context)
        'abs', 'core', 'legs', 'arms', 'chest', 'back', 'shoulders',
        // Intensity terms
        'intense', 'vigorous', 'hard', 'tough', 'challenging',
        // Calorie-related terms
        'burn', 'burning', 'calories', 'calorie', 'energy',
        // Additional fitness terms
        'sweat', 'sweating', 'pump', 'pumping', 'rep', 'reps', 'set', 'sets',
        'circuit',
        'interval',
        'tabata',
        'burpee',
        'burpees',
        'pushup',
        'pushups',
        'pullup',
        'pullups',
        'squat',
        'squats',
        'lunge',
        'lunges',
        'plank',
        'planks',
      ],
      thresholds: {
        'minimal': 100, // Light exercise (100 cal)
        'moderate': 250, // Moderate exercise (250 cal)
        'active': 400, // Active exercise (400 cal)
        'very_active': 600, // Intense exercise (600+ cal)
      },
      unit: 'calories',
      description: 'Active energy burned for exercise and fitness habits',
    ),

    'TOTAL_CALORIES_BURNED': HealthHabitMapping(
      keywords: [
        // General exercise terms
        'exercise', 'exercising', 'workout', 'working', 'train', 'training',
        'fitness', 'fit', 'active', 'activity', 'sport', 'sports',
        // Gym and equipment
        'gym', 'gymnasium', 'weights', 'lifting', 'strength', 'resistance',
        'dumbbell', 'barbell', 'kettlebell', 'machine', 'equipment',
        // Cardio activities
        'cardio', 'cardiovascular', 'aerobic', 'aerobics', 'hiit',
        'run', 'running', 'jog', 'jogging', 'sprint', 'bike', 'biking',
        'cycle', 'cycling', 'swim', 'swimming', 'row', 'rowing',
        // Specific workouts
        'crossfit', 'pilates', 'yoga', 'zumba', 'dance', 'dancing',
        'boxing', 'kickboxing', 'martial', 'karate', 'taekwondo',
        // Equipment and activities
        'treadmill',
        'elliptical',
        'stepper',
        'climber',
        'vibration',
        'plate',
        'vibrating',
        'tennis', 'basketball', 'football', 'soccer', 'volleyball',
        'badminton', 'squash', 'racquet', 'golf', 'baseball',
        // Outdoor activities
        'hike', 'hiking', 'climb', 'climbing', 'ski', 'skiing',
        'surf', 'surfing', 'kayak', 'kayaking', 'paddle',
        // Body parts (often in exercise context)
        'abs', 'core', 'legs', 'arms', 'chest', 'back', 'shoulders',
        // Intensity terms
        'intense', 'vigorous', 'hard', 'tough', 'challenging',
        // Calorie-related terms
        'burn', 'burning', 'calories', 'calorie', 'energy', 'total', 'daily',
        // Additional fitness terms
        'sweat', 'sweating', 'pump', 'pumping', 'rep', 'reps', 'set', 'sets',
        'circuit',
        'interval',
        'tabata',
        'burpee',
        'burpees',
        'pushup',
        'pushups',
        'pullup',
        'pullups',
        'squat',
        'squats',
        'lunge',
        'lunges',
        'plank',
        'planks',
      ],
      thresholds: {
        'minimal': 200, // Light daily activity (200 cal)
        'moderate': 500, // Moderate daily activity (500 cal)
        'active': 800, // Active daily activity (800 cal)
        'very_active': 1200, // Very active daily activity (1200+ cal)
      },
      unit: 'calories',
      description: 'Total energy burned for daily activity and exercise habits',
    ),

    'SLEEP_IN_BED': HealthHabitMapping(
      keywords: [
        // Basic sleep terms
        'sleep', 'sleeping', 'slept', 'asleep', 'sleepy',
        'rest', 'resting', 'rested', 'restful',
        // Bedtime terms
        'bed', 'bedtime', 'bedroom', 'mattress', 'pillow',
        'nap', 'napping', 'napped', 'siesta', 'doze', 'dozing',
        // Time-related sleep terms
        'night', 'nighttime', 'evening', 'late', 'early',
        'hours', 'hour', 'time', 'schedule', 'routine',
        // Sleep quality terms
        'deep', 'light', 'rem', 'dream', 'dreaming',
        'slumber', 'snooze', 'drowsy', 'tired', 'fatigue',
        // Sleep hygiene terms
        'wind', 'down', 'relax', 'unwind', 'calm', 'peaceful',
        'quiet', 'dark', 'comfortable', 'cozy',
        // Sleep problems (people track to improve)
        'insomnia', 'restless', 'toss', 'turn', 'wake', 'waking',
        // Recovery terms
        'recover', 'recovery', 'recharge', 'rejuvenate', 'refresh',
      ],
      thresholds: {
        'minimal': 6.0, // 6 hours minimum
        'moderate': 7.0, // 7 hours recommended
        'active': 8.0, // 8 hours optimal
        'very_active': 9.0, // 9+ hours extended
      },
      unit: 'hours',
      description: 'Sleep duration for rest and recovery habits',
    ),

    'WATER': HealthHabitMapping(
      keywords: [
        // Basic water terms
        'water', 'h2o', 'hydrate', 'hydrating', 'hydration',
        'drink', 'drinking', 'drank', 'sip', 'sipping',
        // Fluid terms
        'fluid', 'fluids', 'liquid', 'liquids', 'beverage', 'beverages',
        // Containers and measurements
        'bottle', 'bottles', 'glass', 'glasses', 'cup', 'cups',
        'liter', 'liters', 'litre', 'litres', 'ml', 'milliliter',
        'ounce', 'ounces', 'oz', 'gallon', 'quart', 'pint',
        // Types of water/drinks
        'tap', 'filtered', 'spring', 'mineral', 'sparkling',
        'plain', 'still', 'cold', 'warm', 'hot', 'ice', 'iced',
        // Health-related terms
        'thirst', 'thirsty', 'dehydrate', 'dehydration',
        'electrolyte', 'electrolytes', 'replenish', 'refill',
        // Daily habits
        'morning', 'afternoon', 'evening', 'meal', 'meals',
        'before', 'after', 'during', 'workout', 'exercise',
        // Tracking terms
        'intake', 'consumption', 'amount', 'quantity', 'goal',
        'target', 'daily', 'hourly', 'regular', 'consistent',
        // Additional hydration terms
        'hydrate', 'hydrating', 'hydration', 'rehydrate', 'rehydrating',
        'moisture', 'wet', 'refresh', 'refreshing', 'quench', 'thirsty',
      ],
      thresholds: {
        'minimal': 1000, // 1L minimum
        'moderate': 2000, // 2L recommended
        'active': 3000, // 3L active
        'very_active': 4000, // 4L+ high activity
      },
      unit: 'ml',
      description: 'Water intake for hydration habits',
    ),

    // MINDFULNESS mapping - conditionally available based on platform support
    'MINDFULNESS': HealthHabitMapping(
      keywords: [
        // Basic mindfulness terms
        'mindful', 'mindfulness', 'meditate', 'meditation', 'meditated',
        'zen', 'calm', 'calming', 'peace', 'peaceful', 'tranquil',
        // Breathing and relaxation
        'breathe', 'breathing', 'breath', 'relax', 'relaxation', 'unwind',
        'deep', 'inhale', 'exhale', 'pranayama', 'breathwork',
        // Mental wellness
        'mental', 'wellness', 'wellbeing', 'stress', 'anxiety', 'worry',
        'focus', 'concentration', 'awareness', 'present', 'moment',
        // Spiritual practices
        'spiritual', 'prayer', 'pray', 'gratitude', 'grateful', 'thankful',
        'reflection', 'contemplate', 'introspect', 'journal', 'journaling',
        // Specific practices
        'yoga', 'tai', 'chi', 'qigong', 'vipassana', 'samatha',
        'loving', 'kindness', 'compassion', 'metta', 'mantra',
        // Apps and tools
        'headspace', 'calm', 'insight', 'timer', 'guided', 'silent',
        'bell', 'chime', 'cushion', 'mat', 'retreat',
        // Time-based
        'minutes', 'minute', 'session', 'practice', 'daily', 'morning',
        'evening', 'before', 'bed', 'wake', 'routine',
      ],
      thresholds: {
        'minimal': 5.0, // 5 minutes minimum
        'moderate': 10.0, // 10 minutes recommended
        'active': 20.0, // 20 minutes good practice
        'very_active': 30.0, // 30+ minutes advanced
      },
      unit: 'minutes',
      description: 'Mindfulness and meditation practice duration',
    ),

    'WEIGHT': HealthHabitMapping(
      keywords: [
        // Basic weight terms
        'weight', 'weigh', 'weighing', 'weighed', 'pounds', 'lbs',
        'kilograms', 'kg', 'kilogram', 'grams', 'gram',
        // Scale and measurement
        'scale', 'scales', 'measure', 'measuring', 'measurement',
        'track', 'tracking', 'monitor', 'monitoring', 'record',
        // Body terms
        'body', 'bodily', 'mass', 'bmi', 'index', 'composition',
        'fat', 'muscle', 'lean', 'bone', 'density',
        // Health tracking
        'health', 'healthy', 'fitness', 'progress', 'goal',
        'target', 'ideal', 'maintain', 'maintenance',
        // Weight management
        'lose', 'losing', 'loss', 'gain', 'gaining', 'maintain',
        'diet', 'dieting', 'nutrition', 'eating', 'food',
        // Daily habits
        'morning', 'daily', 'weekly', 'regular', 'routine',
        'consistent', 'habit', 'check', 'checking',
        // Medical/health terms
        'doctor', 'physician', 'medical', 'health', 'checkup',
        'appointment', 'visit', 'clinic', 'hospital',
        // Emotional/motivational
        'motivation', 'motivated', 'discipline', 'commitment',
        'accountability', 'responsible', 'mindful',
      ],
      thresholds: {
        'minimal': 1, // Any weight measurement
        'moderate': 1, // Daily weighing
        'active': 1, // Consistent tracking
        'very_active': 1, // Multiple measurements
      },
      unit: 'measurements',
      description: 'Weight tracking for body monitoring habits',
    ),

    'MEDICATION': HealthHabitMapping(
      keywords: [
        // Basic medication terms
        'med', 'meds', 'medication', 'medications', 'medicine', 'medicines',
        'pill', 'pills', 'tablet', 'tablets', 'capsule', 'capsules',
        'drug', 'drugs', 'prescription', 'prescriptions', 'rx',
        'dose', 'dosage', 'treatment', 'therapy', 'pharmaceutical',
        // Supplement terms
        'vitamin', 'vitamins', 'supplement', 'supplements', 'multivitamin',
        'probiotic', 'omega', 'calcium', 'iron', 'magnesium', 'zinc',
        // Action terms
        'take', 'taking', 'took', 'swallow', 'consume', 'ingest',
        // Medical conditions and treatments
        'blood', 'pressure', 'diabetes', 'cholesterol', 'thyroid',
        'antibiotic', 'antibiotics', 'painkiller', 'aspirin', 'ibuprofen',
        'antidepressant', 'antacid', 'allergy', 'antihistamine',
        // Timing and routine
        'morning', 'evening', 'bedtime', 'daily', 'twice', 'thrice',
        'before', 'after', 'meal', 'meals', 'food', 'empty', 'stomach',
        // Medical administration
        'oral', 'sublingual', 'injection', 'inhaler', 'topical', 'patch',
        'drops', 'spray', 'liquid', 'syrup', 'powder',
        // Health management
        'chronic', 'condition', 'maintenance', 'preventive', 'therapeutic',
        'compliance', 'adherence', 'regimen', 'schedule', 'reminder',
      ],
      thresholds: {
        'minimal': 1, // Any medication taken
        'moderate': 1, // Daily medication
        'active': 1, // Multiple medications
        'very_active': 1, // Complex regimen
      },
      unit: 'doses',
      description: 'Medication and supplement tracking for health management',
    ),

    'HEART_RATE': HealthHabitMapping(
      keywords: [
        // Basic heart rate terms
        'heart', 'heartrate', 'hr', 'bpm', 'beats', 'pulse', 'cardiac',
        'cardiovascular', 'cardio', 'rhythm', 'rate', 'monitor',
        // Exercise and fitness context
        'exercise', 'workout', 'training', 'fitness', 'active', 'activity',
        'run',
        'running',
        'jog',
        'jogging',
        'bike',
        'biking',
        'cycle',
        'cycling',
        'swim', 'swimming', 'aerobic', 'aerobics', 'hiit', 'interval',
        // Meditation and relaxation context
        'meditate',
        'meditation',
        'mindful',
        'mindfulness',
        'breathe',
        'breathing',
        'relax', 'relaxation', 'calm', 'calming', 'zen', 'peaceful', 'tranquil',
        'stress', 'anxiety', 'worry', 'tension', 'unwind', 'decompress',
        // Health monitoring
        'health', 'healthy', 'wellness', 'wellbeing', 'vital', 'vitals',
        'track', 'tracking', 'monitor', 'monitoring', 'measure', 'measuring',
        'check', 'checking', 'record', 'recording', 'log', 'logging',
        // Medical and recovery
        'recovery', 'recover', 'rest', 'resting', 'sleep', 'sleeping',
        'medical', 'doctor', 'physician', 'checkup', 'appointment',
        'condition', 'chronic', 'maintenance', 'therapeutic', 'treatment',
        // Intensity and zones
        'zone', 'zones', 'target', 'max', 'maximum', 'resting', 'elevated',
        'intense', 'intensity', 'moderate', 'light', 'vigorous', 'peak',
        // Emotional and mental states
        'emotion', 'emotional', 'mood', 'feeling', 'mental', 'psychological',
        'excited', 'nervous', 'anxious', 'happy', 'sad', 'angry', 'frustrated',
        // Time-based patterns
        'morning', 'evening', 'daily', 'routine', 'regular', 'consistent',
        'before', 'after', 'during', 'throughout', 'continuous', 'periodic',
      ],
      thresholds: {
        'resting': 60, // Resting heart rate (meditation, relaxation)
        'light': 100, // Light activity heart rate
        'moderate': 130, // Moderate exercise heart rate
        'vigorous': 160, // Vigorous exercise heart rate
        'maximum': 180, // High-intensity exercise
      },
      unit: 'bpm',
      description:
          'Heart rate monitoring for exercise, meditation, and health tracking',
    ),
  };

  /// Comprehensive category to health data type mappings
  static const Map<String, List<CategoryHealthMapping>> categoryMappings = {
    // Fitness and Exercise Categories
    'fitness': [
      CategoryHealthMapping(
        'STEPS',
        0.8,
        'Most fitness activities involve movement',
      ),
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.9,
        'Fitness activities burn calories',
      ),
      CategoryHealthMapping(
        'TOTAL_CALORIES_BURNED',
        0.85,
        'Fitness activities contribute to total calories',
      ),
      CategoryHealthMapping(
        'HEART_RATE',
        0.8,
        'Fitness activities elevate heart rate',
      ),
    ],
    'exercise': [
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.9,
        'Exercise burns active energy',
      ),
      CategoryHealthMapping(
        'TOTAL_CALORIES_BURNED',
        0.85,
        'Exercise contributes to total calories',
      ),
      CategoryHealthMapping('STEPS', 0.7, 'Many exercises involve movement'),
      CategoryHealthMapping('HEART_RATE', 0.85, 'Exercise elevates heart rate'),
    ],
    'workout': [
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.9,
        'Workouts burn calories',
      ),
      CategoryHealthMapping(
        'TOTAL_CALORIES_BURNED',
        0.85,
        'Workouts contribute to total calories',
      ),
      CategoryHealthMapping('STEPS', 0.6, 'Some workouts involve steps'),
      CategoryHealthMapping('HEART_RATE', 0.85, 'Workouts elevate heart rate'),
    ],
    'cardio': [
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.95,
        'Cardio burns significant calories',
      ),
      CategoryHealthMapping(
        'TOTAL_CALORIES_BURNED',
        0.9,
        'Cardio contributes significantly to total calories',
      ),
      CategoryHealthMapping('STEPS', 0.8, 'Cardio often involves movement'),
      CategoryHealthMapping(
        'HEART_RATE',
        0.95,
        'Cardio significantly elevates heart rate',
      ),
    ],
    'strength': [
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.8,
        'Strength training burns calories',
      ),
      CategoryHealthMapping(
        'TOTAL_CALORIES_BURNED',
        0.75,
        'Strength training contributes to total calories',
      ),
    ],
    'running': [
      CategoryHealthMapping(
        'STEPS',
        0.95,
        'Running directly correlates with steps',
      ),
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.9,
        'Running burns calories',
      ),
      CategoryHealthMapping(
        'TOTAL_CALORIES_BURNED',
        0.85,
        'Running contributes to total calories',
      ),
    ],
    'walking': [
      CategoryHealthMapping('STEPS', 0.95, 'Walking directly measures steps'),
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.7,
        'Walking burns some calories',
      ),
      CategoryHealthMapping(
        'TOTAL_CALORIES_BURNED',
        0.65,
        'Walking contributes to total calories',
      ),
    ],
    'sports': [
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.85,
        'Sports activities burn calories',
      ),
      CategoryHealthMapping(
        'TOTAL_CALORIES_BURNED',
        0.8,
        'Sports activities contribute to total calories',
      ),
      CategoryHealthMapping('STEPS', 0.7, 'Many sports involve movement'),
    ],

    // Health and Wellness Categories
    'health': [
      CategoryHealthMapping(
        'MEDICATION',
        0.8,
        'Health management often involves medication',
      ),
      CategoryHealthMapping(
        'WEIGHT',
        0.7,
        'Health tracking often includes weight',
      ),
      CategoryHealthMapping(
        'HEART_RATE',
        0.7,
        'Health monitoring includes heart rate',
      ),
      CategoryHealthMapping(
        'STEPS',
        0.6,
        'General health often involves activity',
      ),
      CategoryHealthMapping(
        'SLEEP_IN_BED',
        0.6,
        'Health includes sleep tracking',
      ),
      CategoryHealthMapping('WATER', 0.6, 'Health includes hydration'),
    ],
    'wellness': [
      CategoryHealthMapping(
        'MINDFULNESS',
        0.8,
        'Wellness includes mental health',
      ),
      CategoryHealthMapping('SLEEP_IN_BED', 0.7, 'Wellness includes rest'),
      CategoryHealthMapping(
        'HEART_RATE',
        0.6,
        'Wellness includes heart rate monitoring',
      ),
      CategoryHealthMapping('WATER', 0.6, 'Wellness includes hydration'),
      CategoryHealthMapping('STEPS', 0.6, 'Wellness includes activity'),
    ],
    'medical': [
      CategoryHealthMapping(
        'MEDICATION',
        0.9,
        'Medical category primarily involves medication tracking',
      ),
      CategoryHealthMapping(
        'WEIGHT',
        0.7,
        'Medical tracking often includes weight',
      ),
      CategoryHealthMapping('STEPS', 0.6, 'Medical recovery involves movement'),
    ],
    'recovery': [
      CategoryHealthMapping('STEPS', 0.8, 'Recovery involves gradual movement'),
      CategoryHealthMapping('SLEEP_IN_BED', 0.7, 'Recovery requires rest'),
    ],

    // Medication and Treatment Categories
    'medication': [
      CategoryHealthMapping(
        'MEDICATION',
        0.95,
        'Medication category directly maps to medication tracking',
      ),
    ],
    'medicine': [
      CategoryHealthMapping(
        'MEDICATION',
        0.95,
        'Medicine category directly maps to medication tracking',
      ),
    ],
    'pill': [
      CategoryHealthMapping(
        'MEDICATION',
        0.9,
        'Pill category maps to medication tracking',
      ),
    ],
    'supplement': [
      CategoryHealthMapping(
        'MEDICATION',
        0.85,
        'Supplement category maps to medication tracking',
      ),
    ],
    'vitamin': [
      CategoryHealthMapping(
        'MEDICATION',
        0.85,
        'Vitamin category maps to medication tracking',
      ),
    ],
    'prescription': [
      CategoryHealthMapping(
        'MEDICATION',
        0.9,
        'Prescription category maps to medication tracking',
      ),
    ],
    'treatment': [
      CategoryHealthMapping(
        'MEDICATION',
        0.8,
        'Treatment often involves medication',
      ),
      CategoryHealthMapping(
        'WEIGHT',
        0.5,
        'Treatment may involve weight monitoring',
      ),
    ],

    // Sleep and Rest Categories
    'sleep': [
      CategoryHealthMapping(
        'SLEEP_IN_BED',
        0.95,
        'Sleep category directly maps to sleep tracking',
      ),
    ],
    'rest': [
      CategoryHealthMapping(
        'SLEEP_IN_BED',
        0.9,
        'Rest includes sleep tracking',
      ),
      CategoryHealthMapping('MINDFULNESS', 0.6, 'Rest can include relaxation'),
    ],
    'bedtime': [
      CategoryHealthMapping(
        'SLEEP_IN_BED',
        0.9,
        'Bedtime routines affect sleep',
      ),
    ],

    // Nutrition and Hydration Categories
    'nutrition': [
      CategoryHealthMapping('WEIGHT', 0.7, 'Nutrition affects weight'),
      CategoryHealthMapping('WATER', 0.6, 'Nutrition includes hydration'),
    ],
    'diet': [
      CategoryHealthMapping('WEIGHT', 0.8, 'Diet directly affects weight'),
      CategoryHealthMapping('WATER', 0.5, 'Diet can include hydration'),
    ],
    'hydration': [
      CategoryHealthMapping(
        'WATER',
        0.95,
        'Hydration directly maps to water intake',
      ),
    ],
    'water': [
      CategoryHealthMapping(
        'WATER',
        0.95,
        'Water category maps to water tracking',
      ),
    ],

    // Mental Health and Mindfulness Categories
    'mindfulness': [
      CategoryHealthMapping(
        'MINDFULNESS',
        0.95,
        'Mindfulness category maps directly',
      ),
      CategoryHealthMapping(
        'HEART_RATE',
        0.7,
        'Mindfulness affects heart rate variability',
      ),
    ],
    'meditation': [
      CategoryHealthMapping(
        'MINDFULNESS',
        0.95,
        'Meditation is mindfulness practice',
      ),
      CategoryHealthMapping(
        'HEART_RATE',
        0.8,
        'Meditation lowers resting heart rate',
      ),
    ],
    'mental': [
      CategoryHealthMapping(
        'MINDFULNESS',
        0.8,
        'Mental health includes mindfulness',
      ),
      CategoryHealthMapping('SLEEP_IN_BED', 0.6, 'Mental health includes rest'),
      CategoryHealthMapping(
        'HEART_RATE',
        0.6,
        'Mental health affects heart rate',
      ),
    ],
    'stress': [
      CategoryHealthMapping(
        'MINDFULNESS',
        0.8,
        'Stress management includes mindfulness',
      ),
      CategoryHealthMapping('SLEEP_IN_BED', 0.6, 'Stress affects sleep'),
      CategoryHealthMapping(
        'HEART_RATE',
        0.7,
        'Stress management affects heart rate',
      ),
    ],
    'relaxation': [
      CategoryHealthMapping(
        'MINDFULNESS',
        0.8,
        'Relaxation includes mindfulness',
      ),
      CategoryHealthMapping('SLEEP_IN_BED', 0.6, 'Relaxation affects sleep'),
      CategoryHealthMapping('HEART_RATE', 0.7, 'Relaxation lowers heart rate'),
    ],

    // Activity and Movement Categories
    'activity': [
      CategoryHealthMapping('STEPS', 0.8, 'Activity often involves movement'),
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.7,
        'Activity burns calories',
      ),
    ],
    'movement': [
      CategoryHealthMapping(
        'STEPS',
        0.9,
        'Movement directly correlates with steps',
      ),
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.6,
        'Movement burns some energy',
      ),
    ],
    'outdoor': [
      CategoryHealthMapping(
        'STEPS',
        0.8,
        'Outdoor activities often involve walking',
      ),
      CategoryHealthMapping(
        'ACTIVE_ENERGY_BURNED',
        0.7,
        'Outdoor activities burn calories',
      ),
    ],

    // Lifestyle Categories
    'lifestyle': [
      CategoryHealthMapping(
        'STEPS',
        0.6,
        'Lifestyle changes often include activity',
      ),
      CategoryHealthMapping('WATER', 0.5, 'Lifestyle includes hydration'),
      CategoryHealthMapping(
        'SLEEP_IN_BED',
        0.5,
        'Lifestyle includes sleep habits',
      ),
    ],
    'routine': [
      CategoryHealthMapping('STEPS', 0.5, 'Routines may include activity'),
      CategoryHealthMapping('WATER', 0.5, 'Routines may include hydration'),
      CategoryHealthMapping(
        'SLEEP_IN_BED',
        0.6,
        'Routines often include sleep',
      ),
    ],

    // Self-care Categories
    'selfcare': [
      CategoryHealthMapping(
        'MINDFULNESS',
        0.7,
        'Self-care includes mental wellness',
      ),
      CategoryHealthMapping('SLEEP_IN_BED', 0.6, 'Self-care includes rest'),
      CategoryHealthMapping('WATER', 0.5, 'Self-care includes hydration'),
    ],
    'self-care': [
      CategoryHealthMapping(
        'MINDFULNESS',
        0.7,
        'Self-care includes mental wellness',
      ),
      CategoryHealthMapping('SLEEP_IN_BED', 0.6, 'Self-care includes rest'),
      CategoryHealthMapping('WATER', 0.5, 'Self-care includes hydration'),
    ],
  };

  /// Analyze a habit and determine its health mapping potential
  static Future<HabitHealthMapping?> analyzeHabitForHealthMapping(
    Habit habit,
  ) async {
    try {
      final habitName = habit.name.toLowerCase();
      final habitDescription = (habit.description ?? '').toLowerCase();
      final searchText = '$habitName $habitDescription';

      AppLogger.info(
        'Analyzing habit for health mapping: "${habit.name}" (category: ${habit.category})',
      );
      AppLogger.info('Search text: "$searchText"');

      // Find matching health data types
      final matches = <String, double>{};

      // Phase 1: Keyword-based matching
      for (final entry in healthMappings.entries) {
        final healthType = entry.key;
        final mapping = entry.value;

        // Skip MINDFULNESS if not supported by the current health service
        if (healthType == 'MINDFULNESS' && !await _isMindfulnessSupported()) {
          AppLogger.info(
            'Skipping MINDFULNESS mapping - not supported by current health service',
          );
          continue;
        }

        double relevanceScore = 0.0;
        int matchedKeywords = 0;

        // Check for keyword matches
        for (final keyword in mapping.keywords) {
          if (searchText.contains(keyword)) {
            relevanceScore += 1.0;
            matchedKeywords++;

            // Bonus for exact matches
            if (habitName == keyword || habitName.contains(keyword)) {
              relevanceScore += 0.5;
            }
          }
        }

        // Normalize score based on number of keywords
        if (relevanceScore > 0) {
          relevanceScore = relevanceScore / mapping.keywords.length;
          matches[healthType] = relevanceScore;
          AppLogger.info(
            'Health type $healthType matched with score $relevanceScore ($matchedKeywords keywords)',
          );
        }
      }

      // Phase 2: Category-based matching (enhanced)
      final category = habit.category.toLowerCase().trim();
      final categoryMatches = <String, double>{};

      // Direct category matching
      if (categoryMappings.containsKey(category)) {
        for (final categoryMapping in categoryMappings[category]!) {
          // Skip MINDFULNESS if not supported
          if (categoryMapping.healthDataType == 'MINDFULNESS' &&
              !await _isMindfulnessSupported()) {
            continue;
          }

          categoryMatches[categoryMapping.healthDataType] =
              categoryMapping.relevanceScore;
          AppLogger.info(
            'Category "$category" matched to ${categoryMapping.healthDataType} with score ${categoryMapping.relevanceScore}',
          );
        }
      }

      // Partial category matching (for compound categories like "health & fitness")
      for (final categoryKey in categoryMappings.keys) {
        if (category.contains(categoryKey) &&
            !categoryMatches.containsKey(categoryKey)) {
          for (final categoryMapping in categoryMappings[categoryKey]!) {
            // Skip MINDFULNESS if not supported
            if (categoryMapping.healthDataType == 'MINDFULNESS' &&
                !await _isMindfulnessSupported()) {
              continue;
            }

            // Use slightly lower score for partial matches
            final partialScore = categoryMapping.relevanceScore * 0.8;
            if (!categoryMatches.containsKey(categoryMapping.healthDataType) ||
                categoryMatches[categoryMapping.healthDataType]! <
                    partialScore) {
              categoryMatches[categoryMapping.healthDataType] = partialScore;
              AppLogger.info(
                'Partial category match "$categoryKey" in "$category" matched to ${categoryMapping.healthDataType} with score $partialScore',
              );
            }
          }
        }
      }

      // Combine keyword and category matches
      for (final entry in categoryMatches.entries) {
        final healthType = entry.key;
        final categoryScore = entry.value;

        if (matches.containsKey(healthType)) {
          // Combine scores: keyword match gets priority, category adds bonus
          matches[healthType] = matches[healthType]! + (categoryScore * 0.3);
          AppLogger.info(
            'Combined score for $healthType: keyword + category bonus = ${matches[healthType]}',
          );
        } else {
          // Use category score directly
          matches[healthType] = categoryScore;
          AppLogger.info('Category-only match for $healthType: $categoryScore');
        }
      }

      // Phase 3: Enhanced fuzzy matching for user-created habits
      if (matches.isEmpty) {
        AppLogger.info(
          'No direct matches found, trying fuzzy matching for habit: ${habit.name}',
        );

        // Try fuzzy matching with common variations and synonyms
        final fuzzyMatches = <String, double>{};

        for (final entry in healthMappings.entries) {
          final healthType = entry.key;
          final mapping = entry.value;

          // Skip MINDFULNESS if not supported
          if (healthType == 'MINDFULNESS' && !await _isMindfulnessSupported()) {
            continue;
          }

          double fuzzyScore = 0.0;

          // Check for partial word matches and common synonyms
          for (final keyword in mapping.keywords) {
            // Partial matching (e.g., "run" matches "running")
            if (searchText.contains(
              keyword.substring(0, (keyword.length * 0.7).round()),
            )) {
              fuzzyScore += 0.3;
            }

            // Check for common synonyms and variations
            fuzzyScore += _checkSynonyms(searchText, keyword, healthType);
          }

          if (fuzzyScore > 0) {
            fuzzyMatches[healthType] = fuzzyScore;
            AppLogger.info('Fuzzy match for $healthType: score $fuzzyScore');
          }
        }

        // Use fuzzy matches if found
        if (fuzzyMatches.isNotEmpty) {
          matches.addAll(fuzzyMatches);
        }
      }

      // Final fallback for unmapped habits
      if (matches.isEmpty) {
        AppLogger.info(
          'No health mappings found for habit: ${habit.name} (category: $category)',
        );
        AppLogger.info(
          'Consider adding keywords like: steps, walk, run, sleep, water, calories, exercise, meditation',
        );
        return null;
      }

      // Find the best match
      final bestMatch = matches.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      AppLogger.info(
        'Best match for habit "${habit.name}": ${bestMatch.key} (score: ${bestMatch.value})',
      );

      // Lower threshold for user-created habits to be more inclusive
      final minThreshold = matches.values.any((score) => score >= 0.3)
          ? 0.05
          : 0.02;

      if (bestMatch.value < minThreshold) {
        AppLogger.info(
          'Relevance score too low (${bestMatch.value}, min: $minThreshold) for habit: ${habit.name}',
        );
        return null; // Too weak correlation
      }

      // Try to extract custom threshold from habit name/description first
      final customThreshold = _extractCustomThreshold(
        searchText,
        bestMatch.key,
      );

      // Get the mapping for the best match
      final mapping = healthMappings[bestMatch.key]!;

      double threshold;
      String thresholdLevel;

      if (customThreshold != null) {
        // Use custom threshold extracted from habit text
        threshold = customThreshold;
        thresholdLevel = 'custom';
        AppLogger.info(
          'Using custom threshold for habit ${habit.name}: $threshold',
        );
      } else {
        // Determine appropriate threshold based on habit frequency and difficulty
        thresholdLevel = 'moderate'; // Default

        if (habit.frequency == HabitFrequency.daily) {
          thresholdLevel = 'moderate';
        } else if (habit.frequency == HabitFrequency.weekly) {
          thresholdLevel = 'active';
        } else if (habit.frequency == HabitFrequency.monthly) {
          thresholdLevel = 'very_active';
        }

        // Adjust based on habit name patterns
        if (searchText.contains('recovery') ||
            searchText.contains('rehab') ||
            searchText.contains('rehabilitation') ||
            searchText.contains('medical') ||
            searchText.contains('therapy') ||
            searchText.contains('physical therapy') ||
            searchText.contains('post-surgery') ||
            searchText.contains('healing') ||
            searchText.contains('injury') ||
            searchText.contains('limited mobility') ||
            searchText.contains('wheelchair') ||
            searchText.contains('assisted')) {
          thresholdLevel = 'recovery';
        } else if (searchText.contains('light') ||
            searchText.contains('easy') ||
            searchText.contains('gentle') ||
            searchText.contains('slow') ||
            searchText.contains('basic') ||
            searchText.contains('beginner')) {
          thresholdLevel = 'minimal';
        } else if (searchText.contains('intense') ||
            searchText.contains('hard') ||
            searchText.contains('vigorous') ||
            searchText.contains('challenging') ||
            searchText.contains('advanced') ||
            searchText.contains('high')) {
          thresholdLevel = 'very_active';
        }

        threshold =
            mapping.thresholds[thresholdLevel] ??
            mapping.thresholds['moderate']!;
      }

      final result = HabitHealthMapping(
        habitId: habit.id,
        healthDataType: bestMatch.key,
        threshold: threshold,
        thresholdLevel: thresholdLevel,
        relevanceScore: bestMatch.value,
        unit: mapping.unit,
        description: mapping.description,
      );

      AppLogger.info(
        'Created health mapping for habit "${habit.name}": ${bestMatch.key}, threshold: $threshold ($thresholdLevel)',
      );
      return result;
    } catch (e) {
      AppLogger.error(
        'Error analyzing habit for health mapping: ${habit.name}',
        e,
      );
      return null;
    }
  }

  /// Check if a habit should be auto-completed based on health data
  static Future<HabitCompletionResult> checkHabitCompletion({
    required Habit habit,
    required DateTime date,
    HabitHealthMapping? mapping,
  }) async {
    try {
      // Get or create mapping
      mapping ??= await analyzeHabitForHealthMapping(habit);

      if (mapping == null) {
        return HabitCompletionResult(
          shouldComplete: false,
          reason: 'No health mapping found for this habit',
        );
      }

      // Get health data for the specified date
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final healthData = await HealthService.getHealthDataFromTypes(
        types: [mapping.healthDataType],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      if (healthData.isEmpty) {
        // Special handling for medication habits that use WEIGHT as proxy
        if (mapping.healthDataType == 'WEIGHT') {
          // Check if this is actually a medication habit by looking at the habit name
          final habitName = habit.name.toLowerCase();
          if (habitName.contains('med') ||
              habitName.contains('pill') ||
              habitName.contains('tablet') ||
              habitName.contains('drug') ||
              habitName.contains('prescription') ||
              habitName.contains('vitamin') ||
              habitName.contains('supplement')) {
            return HabitCompletionResult(
              shouldComplete: false,
              reason:
                  'Medication habits require manual completion. Auto-completion is not available for medication tracking.',
            );
          }
        }

        // Provide specific guidance for water tracking
        if (mapping.healthDataType == 'WATER') {
          return HabitCompletionResult(
            shouldComplete: false,
            reason:
                'No water intake data found. Water must be manually logged in your health app (Apple Health, Google Health, etc.) to enable auto-completion.',
          );
        }

        // Special handling for mindfulness
        if (mapping.healthDataType == 'MINDFULNESS') {
          return HabitCompletionResult(
            shouldComplete: false,
            reason:
                'No mindfulness data found. Mindfulness sessions must be logged in your health app or meditation app to enable auto-completion.',
          );
        }

        // Special handling for heart rate
        if (mapping.healthDataType == 'HEART_RATE') {
          return HabitCompletionResult(
            shouldComplete: false,
            reason:
                'No heart rate data found. Heart rate must be monitored by a fitness tracker, smartwatch, or health app to enable auto-completion.',
          );
        }

        return HabitCompletionResult(
          shouldComplete: false,
          reason: 'No health data available for ${mapping.healthDataType}',
        );
      }

      // Calculate total value for the day
      double totalValue = 0.0;
      int dataPoints = 0;

      for (final point in healthData) {
        final value = (point['value'] as num?)?.toDouble() ?? 0.0;

        // Special handling for different health types
        switch (mapping.healthDataType) {
          case 'SLEEP_IN_BED':
            // Sleep is already in hours from our service
            totalValue += value;
            break;
          case 'WEIGHT':
            // For weight, just count measurements
            dataPoints++;
            totalValue = dataPoints.toDouble();
            break;
          case 'HEART_RATE':
            // For heart rate, we need to determine the appropriate metric
            // based on the habit type (exercise vs meditation)
            final habitName = habit.name.toLowerCase();
            final habitDescription = (habit.description ?? '').toLowerCase();
            final searchText = '$habitName $habitDescription';

            if (_isExerciseRelated(searchText)) {
              // For exercise habits, look for elevated heart rate
              if (value >= mapping.threshold) {
                dataPoints++;
                totalValue = math.max(totalValue, value); // Use peak heart rate
              }
            } else if (_isMeditationRelated(searchText)) {
              // For meditation habits, look for sustained periods of lower heart rate
              if (value <= mapping.threshold) {
                dataPoints++;
                totalValue += 1.0; // Count minutes of low heart rate
              }
            } else {
              // General heart rate monitoring - use average
              totalValue += value;
              dataPoints++;
            }
            break;
          default:
            totalValue += value;
        }
      }

      // Check if threshold is met
      final thresholdMet = totalValue >= mapping.threshold;

      if (thresholdMet) {
        String reason = _generateCompletionReason(mapping, totalValue);

        return HabitCompletionResult(
          shouldComplete: true,
          reason: reason,
          healthValue: totalValue,
          threshold: mapping.threshold,
          healthDataType: mapping.healthDataType,
          confidence: _calculateConfidence(
            mapping,
            totalValue,
            healthData.length,
          ),
        );
      } else {
        return HabitCompletionResult(
          shouldComplete: false,
          reason:
              'Threshold not met: ${totalValue.round()} ${mapping.unit} < ${mapping.threshold.round()} ${mapping.unit}',
          healthValue: totalValue,
          threshold: mapping.threshold,
          healthDataType: mapping.healthDataType,
        );
      }
    } catch (e) {
      AppLogger.error('Error checking habit completion for ${habit.name}', e);
      return HabitCompletionResult(
        shouldComplete: false,
        reason: 'Error checking health data: $e',
      );
    }
  }

  /// Generate a human-readable completion reason
  static String _generateCompletionReason(
    HabitHealthMapping mapping,
    double value,
  ) {
    final roundedValue = value.round();

    switch (mapping.healthDataType) {
      case 'STEPS':
        if (roundedValue >= 12000) {
          return 'Excellent! You walked $roundedValue steps today 🚶‍♂️';
        } else if (roundedValue >= 8000) {
          return 'Great job! You reached $roundedValue steps today 👟';
        } else {
          return 'You walked $roundedValue steps today ✅';
        }

      case 'ACTIVE_ENERGY_BURNED':
        if (roundedValue >= 600) {
          return 'Amazing workout! You burned $roundedValue calories 🔥';
        } else if (roundedValue >= 400) {
          return 'Great exercise session! $roundedValue calories burned 💪';
        } else {
          return 'You burned $roundedValue calories through activity 🏃‍♂️';
        }

      case 'TOTAL_CALORIES_BURNED':
        if (roundedValue >= 1200) {
          return 'Incredible! You burned $roundedValue total calories today 🔥🔥';
        } else if (roundedValue >= 800) {
          return 'Great job! You burned $roundedValue total calories today 💪';
        } else {
          return 'You burned $roundedValue total calories today 🏃‍♂️';
        }

      case 'SLEEP_IN_BED':
        final hours = (value * 10).round() / 10; // Round to 1 decimal
        if (hours >= 8.5) {
          return 'Excellent rest! You slept ${hours}h last night 😴';
        } else if (hours >= 7.5) {
          return 'Good sleep! You got ${hours}h of rest 🛏️';
        } else {
          return 'You slept ${hours}h last night 💤';
        }

      case 'WATER':
        final liters =
            (value / 1000 * 10).round() /
            10; // Convert to liters, round to 1 decimal
        if (liters >= 3.0) {
          return 'Excellent hydration! You drank ${liters}L of water 💧';
        } else if (liters >= 2.0) {
          return 'Great hydration! ${liters}L of water consumed 🥤';
        } else {
          return 'You drank ${liters}L of water today 💦';
        }

      case 'MINDFULNESS':
        if (roundedValue >= 30) {
          return 'Deep meditation! You practiced for $roundedValue minutes 🧘‍♂️';
        } else if (roundedValue >= 15) {
          return 'Great mindfulness session! $roundedValue minutes of practice 🧘‍♀️';
        } else {
          return 'You meditated for $roundedValue minutes today ☮️';
        }

      case 'WEIGHT':
        return 'Weight tracked successfully! 📊';

      default:
        return 'Health goal achieved! $roundedValue ${mapping.unit} ✅';
    }
  }

  /// Calculate confidence score for the completion
  static double _calculateConfidence(
    HabitHealthMapping mapping,
    double value,
    int dataPointCount,
  ) {
    double confidence = 0.5; // Base confidence

    // Higher confidence for more data points
    if (dataPointCount >= 5) {
      confidence += 0.2;
    } else if (dataPointCount >= 3) {
      confidence += 0.1;
    }

    // Higher confidence for exceeding threshold significantly
    final exceedanceRatio = value / mapping.threshold;
    if (exceedanceRatio >= 1.5) {
      confidence += 0.2;
    } else if (exceedanceRatio >= 1.2) {
      confidence += 0.1;
    }

    // Higher confidence for high relevance score
    if (mapping.relevanceScore >= 0.8) {
      confidence += 0.1;
    }

    return math.min(confidence, 1.0);
  }

  /// Get all habits that can be mapped to health data
  static Future<List<HabitHealthMapping>> getMappableHabits(
    List<Habit> habits,
  ) async {
    final mappings = <HabitHealthMapping>[];

    for (final habit in habits) {
      final mapping = await analyzeHabitForHealthMapping(habit);
      if (mapping != null) {
        mappings.add(mapping);
      }
    }

    return mappings;
  }

  /// Get health data types that are actively used by habits
  static Future<Set<String>> getActiveHealthDataTypes(
    List<Habit> habits,
  ) async {
    final activeTypes = <String>{};

    for (final habit in habits) {
      final mapping = await analyzeHabitForHealthMapping(habit);
      if (mapping != null) {
        activeTypes.add(mapping.healthDataType);
      }
    }

    return activeTypes;
  }

  /// Suggest optimal thresholds for a habit based on user's historical health data
  static Future<Map<String, double>> suggestOptimalThresholds({
    required Habit habit,
    required String healthDataType,
    int analysisWindowDays = 30,
  }) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: analysisWindowDays));

      final healthData = await HealthService.getHealthDataFromTypes(
        types: [healthDataType],
        startTime: startDate,
        endTime: endDate,
      );

      if (healthData.length < 7) {
        // Not enough data, return default thresholds
        return healthMappings[healthDataType]?.thresholds ?? {};
      }

      // Calculate daily values
      final dailyValues = <DateTime, double>{};

      for (final point in healthData) {
        final timestamp =
            point['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch;
        final day = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final dayKey = DateTime(day.year, day.month, day.day);
        final value = (point['value'] as num?)?.toDouble() ?? 0.0;

        dailyValues[dayKey] = (dailyValues[dayKey] ?? 0) + value;
      }

      final values = dailyValues.values.toList()..sort();

      if (values.isEmpty) {
        return healthMappings[healthDataType]?.thresholds ?? {};
      }

      // Calculate percentile-based thresholds
      final suggestions = <String, double>{};

      suggestions['minimal'] = _getPercentile(values, 25); // 25th percentile
      suggestions['moderate'] = _getPercentile(
        values,
        50,
      ); // 50th percentile (median)
      suggestions['active'] = _getPercentile(values, 75); // 75th percentile
      suggestions['very_active'] = _getPercentile(
        values,
        90,
      ); // 90th percentile

      return suggestions;
    } catch (e) {
      AppLogger.error('Error suggesting optimal thresholds', e);
      return healthMappings[healthDataType]?.thresholds ?? {};
    }
  }

  /// Calculate percentile value from a sorted list
  static double _getPercentile(List<double> sortedValues, int percentile) {
    if (sortedValues.isEmpty) return 0.0;

    final index = (percentile / 100.0 * (sortedValues.length - 1)).round();
    return sortedValues[index.clamp(0, sortedValues.length - 1)];
  }

  /// Check for synonyms and common variations
  static double _checkSynonyms(
    String searchText,
    String keyword,
    String healthType,
  ) {
    double score = 0.0;

    // Define synonym groups for different health types
    final synonyms = <String, List<String>>{
      'STEPS': [
        'walk',
        'walking',
        'stroll',
        'hike',
        'hiking',
        'pace',
        'pacing',
        'move',
        'movement',
      ],
      'ACTIVE_ENERGY_BURNED': [
        'workout',
        'exercise',
        'fitness',
        'training',
        'cardio',
        'burn',
        'activity',
      ],
      'TOTAL_CALORIES_BURNED': [
        'calories',
        'energy',
        'burn',
        'metabolism',
        'diet',
        'nutrition',
      ],
      'SLEEP_IN_BED': ['rest', 'nap', 'bedtime', 'slumber', 'snooze', 'doze'],
      'WATER': ['drink', 'hydrate', 'hydration', 'fluid', 'liquid', 'h2o'],
      'WEIGHT': [
        'weigh',
        'scale',
        'mass',
        'body weight',
        'weight loss',
        'weight gain',
      ],
      'MINDFULNESS': [
        'meditate',
        'meditation',
        'mindful',
        'zen',
        'calm',
        'relax',
        'breathe',
        'breathing',
      ],
      'HEART_RATE': ['heart', 'pulse', 'bpm', 'cardio', 'cardiovascular'],
    };

    if (synonyms.containsKey(healthType)) {
      for (final synonym in synonyms[healthType]!) {
        if (searchText.contains(synonym)) {
          score += 0.4; // Good synonym match
          break; // Only count one synonym match per type
        }
      }
    }

    // Check for common activity patterns
    if (healthType == 'STEPS') {
      if (searchText.contains('10000') ||
          searchText.contains('10k') ||
          searchText.contains('daily walk') ||
          searchText.contains('morning walk')) {
        score += 0.5;
      }
    }

    if (healthType == 'WATER') {
      if (searchText.contains('8 glasses') ||
          searchText.contains('2 liters') ||
          searchText.contains('daily water') ||
          searchText.contains('drink water')) {
        score += 0.5;
      }
    }

    if (healthType == 'SLEEP_IN_BED') {
      if (searchText.contains('8 hours') ||
          searchText.contains('early bed') ||
          searchText.contains('good sleep') ||
          searchText.contains('sleep schedule')) {
        score += 0.5;
      }
    }

    return score;
  }

  /// Get comprehensive mapping statistics
  static Future<Map<String, dynamic>> getMappingStatistics(
    List<Habit> habits,
  ) async {
    final stats = <String, dynamic>{};

    try {
      final mappings = await getMappableHabits(habits);

      stats['totalHabits'] = habits.length;
      stats['mappableHabits'] = mappings.length;
      stats['mappingPercentage'] = habits.isNotEmpty
          ? (mappings.length / habits.length * 100).round()
          : 0;

      // Count by health data type
      final typeCount = <String, int>{};
      for (final mapping in mappings) {
        final typeName = mapping.healthDataType;
        typeCount[typeName] = (typeCount[typeName] ?? 0) + 1;
      }
      stats['mappingsByType'] = typeCount;

      // Average relevance score
      if (mappings.isNotEmpty) {
        final avgRelevance =
            mappings.map((m) => m.relevanceScore).reduce((a, b) => a + b) /
            mappings.length;
        stats['averageRelevanceScore'] = (avgRelevance * 100).round();
      }

      // Most common health data types
      final sortedTypes = typeCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      stats['mostCommonTypes'] = sortedTypes
          .take(3)
          .map((e) => {'type': e.key, 'count': e.value})
          .toList();
    } catch (e) {
      AppLogger.error('Error calculating mapping statistics', e);
      stats['error'] = e.toString();
    }

    return stats;
  }

  /// Check if a habit should be recommended for manual tracking instead of health integration
  static bool shouldRecommendManualTracking(Habit habit) {
    final searchText = '${habit.name} ${habit.description ?? ''}'.toLowerCase();

    // Water habits are often better tracked manually due to lack of automatic tracking
    if (searchText.contains(RegExp(r'\b(water|hydrat|drink|fluid)\b'))) {
      return true;
    }

    // Other habits that might be better tracked manually
    // (can be expanded based on user feedback)

    return false;
  }

  /// Check if a habit appears to be for medical/recovery purposes
  static bool isMedicalRecoveryHabit(Habit habit) {
    final searchText = '${habit.name} ${habit.description ?? ''}'.toLowerCase();

    return searchText.contains('recovery') ||
        searchText.contains('rehab') ||
        searchText.contains('rehabilitation') ||
        searchText.contains('medical') ||
        searchText.contains('therapy') ||
        searchText.contains('physical therapy') ||
        searchText.contains('post-surgery') ||
        searchText.contains('healing') ||
        searchText.contains('injury') ||
        searchText.contains('limited mobility') ||
        searchText.contains('wheelchair') ||
        searchText.contains('assisted') ||
        searchText.contains('walker') ||
        searchText.contains('cane');
  }

  /// Get recommended step ranges for different user types
  static Map<String, Map<String, dynamic>> getStepRecommendations() {
    return {
      'recovery': {
        'range': '50-1000 steps',
        'description':
            'For medical recovery, rehabilitation, or limited mobility',
        'examples': [
          'Post-surgery walking',
          'Physical therapy steps',
          'Assisted mobility',
        ],
        'threshold': 500,
      },
      'minimal': {
        'range': '1000-3000 steps',
        'description': 'For beginners or light activity',
        'examples': ['Gentle daily walk', 'Basic movement', 'Light exercise'],
        'threshold': 2000,
      },
      'moderate': {
        'range': '3000-7000 steps',
        'description': 'For regular daily activity',
        'examples': ['Daily walk', 'Regular movement', 'Moderate exercise'],
        'threshold': 5000,
      },
      'active': {
        'range': '7000-10000 steps',
        'description': 'For active lifestyle',
        'examples': ['Brisk walking', 'Active commuting', 'Regular exercise'],
        'threshold': 8000,
      },
      'very_active': {
        'range': '10000+ steps',
        'description': 'For very active individuals',
        'examples': ['Long walks', 'Running', 'High activity'],
        'threshold': 12000,
      },
    };
  }

  /// Get category suggestions for better health mapping
  static List<String> getCategorySuggestions(
    String habitName,
    String? habitDescription,
  ) {
    final searchText = '$habitName ${habitDescription ?? ''}'.toLowerCase();
    final suggestions = <String>[];

    // Analyze the habit text and suggest appropriate categories
    for (final entry in categoryMappings.entries) {
      final category = entry.key;
      final mappings = entry.value;

      // Check if any keywords from the health mappings match this habit
      for (final mapping in mappings) {
        final healthMapping = healthMappings[mapping.healthDataType];
        if (healthMapping != null) {
          for (final keyword in healthMapping.keywords) {
            if (searchText.contains(keyword)) {
              if (!suggestions.contains(category)) {
                suggestions.add(category);
              }
              break;
            }
          }
        }
      }
    }

    // Sort by relevance (categories with higher scoring mappings first)
    suggestions.sort((a, b) {
      final aMaxScore =
          categoryMappings[a]
              ?.map((m) => m.relevanceScore)
              .reduce((a, b) => a > b ? a : b) ??
          0.0;
      final bMaxScore =
          categoryMappings[b]
              ?.map((m) => m.relevanceScore)
              .reduce((a, b) => a > b ? a : b) ??
          0.0;
      return bMaxScore.compareTo(aMaxScore);
    });

    return suggestions.take(5).toList(); // Return top 5 suggestions
  }

  /// Get all available health-related categories
  static List<String> getHealthRelatedCategories() {
    return categoryMappings.keys.toList()..sort();
  }

  /// Get health data types that a category can map to
  static List<String> getHealthDataTypesForCategory(String category) {
    final mappings = categoryMappings[category.toLowerCase()];
    if (mappings == null) return [];

    return mappings.map((m) => m.healthDataType).toList();
  }

  /// Check if mindfulness data type is supported by the current health service
  static Future<bool> _isMindfulnessSupported() async {
    try {
      // Check if the health service supports mindfulness
      // Since we're using real data only, check if health service has permissions
      final hasPermissions = await HealthService.hasPermissions();

      // Only return true if we have real health permissions and platform supports it
      if (hasPermissions) {
        // Check if platform supports mindfulness (typically iOS and Android)
        return Platform.isAndroid || Platform.isIOS;
      }

      // Default to false for safety (mindfulness often has platform restrictions)
      return false;
    } catch (e) {
      AppLogger.error('Error checking mindfulness support', e);
      return false; // Default to not supported on error
    }
  }

  /// Extract custom threshold from habit name/description
  static double? _extractCustomThreshold(String searchText, String healthType) {
    try {
      // Define patterns for different health data types
      List<RegExp> patterns = [];

      switch (healthType) {
        case 'STEPS':
          patterns = [
            RegExp(r'(\d+)\s*steps?', caseSensitive: false),
            RegExp(r'(\d+)\s*step', caseSensitive: false),
            RegExp(r'walk\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*walk', caseSensitive: false),
            // Medical/recovery specific patterns
            RegExp(r'at least\s*(\d+)', caseSensitive: false),
            RegExp(r'minimum\s*(\d+)', caseSensitive: false),
            RegExp(r'target\s*(\d+)', caseSensitive: false),
            RegExp(r'goal\s*(\d+)', caseSensitive: false),
            // Very low numbers for recovery
            RegExp(r'(\d{1,3})\s*(?:steps?|walk)', caseSensitive: false),
          ];
          break;
        case 'ACTIVE_ENERGY_BURNED':
          patterns = [
            RegExp(r'(\d+)\s*cal(?:ories?)?', caseSensitive: false),
            RegExp(r'burn\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*burn', caseSensitive: false),
          ];
          break;

        case 'TOTAL_CALORIES_BURNED':
          patterns = [
            RegExp(r'(\d+)\s*cal(?:ories?)?', caseSensitive: false),
            RegExp(r'burn\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*burn', caseSensitive: false),
            RegExp(r'total\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*total', caseSensitive: false),
          ];
          break;
        case 'WATER':
          patterns = [
            RegExp(r'(\d+)\s*ml', caseSensitive: false),
            RegExp(r'(\d+)\s*l(?:iter)?s?', caseSensitive: false),
            RegExp(r'(\d+)\s*cup', caseSensitive: false),
            RegExp(r'drink\s*(\d+)', caseSensitive: false),
          ];
          break;
        case 'MINDFULNESS':
          patterns = [
            RegExp(r'(\d+)\s*min(?:ute)?s?', caseSensitive: false),
            RegExp(r'meditate\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*meditation', caseSensitive: false),
          ];
          break;
        case 'SLEEP_IN_BED':
          patterns = [
            RegExp(r'(\d+)\s*h(?:our)?s?', caseSensitive: false),
            RegExp(r'sleep\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*sleep', caseSensitive: false),
          ];
          break;
        default:
          return null;
      }

      // Try to find a match with any of the patterns
      for (final pattern in patterns) {
        final match = pattern.firstMatch(searchText);
        if (match != null && match.group(1) != null) {
          final value = double.tryParse(match.group(1)!);
          if (value != null && value > 0) {
            // Apply unit conversions if needed
            switch (healthType) {
              case 'WATER':
                // Convert liters to ml if needed
                if (searchText.toLowerCase().contains('l') &&
                    !searchText.toLowerCase().contains('ml')) {
                  return value * 1000; // Convert liters to ml
                }
                return value;
              case 'SLEEP_IN_BED':
                // Sleep is stored in hours
                return value;
              default:
                return value;
            }
          }
        }
      }

      return null;
    } catch (e) {
      AppLogger.error('Error extracting custom threshold from: $searchText', e);
      return null;
    }
  }

  /// Check if a habit is exercise-related based on keywords
  static bool _isExerciseRelated(String searchText) {
    const exerciseKeywords = [
      'exercise',
      'workout',
      'training',
      'fitness',
      'gym',
      'cardio',
      'run',
      'running',
      'jog',
      'jogging',
      'bike',
      'biking',
      'cycle',
      'cycling',
      'swim',
      'swimming',
      'aerobic',
      'aerobics',
      'hiit',
      'interval',
      'strength',
      'weights',
      'lifting',
      'crossfit',
      'pilates',
      'yoga',
      'dance',
      'dancing',
      'boxing',
      'kickboxing',
      'martial',
      'sports',
      'tennis',
      'basketball',
      'football',
      'soccer',
      'volleyball',
      'hike',
      'hiking',
      'climb',
      'climbing',
      'ski',
      'skiing',
      'intense',
      'vigorous',
      'active',
      'activity',
      'sweat',
      'sweating',
    ];

    return exerciseKeywords.any((keyword) => searchText.contains(keyword));
  }

  /// Check if a habit is meditation/relaxation-related based on keywords
  static bool _isMeditationRelated(String searchText) {
    const meditationKeywords = [
      'meditate',
      'meditation',
      'mindful',
      'mindfulness',
      'zen',
      'calm',
      'calming',
      'peace',
      'peaceful',
      'tranquil',
      'breathe',
      'breathing',
      'breath',
      'relax',
      'relaxation',
      'unwind',
      'stress',
      'anxiety',
      'worry',
      'focus',
      'concentration',
      'awareness',
      'present',
      'moment',
      'spiritual',
      'prayer',
      'pray',
      'gratitude',
      'grateful',
      'thankful',
      'reflection',
      'contemplate',
      'introspect',
      'journal',
      'journaling',
      'tai',
      'chi',
      'qigong',
      'vipassana',
      'samatha',
      'loving',
      'kindness',
      'compassion',
      'metta',
      'mantra',
      'guided',
      'silent',
      'retreat',
    ];

    return meditationKeywords.any((keyword) => searchText.contains(keyword));
  }
}

/// Health-habit mapping configuration
class HealthHabitMapping {
  final List<String> keywords;
  final Map<String, double> thresholds;
  final String unit;
  final String description;

  const HealthHabitMapping({
    required this.keywords,
    required this.thresholds,
    required this.unit,
    required this.description,
  });
}

/// Individual habit-health mapping
class HabitHealthMapping {
  final String habitId;
  final String healthDataType;
  final double threshold;
  final String thresholdLevel;
  final double relevanceScore;
  final String unit;
  final String description;

  HabitHealthMapping({
    required this.habitId,
    required this.healthDataType,
    required this.threshold,
    required this.thresholdLevel,
    required this.relevanceScore,
    required this.unit,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'habitId': habitId,
    'healthDataType': healthDataType,
    'threshold': threshold,
    'thresholdLevel': thresholdLevel,
    'relevanceScore': relevanceScore,
    'unit': unit,
    'description': description,
  };
}

/// Category to health data type mapping
class CategoryHealthMapping {
  final String healthDataType;
  final double relevanceScore;
  final String reason;

  const CategoryHealthMapping(
    this.healthDataType,
    this.relevanceScore,
    this.reason,
  );
}

/// Result of habit completion check
class HabitCompletionResult {
  final bool shouldComplete;
  final String reason;
  final double? healthValue;
  final double? threshold;
  final String? healthDataType;
  final double confidence;

  HabitCompletionResult({
    required this.shouldComplete,
    required this.reason,
    this.healthValue,
    this.threshold,
    this.healthDataType,
    this.confidence = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'shouldComplete': shouldComplete,
    'reason': reason,
    'healthValue': healthValue,
    'threshold': threshold,
    'healthDataType': healthDataType,
    'confidence': confidence,
  };
}
