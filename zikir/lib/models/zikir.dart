class Zikir {
  final int? id;
  final String name;
  final int target;
  final int? dailyTarget;
  final String? note;
  final DateTime createdAt;
  final bool isActive;

  const Zikir({
    this.id,
    required this.name,
    required this.target,
    this.dailyTarget,
    this.note,
    required this.createdAt,
    this.isActive = true,
  });

  Zikir copyWith({
    int? id,
    String? name,
    int? target,
    int? dailyTarget,
    String? note,
    DateTime? createdAt,
    bool? isActive,
    bool clearDailyTarget = false,
  }) {
    return Zikir(
      id: id ?? this.id,
      name: name ?? this.name,
      target: target ?? this.target,
      dailyTarget: clearDailyTarget ? null : (dailyTarget ?? this.dailyTarget),
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'target': target,
        'daily_target': dailyTarget,
        'note': note,
        'created_at': createdAt.toIso8601String(),
        'is_active': isActive ? 1 : 0,
      };

  factory Zikir.fromMap(Map<String, Object?> map) => Zikir(
        id: map['id'] as int?,
        name: map['name'] as String,
        target: map['target'] as int,
        dailyTarget: map['daily_target'] as int?,
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        isActive: (map['is_active'] as int? ?? 1) == 1,
      );
}
