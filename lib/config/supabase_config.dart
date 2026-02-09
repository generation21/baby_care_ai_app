import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase 설정 및 초기화를 관리하는 클래스
class SupabaseConfig {
  /// Supabase URL
  /// 
  /// .env 파일의 SUPABASE_URL 값을 사용합니다.
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null || url.isEmpty || url == 'your_supabase_url_here') {
      throw Exception(
        'SUPABASE_URL이 설정되지 않았습니다. .env 파일을 확인해주세요.',
      );
    }
    return url;
  }

  /// Supabase Anon Key
  /// 
  /// .env 파일의 SUPABASE_ANON_KEY 값을 사용합니다.
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    if (key == null || key.isEmpty || key == 'your_supabase_anon_key_here') {
      throw Exception(
        'SUPABASE_ANON_KEY가 설정되지 않았습니다. .env 파일을 확인해주세요.',
      );
    }
    return key;
  }

  /// Supabase 초기화
  /// 
  /// 앱 시작 시 한 번만 호출해야 합니다.
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  /// Supabase 클라이언트 인스턴스
  static SupabaseClient get client => Supabase.instance.client;

  /// 현재 사용자 세션 확인
  static Session? get currentSession => client.auth.currentSession;

  /// 현재 사용자 정보
  static User? get currentUser => client.auth.currentUser;
}
