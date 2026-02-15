class ValidationUtils {
  ValidationUtils._();

  static const int _minPasswordLength = 8;
  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );
  static final RegExp _nameRegex = RegExp(r'^[가-힣a-zA-Z\s]+$');
  static final RegExp _phoneRegex = RegExp(r'^01[0-9]-?\d{3,4}-?\d{4}$');
  static final RegExp _numberRegex = RegExp(r'^\d+$');

  static String? required(String? value, {String fieldName = '값'}) {
    if ((value ?? '').trim().isEmpty) {
      return '$fieldName을(를) 입력해주세요.';
    }
    return null;
  }

  static String? name(String? value, {String fieldName = '이름'}) {
    final requiredError = required(value, fieldName: fieldName);
    if (requiredError != null) {
      return requiredError;
    }

    final trimmedValue = value!.trim();
    if (!_nameRegex.hasMatch(trimmedValue)) {
      return '$fieldName은(는) 한글/영문/공백만 사용할 수 있어요.';
    }
    return null;
  }

  static String? email(String? value, {bool isRequired = true}) {
    final trimmedValue = (value ?? '').trim();
    if (trimmedValue.isEmpty) {
      return isRequired ? '이메일을 입력해주세요.' : null;
    }

    if (!_emailRegex.hasMatch(trimmedValue)) {
      return '올바른 이메일 형식이 아니에요.';
    }
    return null;
  }

  static String? phone(String? value, {bool isRequired = true}) {
    final trimmedValue = (value ?? '').trim();
    if (trimmedValue.isEmpty) {
      return isRequired ? '전화번호를 입력해주세요.' : null;
    }

    if (!_phoneRegex.hasMatch(trimmedValue)) {
      return '전화번호 형식을 확인해주세요.';
    }
    return null;
  }

  static String? password(String? value, {bool isRequired = true}) {
    final trimmedValue = (value ?? '').trim();
    if (trimmedValue.isEmpty) {
      return isRequired ? '비밀번호를 입력해주세요.' : null;
    }

    if (trimmedValue.length < _minPasswordLength) {
      return '비밀번호는 $_minPasswordLength자 이상이어야 해요.';
    }
    return null;
  }

  static String? number(
    String? value, {
    String fieldName = '숫자',
    bool isRequired = true,
    int? min,
    int? max,
  }) {
    final trimmedValue = (value ?? '').trim();
    if (trimmedValue.isEmpty) {
      return isRequired ? '$fieldName을(를) 입력해주세요.' : null;
    }
    if (!_numberRegex.hasMatch(trimmedValue)) {
      return '$fieldName은(는) 숫자만 입력할 수 있어요.';
    }

    final parsedValue = int.tryParse(trimmedValue);
    if (parsedValue == null) {
      return '$fieldName이(가) 올바르지 않아요.';
    }

    if (min != null && parsedValue < min) {
      return '$fieldName은(는) $min 이상이어야 해요.';
    }
    if (max != null && parsedValue > max) {
      return '$fieldName은(는) $max 이하여야 해요.';
    }
    return null;
  }

  static String? temperature(
    String? value, {
    double min = 35.0,
    double max = 42.0,
    bool isRequired = true,
  }) {
    final trimmedValue = (value ?? '').trim();
    if (trimmedValue.isEmpty) {
      return isRequired ? '체온을 입력해주세요.' : null;
    }

    final parsedValue = double.tryParse(trimmedValue);
    if (parsedValue == null) {
      return '체온은 숫자로 입력해주세요.';
    }
    if (parsedValue < min || parsedValue > max) {
      return '체온은 $min°C ~ $max°C 범위여야 해요.';
    }
    return null;
  }
}
