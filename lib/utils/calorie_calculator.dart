import 'package:prepster/utils/logger.dart';

enum Gender {
  female,
  male
}


enum LifeQuality {
  low,
  medium,
  high
}


const calorieGuidelines = {
  'female': {
    '1-3 years': {
      LifeQuality.low: 1100,
      LifeQuality.medium: 1100,
      LifeQuality.high: 1100,
    },
    '4-6 years': {
      LifeQuality.low: 1510,
      LifeQuality.medium: 1510,
      LifeQuality.high: 1510,
    },
    '7-10 years': {
      LifeQuality.low: 1860,
      LifeQuality.medium: 1860,
      LifeQuality.high: 1860,
    },
    '11-14 years': {
      LifeQuality.low: 2200,
      LifeQuality.medium: 2200,
      LifeQuality.high: 2200,
    },
    '15-17 years': {
      LifeQuality.low: 2410,
      LifeQuality.medium: 2410,
      LifeQuality.high: 2410,
    },
    '18-24 years': {
      LifeQuality.low: 2000,
      LifeQuality.medium: 2200,
      LifeQuality.high: 2500,
    },
    '25-50 years': {
      LifeQuality.low: 1900,
      LifeQuality.medium: 2200,
      LifeQuality.high: 2400,
    },
    '51-70 years': {
      LifeQuality.low: 1700,
      LifeQuality.medium: 2000,
      LifeQuality.high: 2200,
    },
    '>70 years': {
      LifeQuality.low: 1700,
      LifeQuality.medium: 2000,
      LifeQuality.high: 2200,
    },
  },
  'male': {
    '1-3 years': {
      LifeQuality.low: 1100,
      LifeQuality.medium: 1100,
      LifeQuality.high: 1100,
    },
    '4-6 years': {
      LifeQuality.low: 1510,
      LifeQuality.medium: 1510,
      LifeQuality.high: 1510,
    },
    '7-10 years': {
      LifeQuality.low: 1860,
      LifeQuality.medium: 1860,
      LifeQuality.high: 1860,
    },
    '11-14 years': {
      LifeQuality.low: 2510,
      LifeQuality.medium: 2510,
      LifeQuality.high: 2510,
    },
    '15-17 years': {
      LifeQuality.low: 3040,
      LifeQuality.medium: 3040,
      LifeQuality.high: 3040,
    },
    '18-24 years': {
      LifeQuality.low: 2500,
      LifeQuality.medium: 2800,
      LifeQuality.high: 3200,
    },
    '25-50 years': {
      LifeQuality.low: 2400,
      LifeQuality.medium: 2700,
      LifeQuality.high: 3000,
    },
    '51-70 years': {
      LifeQuality.low: 2200,
      LifeQuality.medium: 2500,
      LifeQuality.high: 2800,
    },
    '>70 years': {
      LifeQuality.low: 2100,
      LifeQuality.medium: 2400,
      LifeQuality.high: 2700,
    },
  },
};


class CaloriesCalculator{

  Future<int> calculateCalories({
    required Gender gender,
    required int age,
    LifeQuality lifeQuality = LifeQuality.medium
  }) async {

    final ageGroup = _getAgeGroup(age);

    if (calorieGuidelines.containsKey(gender.name) &&
      calorieGuidelines[gender.name]!.containsKey(ageGroup) &&
      calorieGuidelines[gender.name]![ageGroup]!.containsKey(lifeQuality)){

      int caloriesNeeded = calorieGuidelines[gender.name]![ageGroup]![lifeQuality]!;
      logger.i('Calories needed per day is: $caloriesNeeded, for a ${gender.name} aged $age with life quality set to ${lifeQuality.name}.');
      return caloriesNeeded;
    } else{
      logger.e('Warning: Calorie guideline not found for $gender, age $age, life quality: $lifeQuality.'
          '\n Default value of 2000 calories will be used instead.');
      return 2000;
    }
  }

  String _getAgeGroup(int age) {
    if (age >= 1 && age <= 3) {
      return '1-3 years';
    } else if (age >= 4 && age <= 6) {
      return '4-6 years';
    } else if (age >= 7 && age <= 10) {
      return '7-10 years';
    } else if (age >= 11 && age <= 14) {
      return '11-14 years';
    } else if (age >= 15 && age <= 17) {
      return '15-17 years';
    } else if (age >= 18 && age <= 24) {
      return '18-24 years';
    } else if (age >= 25 && age <= 50) {
      return '25-50 years';
    } else if (age >= 51 && age <= 70) {
      return '51-70 years';
    } else {
      return '>70 years';
    }
  }
}