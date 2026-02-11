import 'package:json_annotation/json_annotation.dart';

part 'baby.g.dart';

/// 아이 프로필 모델
@JsonSerializable()
class Baby {
  final int id;
  final String name;
  @JsonKey(name: 'birth_date')
  final String birthDate;
  final String? gender;
  final String? photo;
  @JsonKey(name: 'blood_type')
  final String? bloodType;
  final Map<String, dynamic>? notes;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Baby({
    required this.id,
    required this.name,
    required this.birthDate,
    this.gender,
    this.photo,
    this.bloodType,
    this.notes,
    required this.isActive,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Baby.fromJson(Map<String, dynamic> json) => _$BabyFromJson(json);
  Map<String, dynamic> toJson() => _$BabyToJson(this);

  /// 나이 계산 (일 수)
  int get ageInDays {
    final birthDateTime = DateTime.parse(birthDate);
    return DateTime.now().difference(birthDateTime).inDays;
  }

  /// 나이 계산 (개월 수)
  int get ageInMonths => (ageInDays / 30).floor();

  /// 나이 표시 문자열
  String get ageString {
    final days = ageInDays;
    if (days < 30) {
      return '$days일';
    } else if (days < 365) {
      final months = (days / 30).floor();
      return '$months개월';
    } else {
      final years = (days / 365).floor();
      final remainingMonths = ((days % 365) / 30).floor();
      if (remainingMonths == 0) {
        return '$years세';
      }
      return '$years세 $remainingMonths개월';
    }
  }

  /// copyWith 메서드
  Baby copyWith({
    int? id,
    String? name,
    String? birthDate,
    String? gender,
    String? photo,
    String? bloodType,
    Map<String, dynamic>? notes,
    bool? isActive,
    String? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Baby(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
      bloodType: bloodType ?? this.bloodType,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
