import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepster/utils/calorie_calculator.dart'; // Assuming your calculator is in this path

void main() {

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      MethodChannel('logger'),
          (MethodCall methodCall) async => null,
    );
  });

  group('CaloriesCalculator Tests', () {
    final CaloriesCalculator calculator = CaloriesCalculator();

    test('[Test] calculateCalories(): Male, 30 years old, medium life quality (default).', () async {
      final calories = await calculator.calculateCalories(gender: Gender.male, age: 30);
      expect(calories, calorieGuidelines['male']!['25-50 years']![LifeQuality.medium]);
    });

    test('[Test] calculateCalories(): Female, 20 years old, high life quality.', () async {
      final calories = await calculator.calculateCalories(
          gender: Gender.female, age: 20, lifeQuality: LifeQuality.high);
      expect(calories, calorieGuidelines['female']!['18-24 years']![LifeQuality.high]);
    });

    test('[Test] calculateCalories(): Male, 75 years old, low life quality.', () async {
      final calories = await calculator.calculateCalories(
          gender: Gender.male, age: 75, lifeQuality: LifeQuality.low);
      expect(calories, calorieGuidelines['male']!['>70 years']![LifeQuality.low]);
    });

    test('[Test] calculateCalories(): Female child, 5 years old (medium assumed).', () async {
      final calories = await calculator.calculateCalories(gender: Gender.female, age: 5);
      expect(calories, calorieGuidelines['female']!['4-6 years']![LifeQuality.medium]);
    });

    test('[Test] calculateCalories(): Male teenager, 16 years old (medium assumed).', () async {
      final calories = await calculator.calculateCalories(gender: Gender.male, age: 16);
      expect(calories, calorieGuidelines['male']!['15-17 years']![LifeQuality.medium]);
    });

    test('[Test] calculateCalories(): Age outside defined ranges (should return default).', () async {
      final calories = await calculator.calculateCalories(gender: Gender.female, age: 100);
      expect(calories, 2000);
    });
  });
}