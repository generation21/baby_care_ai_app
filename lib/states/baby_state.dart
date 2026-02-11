import 'package:flutter/foundation.dart';
import '../models/baby.dart';
import '../services/baby_api_service.dart';
import '../utils/api_exception.dart';

/// Baby 상태 관리
/// 
/// Baby 목록 및 선택된 Baby 상태를 관리합니다.
class BabyState extends ChangeNotifier {
  final BabyApiService _apiService;

  List<Baby> _babies = [];
  Baby? _selectedBaby;
  bool _isLoading = false;
  String? _errorMessage;

  BabyState(this._apiService);

  // Getters
  List<Baby> get babies => _babies;
  Baby? get selectedBaby => _selectedBaby;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasBabies => _babies.isNotEmpty;

  /// Baby 목록 조회
  Future<void> loadBabies({
    int limit = 50,
    int offset = 0,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _babies = await _apiService.getBabies(
        limit: limit,
        offset: offset,
      );

      // 선택된 Baby가 없으면 첫 번째 Baby 자동 선택
      if (_selectedBaby == null && _babies.isNotEmpty) {
        _selectedBaby = _babies.first;
      }

      _setLoading(false);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _setLoading(false);
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('Baby 목록을 불러오는 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// Baby 상세 조회
  Future<Baby> getBaby(int babyId) async {
    try {
      final baby = await _apiService.getBaby(babyId);
      
      // 목록에서 해당 Baby 업데이트
      final index = _babies.indexWhere((b) => b.id == babyId);
      if (index != -1) {
        _babies[index] = baby;
        if (_selectedBaby?.id == babyId) {
          _selectedBaby = baby;
        }
        notifyListeners();
      }

      return baby;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      notifyListeners();
      rethrow;
    }
  }

  /// Baby 생성
  Future<Baby> createBaby({
    required String name,
    required String birthDate,
    String? gender,
    String? photo,
    String? bloodType,
    Map<String, dynamic>? notes,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final baby = await _apiService.createBaby(
        name: name,
        birthDate: birthDate,
        gender: gender,
        photo: photo,
        bloodType: bloodType,
        notes: notes,
      );

      _babies.insert(0, baby);
      
      // 첫 Baby이면 자동 선택
      if (_babies.length == 1) {
        _selectedBaby = baby;
      }

      _setLoading(false);
      notifyListeners();
      return baby;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _setLoading(false);
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('Baby를 생성하는 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// Baby 정보 수정
  Future<Baby> updateBaby(
    int babyId, {
    String? name,
    String? birthDate,
    String? gender,
    String? photo,
    String? bloodType,
    Map<String, dynamic>? notes,
    bool? isActive,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final baby = await _apiService.updateBaby(
        babyId,
        name: name,
        birthDate: birthDate,
        gender: gender,
        photo: photo,
        bloodType: bloodType,
        notes: notes,
        isActive: isActive,
      );

      // 목록에서 해당 Baby 업데이트
      final index = _babies.indexWhere((b) => b.id == babyId);
      if (index != -1) {
        _babies[index] = baby;
        if (_selectedBaby?.id == babyId) {
          _selectedBaby = baby;
        }
      }

      _setLoading(false);
      notifyListeners();
      return baby;
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _setLoading(false);
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('Baby 정보를 수정하는 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// Baby 삭제 (비활성화)
  Future<void> deleteBaby(int babyId) async {
    _setLoading(true);
    _clearError();

    try {
      await _apiService.deleteBaby(babyId);

      // 목록에서 제거
      _babies.removeWhere((b) => b.id == babyId);

      // 선택된 Baby가 삭제된 경우 다른 Baby 선택
      if (_selectedBaby?.id == babyId) {
        _selectedBaby = _babies.isNotEmpty ? _babies.first : null;
      }

      _setLoading(false);
      notifyListeners();
    } on ApiException catch (e) {
      _setError(ErrorHandler.getErrorMessage(e));
      _setLoading(false);
      notifyListeners();
      rethrow;
    } catch (e) {
      _setError('Baby를 삭제하는 중 오류가 발생했습니다.');
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  /// Baby 선택
  void selectBaby(Baby baby) {
    if (_selectedBaby?.id != baby.id) {
      _selectedBaby = baby;
      notifyListeners();
    }
  }

  /// Baby 선택 (ID로)
  void selectBabyById(int babyId) {
    final baby = _babies.firstWhere(
      (b) => b.id == babyId,
      orElse: () => _babies.first,
    );
    selectBaby(baby);
  }

  /// 상태 초기화
  void reset() {
    _babies = [];
    _selectedBaby = null;
    _isLoading = false;
    _errorMessage = null;
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
