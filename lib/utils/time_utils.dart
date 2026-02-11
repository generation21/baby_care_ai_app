import 'package:intl/intl.dart';

/// 시간 관련 유틸리티 함수
class TimeUtils {
  /// 상대 시간 표시 (예: "2분 전", "3시간 전", "어제")
  /// 
  /// [dateTime] 표시할 시간
  /// [locale] 언어 설정 (기본값: 'ko')
  static String getRelativeTime(DateTime dateTime, {String locale = 'ko'}) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // 미래 시간인 경우
    if (difference.isNegative) {
      return locale == 'ko' ? '방금 전' : 'just now';
    }

    // 1분 미만
    if (difference.inSeconds < 60) {
      return locale == 'ko' ? '방금 전' : 'just now';
    }

    // 1시간 미만
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return locale == 'ko' ? '$minutes분 전' : '$minutes min ago';
    }

    // 24시간 미만
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return locale == 'ko' ? '$hours시간 전' : '$hours hr ago';
    }

    // 7일 미만
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return locale == 'ko' ? '$days일 전' : '$days day${days > 1 ? 's' : ''} ago';
    }

    // 30일 미만
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return locale == 'ko' ? '$weeks주 전' : '$weeks week${weeks > 1 ? 's' : ''} ago';
    }

    // 365일 미만
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return locale == 'ko' ? '$months개월 전' : '$months month${months > 1 ? 's' : ''} ago';
    }

    // 1년 이상
    final years = (difference.inDays / 365).floor();
    return locale == 'ko' ? '$years년 전' : '$years year${years > 1 ? 's' : ''} ago';
  }

  /// ISO 8601 문자열을 상대 시간으로 변환
  static String getRelativeTimeFromString(String dateTimeString, {String locale = 'ko'}) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return getRelativeTime(dateTime, locale: locale);
    } catch (e) {
      return locale == 'ko' ? '알 수 없음' : 'unknown';
    }
  }

  /// 시간을 포맷팅 (예: "오후 3:24")
  static String formatTime(DateTime dateTime, {String locale = 'ko'}) {
    if (locale == 'ko') {
      final formatter = DateFormat('a h:mm', 'ko_KR');
      return formatter.format(dateTime);
    } else {
      final formatter = DateFormat('h:mm a');
      return formatter.format(dateTime);
    }
  }

  /// 날짜를 포맷팅 (예: "2024년 2월 12일")
  static String formatDate(DateTime dateTime, {String locale = 'ko'}) {
    if (locale == 'ko') {
      final formatter = DateFormat('yyyy년 M월 d일', 'ko_KR');
      return formatter.format(dateTime);
    } else {
      final formatter = DateFormat('MMMM d, yyyy');
      return formatter.format(dateTime);
    }
  }

  /// 날짜와 시간을 포맷팅 (예: "2024년 2월 12일 오후 3:24")
  static String formatDateTime(DateTime dateTime, {String locale = 'ko'}) {
    if (locale == 'ko') {
      final formatter = DateFormat('yyyy년 M월 d일 a h:mm', 'ko_KR');
      return formatter.format(dateTime);
    } else {
      final formatter = DateFormat('MMMM d, yyyy h:mm a');
      return formatter.format(dateTime);
    }
  }

  /// 초를 시간:분:초 형식으로 변환 (예: "01:23:45")
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${secs.toString().padLeft(2, '0')}';
    }
  }

  /// 분을 시간:분 형식으로 변환 (예: "2시간 30분")
  static String formatDurationMinutes(int minutes, {String locale = 'ko'}) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (locale == 'ko') {
      if (hours > 0 && mins > 0) {
        return '$hours시간 $mins분';
      } else if (hours > 0) {
        return '$hours시간';
      } else {
        return '$mins분';
      }
    } else {
      if (hours > 0 && mins > 0) {
        return '$hours hr $mins min';
      } else if (hours > 0) {
        return '$hours hr';
      } else {
        return '$mins min';
      }
    }
  }

  /// 시작 시간과 종료 시간으로부터 경과 시간 계산 (분)
  static int calculateDurationMinutes(DateTime start, DateTime end) {
    return end.difference(start).inMinutes;
  }

  /// 오늘인지 확인
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// 어제인지 확인
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  /// 이번 주인지 확인
  static bool isThisWeek(DateTime dateTime) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    return dateTime.isAfter(weekStart) && dateTime.isBefore(weekEnd);
  }
}
