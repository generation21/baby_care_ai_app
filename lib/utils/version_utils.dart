/// 버전 문자열을 비교하기 위한 유틸리티 클래스
class VersionUtils {
  /// 두 버전 문자열을 비교합니다.
  ///
  /// []이 []보다 크면 양수,
  /// []이 []보다 작으면 음수,
  /// 두 버전이 같으면 0을 반환합니다.
  ///
  /// 예시:
  /// ```dart
  /// VersionUtils.isUpdateRequired('1.0.0', '1.0.1')  // true
  /// VersionUtils.isUpdateRequired('1.0.0', '1.0.0') // false
  /// VersionUtils.isUpdateRequired('1.0.1', '1.0.0')  // false
  /// VersionUtils.isUpdateRequired('2.0.0', '1.9.9')  // false
  /// ```isUpdateRequired
  static bool isUpdateRequired(String oldVersion, String newVersion) {
    final oldParts = oldVersion.split('.').map(int.parse).toList();
    final newParts = newVersion.split('.').map(int.parse).toList();

    // 버전 부분의 길이를 맞춰줍니다 (예: 1.0과 1.0.0을 비교할 수 있도록)
    while (oldParts.length < newParts.length) {
      oldParts.add(0);
    }
    while (newParts.length < oldParts.length) {
      newParts.add(0);
    }

    // 각 부분을 순서대로 비교합니다
    for (var i = 0; i < oldParts.length; i++) {
      if (oldParts[i] > newParts[i]) {
        return false;
      }
      if (oldParts[i] < newParts[i]) {
        return true;
      }
    }

    return false;
  }
}
