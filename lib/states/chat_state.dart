import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/chat_api_service.dart';
import '../utils/api_exception.dart';

/// 멀티턴 채팅 상태 관리
///
/// 채팅 세션 목록, 현재 세션의 메시지, 로딩/전송 상태를 관리합니다.
class ChatState extends ChangeNotifier {
  final ChatApiService _apiService;

  List<ChatSession> _sessions = [];
  List<ChatMessage> _messages = [];
  ChatSession? _currentSession;
  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;

  int _sessionOffset = 0;
  bool _hasMoreSessions = true;
  static const int _sessionPageSize = 50;

  ChatState(this._apiService);

  List<ChatSession> get sessions => _sessions;
  List<ChatMessage> get messages => _messages;
  ChatSession? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;
  bool get hasMoreSessions => _hasMoreSessions;
  bool get hasSessions => _sessions.isNotEmpty;
  bool get hasMessages => _messages.isNotEmpty;

  /// 새 채팅 세션 생성
  Future<ChatSession> createSession(
    int babyId, {
    String? title,
    int contextDays = 7,
  }) async {
    _clearError();
    try {
      final session = await _apiService.createSession(
        babyId,
        title: title,
        contextDays: contextDays,
      );
      _sessions.insert(0, session);
      _currentSession = session;
      _messages = [];
      notifyListeners();
      return session;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('새 대화를 시작하는 중 오류가 발생했습니다.');
      notifyListeners();
      rethrow;
    }
  }

  /// 세션 목록 조회 (초기 로드)
  Future<void> loadSessions(int babyId) async {
    _isLoading = true;
    _clearError();
    _sessionOffset = 0;
    _hasMoreSessions = true;
    notifyListeners();

    try {
      final newSessions = await _apiService.getSessions(
        babyId,
        limit: _sessionPageSize,
        offset: 0,
      );
      _sessions = newSessions;
      _sessionOffset = newSessions.length;
      _hasMoreSessions = newSessions.length == _sessionPageSize;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
    } catch (e) {
      _setError('대화 목록을 불러오는 중 오류가 발생했습니다.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 세션 목록 더 불러오기 (페이지네이션)
  Future<void> loadMoreSessions(int babyId) async {
    if (_isLoading || !_hasMoreSessions) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newSessions = await _apiService.getSessions(
        babyId,
        limit: _sessionPageSize,
        offset: _sessionOffset,
      );
      _sessions.addAll(newSessions);
      _sessionOffset += newSessions.length;
      _hasMoreSessions = newSessions.length == _sessionPageSize;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
    } catch (e) {
      _setError('대화 목록을 더 불러오는 중 오류가 발생했습니다.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 세션 상세 (메시지 포함) 로드
  Future<void> loadSessionDetail(int babyId, int sessionId) async {
    _isLoading = true;
    _clearError();
    notifyListeners();

    try {
      final detail = await _apiService.getSessionDetail(babyId, sessionId);
      _currentSession = ChatSession(
        id: detail.id,
        babyId: detail.babyId,
        userId: detail.userId,
        title: detail.title,
        createdAt: detail.createdAt,
        updatedAt: detail.updatedAt,
      );
      _messages = List.from(detail.messages);
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
    } catch (e) {
      _setError('대화 내용을 불러오는 중 오류가 발생했습니다.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 메시지 전송 + AI 응답 받기
  Future<void> sendMessage(
    int babyId,
    int sessionId, {
    required String message,
  }) async {
    _isSending = true;
    _clearError();
    notifyListeners();

    try {
      final response = await _apiService.sendMessage(
        babyId,
        sessionId,
        message: message,
      );
      _messages.add(response.userMessage);
      _messages.add(response.assistantMessage);

      _updateSessionInList(sessionId);
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
    } catch (e) {
      _setError('메시지를 전송하는 중 오류가 발생했습니다.');
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  /// 세션 삭제
  Future<void> deleteSession(int babyId, int sessionId) async {
    try {
      await _apiService.deleteSession(babyId, sessionId);
      _sessions.removeWhere((s) => s.id == sessionId);
      if (_currentSession?.id == sessionId) {
        _currentSession = null;
        _messages = [];
      }
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      notifyListeners();
      rethrow;
    }
  }

  void setCurrentSession(ChatSession? session) {
    _currentSession = session;
    if (session == null) _messages = [];
    notifyListeners();
  }

  void clearCurrentSession() {
    _currentSession = null;
    _messages = [];
    notifyListeners();
  }

  void reset() {
    _sessions = [];
    _messages = [];
    _currentSession = null;
    _isLoading = false;
    _isSending = false;
    _errorMessage = null;
    _sessionOffset = 0;
    _hasMoreSessions = true;
    notifyListeners();
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setError(String message) => _errorMessage = message;
  void _clearError() => _errorMessage = null;

  void _updateSessionInList(int sessionId) {
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    if (index > 0) {
      final session = _sessions.removeAt(index);
      _sessions.insert(0, session);
    }
  }
}
