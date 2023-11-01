class RecordEntity {
  final DateTime startAt;
  final DateTime? endAt;
  final String fileName;

  RecordEntity({
    required this.startAt,
    required this.fileName,
    this.endAt,
  });

  RecordEntity copyWith({
    DateTime? startAt,
    DateTime? endAt,
    String? fileName,
  }) {
    return RecordEntity(
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      fileName: fileName ?? this.fileName,
    );
  }
}
