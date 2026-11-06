class ZikirLog {
  final int? id;
  final int zikirId;
  final int count;
  final DateTime performedAt;
  final String? note;

  const ZikirLog({
    this.id,
    required this.zikirId,
    required this.count,
    required this.performedAt,
    this.note,
  });

  ZikirLog copyWith({
    int? id,
    int? zikirId,
    int? count,
    DateTime? performedAt,
    String? note,
  }) =>
      ZikirLog(
        id: id ?? this.id,
        zikirId: zikirId ?? this.zikirId,
        count: count ?? this.count,
        performedAt: performedAt ?? this.performedAt,
        note: note ?? this.note,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'zikir_id': zikirId,
        'count': count,
        'performed_at': performedAt.toIso8601String(),
        'note': note,
      };

  factory ZikirLog.fromMap(Map<String, Object?> map) => ZikirLog(
        id: map['id'] as int?,
        zikirId: map['zikir_id'] as int,
        count: map['count'] as int,
        performedAt: DateTime.parse(map['performed_at'] as String),
        note: map['note'] as String?,
      );
}
