/// 아이 프로필 모델
class Baby {
  final int? id;
  final String name;
  final DateTime birthDate;
  final String? gender;
  final String? photo;
  final String? bloodType;
  final double? birthHeight;
  final double? birthWeight;
  final String? notes;
  final bool isActive;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Baby({
    this.id,
    required this.name,
    required this.birthDate,
    this.gender,
    this.photo,
    this.bloodType,
    this.birthHeight,
    this.birthWeight,
    this.notes,
    this.isActive = true,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  /// JSON에서 Baby 객체 생성
  factory Baby.fromJson(Map<String, dynamic> json) {
    return Baby(
      id: json['id'] as int?,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String?,
      photo: json['photo'] as String?,
      bloodType: json['blood_type'] as String?,
      birthHeight: json['birth_height'] != null
          ? (json['birth_height'] as num).toDouble()
          : null,
      birthWeight: json['birth_weight'] != null
          ? (json['birth_weight'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      userId: json['user_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Baby 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'birth_date': birthDate.toIso8601String().split('T')[0],
      if (gender != null) 'gender': gender,
      if (photo != null) 'photo': photo,
      if (bloodType != null) 'blood_type': bloodType,
      if (birthHeight != null) 'birth_height': birthHeight,
      if (birthWeight != null) 'birth_weight': birthWeight,
      if (notes != null) 'notes': notes,
      'is_active': isActive,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// 나이 계산 (개월 수)
  int get ageInMonths {
    final now = DateTime.now();
    final months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    return months;
  }

  /// 나이 표시 문자열
  String get ageString {
    final months = ageInMonths;
    if (months < 12) {
      return '$months개월';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years세';
      }
      return '$years세 $remainingMonths개월';
    }
  }

  /// 키 가져오기 (출생 신장)
  double? get height => birthHeight;

  /// 몸무게 가져오기 (출생 체중)
  double? get weight => birthWeight;

  /// copyWith 메서드
  Baby copyWith({
    int? id,
    String? name,
    DateTime? birthDate,
    String? gender,
    String? photo,
    String? bloodType,
    double? birthHeight,
    double? birthWeight,
    String? notes,
    bool? isActive,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Baby(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
      bloodType: bloodType ?? this.bloodType,
      birthHeight: birthHeight ?? this.birthHeight,
      birthWeight: birthWeight ?? this.birthWeight,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
