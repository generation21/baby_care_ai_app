import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase 설정
///
/// .env의 SUPABASE_URL, SUPABASE_ANON_KEY를 사용합니다.
class SupabaseConfig {
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    final url = SupabaseConfig.url;
    final anonKey = SupabaseConfig.anonKey;

    if (url.isEmpty || anonKey.isEmpty) {
      throw Exception(
        'SUPABASE_URL과 SUPABASE_ANON_KEY를 .env에 설정해주세요.',
      );
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}
