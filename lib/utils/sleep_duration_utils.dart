class SleepDurationUtils {
  static const int _minutesPerHour = 60;

  const SleepDurationUtils._();

  static int? calculateDurationMinutes(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return null;
    }
    final difference = end.difference(start).inMinutes;
    return difference < 0 ? null : difference;
  }

  static String formatDuration(DateTime? start, DateTime? end) {
    final durationMinutes = calculateDurationMinutes(start, end);
    if (durationMinutes == null) {
      return '수면 시간을 계산할 수 없습니다';
    }

    final hours = durationMinutes ~/ _minutesPerHour;
    final minutes = durationMinutes % _minutesPerHour;

    if (hours == 0) {
      return '$minutes분';
    }
    return '$hours시간 $minutes분';
  }
}
