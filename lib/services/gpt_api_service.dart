import 'package:dio/dio.dart';
import '../clients/api_client.dart';
import '../models/gpt_conversation.dart';
import '../utils/api_exception.dart';

/// GPT API 서비스
/// 
/// GPT 질문 및 대화 기록 조회 기능을 제공합니다.
class GPTApiService {
  final ApiClient _apiClient;
  static const String _basePath = '/api/v1/baby-care-ai/babies';

  GPTApiService(this._apiClient);

  /// GPT에게 질문하기
  /// POST /api/v1/baby-care-ai/babies/{baby_id}/gpt-questions
  Future<GPTConversation> askQuestion(
    int babyId, {
    required String question,
    int contextDays = 7,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '$_basePath/$babyId/gpt-questions',
        data: {
          'question': question,
          'context_days': contextDays,
        },
      );

      return GPTConversation.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// GPT 대화 기록 목록 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}/gpt-conversations
  Future<List<GPTConversation>> getConversations(
    int babyId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '$_basePath/$babyId/gpt-conversations',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      return (response.data as List)
          .map((json) => GPTConversation.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// GPT 대화 기록 상세 조회
  /// GET /api/v1/baby-care-ai/babies/{baby_id}/gpt-conversations/{conversation_id}
  Future<GPTConversation> getConversation(
    int babyId,
    int conversationId,
  ) async {
    try {
      final response = await _apiClient.dio.get(
        '$_basePath/$babyId/gpt-conversations/$conversationId',
      );

      return GPTConversation.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// GPT 대화 기록 삭제
  /// DELETE /api/v1/baby-care-ai/babies/{baby_id}/gpt-conversations/{conversation_id}
  Future<void> deleteConversation(int babyId, int conversationId) async {
    try {
      await _apiClient.dio.delete(
        '$_basePath/$babyId/gpt-conversations/$conversationId',
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
