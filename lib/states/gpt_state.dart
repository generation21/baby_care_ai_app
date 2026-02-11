import 'package:flutter/foundation.dart';
import '../models/gpt_conversation.dart';
import '../services/gpt_api_service.dart';
import '../utils/api_exception.dart';

/// GPT 상태 관리
/// 
/// GPT 대화 상태 및 로딩 상태를 관리합니다.
class GPTState extends ChangeNotifier {
  final GPTApiService _apiService;

  List<GPTConversation> _conversations = [];
  GPTConversation? _currentConversation;
  bool _isLoading = false;
  bool _isAsking = false;
  String? _errorMessage;

  // 페이지네이션
  int _offset = 0;
  bool _hasMore = true;
  static const int _pageSize = 50;

  GPTState(this._apiService);

  // Getters
  List<GPTConversation> get conversations => _conversations;
  GPTConversation? get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;
  bool get isAsking => _isAsking;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get hasConversations => _conversations.isNotEmpty;

  /// GPT에게 질문하기
  Future<GPTConversation> askQuestion(
    int babyId, {
    required String question,
    int contextDays = 7,
  }) async {
    _isAsking = true;
    _clearError();
    notifyListeners();

    try {
      final conversation = await _apiService.askQuestion(
        babyId,
        question: question,
        contextDays: contextDays,
      );

      _currentConversation = conversation;
      _conversations.insert(0, conversation);

      _isAsking = false;
      notifyListeners();
      return conversation;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _isAsking = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('GPT에게 질문하는 중 오류가 발생했습니다.');
      _isAsking = false;
      notifyListeners();
      rethrow;
    }
  }

  /// 대화 기록 목록 조회 (초기 로드)
  Future<void> loadConversations(int babyId) async {
    _setLoading(true);
    _clearError();
    _offset = 0;
    _hasMore = true;

    try {
      final newConversations = await _apiService.getConversations(
        babyId,
        limit: _pageSize,
        offset: _offset,
      );

      _conversations = newConversations;
      _offset = newConversations.length;
      _hasMore = newConversations.length == _pageSize;

      _setLoading(false);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _setLoading(false);
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('대화 기록을 불러오는 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// 대화 기록 더 불러오기 (페이지네이션)
  Future<void> loadMore(int babyId) async {
    if (_isLoading || !_hasMore) return;

    _setLoading(true);
    notifyListeners();

    try {
      final newConversations = await _apiService.getConversations(
        babyId,
        limit: _pageSize,
        offset: _offset,
      );

      _conversations.addAll(newConversations);
      _offset += newConversations.length;
      _hasMore = newConversations.length == _pageSize;

      _setLoading(false);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('대화 기록을 더 불러오는 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
    }
  }

  /// 대화 상세 조회
  Future<GPTConversation> getConversation(
    int babyId,
    int conversationId,
  ) async {
    try {
      final conversation = await _apiService.getConversation(
        babyId,
        conversationId,
      );

      _currentConversation = conversation;

      // 목록에서 해당 대화 업데이트
      final index = _conversations.indexWhere((c) => c.id == conversationId);
      if (index != -1) {
        _conversations[index] = conversation;
      }

      notifyListeners();
      return conversation;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      notifyListeners();
      rethrow;
    }
  }

  /// 대화 기록 삭제
  Future<void> deleteConversation(int babyId, int conversationId) async {
    try {
      await _apiService.deleteConversation(babyId, conversationId);

      _conversations.removeWhere((c) => c.id == conversationId);
      
      if (_currentConversation?.id == conversationId) {
        _currentConversation = null;
      }

      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      notifyListeners();
      rethrow;
    }
  }

  /// 현재 대화 설정
  void setCurrentConversation(GPTConversation? conversation) {
    _currentConversation = conversation;
    notifyListeners();
  }

  /// 현재 대화 클리어
  void clearCurrentConversation() {
    _currentConversation = null;
    notifyListeners();
  }

  /// 상태 초기화
  void reset() {
    _conversations = [];
    _currentConversation = null;
    _isLoading = false;
    _isAsking = false;
    _errorMessage = null;
    _offset = 0;
    _hasMore = true;
    notifyListeners();
  }

  void _setLoading(bool value) => _isLoading = value;
  void _setError(String message) => _errorMessage = message;
  void _clearError() => _errorMessage = null;

  /// 에러 메시지 클리어
  void clearError() {
    _clearError();
    notifyListeners();
  }
}
