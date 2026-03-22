import 'package:dio/dio.dart';
import '../clients/api_client.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../utils/api_exception.dart';

/// 멀티턴 채팅 API 서비스
///
/// 채팅 세션 생성/조회/삭제 및 메시지 전송 기능을 제공합니다.
class ChatApiService {
  final ApiClient _apiClient;
  static const String _basePath = '/api/v1/baby-care-ai/babies';

  ChatApiService(this._apiClient);

  /// 새 채팅 세션 열기
  /// POST /babies/{baby_id}/chat-sessions
  Future<ChatSession> createSession(
    int babyId, {
    String? title,
    int contextDays = 7,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '$_basePath/$babyId/chat-sessions',
        data: {
          if (title != null) 'title': title,
          'context_days': contextDays,
        },
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/chat-sessions');
      return ChatSession.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 채팅 세션 목록 조회 (최근 대화순)
  /// GET /babies/{baby_id}/chat-sessions
  Future<List<ChatSession>> getSessions(
    int babyId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.get(
        '$_basePath/$babyId/chat-sessions',
        queryParameters: {'limit': limit, 'offset': offset},
        cacheTtl: const Duration(minutes: 2),
      );
      return (response.data as List)
          .map((json) => ChatSession.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 채팅 세션 상세 조회 (메시지 포함)
  /// GET /babies/{baby_id}/chat-sessions/{session_id}
  Future<ChatSessionDetail> getSessionDetail(
    int babyId,
    int sessionId,
  ) async {
    try {
      final response = await _apiClient.get(
        '$_basePath/$babyId/chat-sessions/$sessionId',
        cacheTtl: const Duration(minutes: 1),
      );
      return ChatSessionDetail.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 메시지 전송 + AI 응답 받기
  /// POST /babies/{baby_id}/chat-sessions/{session_id}/messages
  Future<SendMessageResponse> sendMessage(
    int babyId,
    int sessionId, {
    required String message,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '$_basePath/$babyId/chat-sessions/$sessionId/messages',
        data: {'message': message},
      );
      _apiClient.invalidateCacheByPrefix(
        '$_basePath/$babyId/chat-sessions/$sessionId',
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/chat-sessions');
      return SendMessageResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 메시지 목록 조회 (시간순)
  /// GET /babies/{baby_id}/chat-sessions/{session_id}/messages
  Future<List<ChatMessage>> getMessages(
    int babyId,
    int sessionId, {
    int limit = 200,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.get(
        '$_basePath/$babyId/chat-sessions/$sessionId/messages',
        queryParameters: {'limit': limit, 'offset': offset},
        cacheTtl: const Duration(minutes: 1),
      );
      return (response.data as List)
          .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// 채팅 세션 삭제
  /// DELETE /babies/{baby_id}/chat-sessions/{session_id}
  Future<void> deleteSession(int babyId, int sessionId) async {
    try {
      await _apiClient.dio.delete(
        '$_basePath/$babyId/chat-sessions/$sessionId',
      );
      _apiClient.invalidateCacheByPrefix('$_basePath/$babyId/chat-sessions');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
