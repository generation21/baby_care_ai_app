class BabyAgeUtils {
  static const int _daysPerMonth = 30;
  static const int _daysPerYear = 365;

  const BabyAgeUtils._();

  static int calculateAgeInDays(String birthDate) {
    final parsedBirthDate = DateTime.tryParse(birthDate);
    if (parsedBirthDate == null) {
      return 0;
    }

    final now = DateTime.now();
    final normalizedBirthDate = DateTime(
      parsedBirthDate.year,
      parsedBirthDate.month,
      parsedBirthDate.day,
    );
    final normalizedNow = DateTime(now.year, now.month, now.day);
    final difference = normalizedNow.difference(normalizedBirthDate).inDays;
    return difference < 0 ? 0 : difference;
  }

  static String formatAgeInDaysAndMonths(String birthDate) {
    final ageInDays = calculateAgeInDays(birthDate);
    if (ageInDays < _daysPerMonth) {
      return '$ageInDays일';
    }

    if (ageInDays < _daysPerYear) {
      final ageInMonths = ageInDays ~/ _daysPerMonth;
      return '$ageInMonths개월';
    }

    final ageInYears = ageInDays ~/ _daysPerYear;
    final remainingDays = ageInDays % _daysPerYear;
    final remainingMonths = remainingDays ~/ _daysPerMonth;

    if (remainingMonths == 0) {
      return '$ageInYears세';
    }
    return '$ageInYears세 $remainingMonths개월';
  }
}
