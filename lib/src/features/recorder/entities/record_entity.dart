class RecordEntity {
  final PauseReason? pauseReason;
  final DateTime startAt;
  final DateTime resumeAt;

  /// продолжительность записи до последней остановки
  final Duration durationBeforeLastResume;
  final DateTime? endAt;
  final String fileName;

  RecordEntity({
    required this.startAt,
    required this.fileName,
    required this.resumeAt,
    required this.durationBeforeLastResume,
    this.pauseReason,
    this.endAt,
  });

  bool get isPaused => pauseReason != null;

  Duration get totalDuration =>
      durationBeforeLastResume +
      (isPaused ? Duration.zero : DateTime.now().difference(resumeAt));

  RecordEntity resumeCopyWith() => RecordEntity(
        startAt: startAt,
        fileName: fileName,
        resumeAt: resumeAt,
        durationBeforeLastResume: durationBeforeLastResume,
        pauseReason: null,
        endAt: endAt,
      );

  RecordEntity copyWith({
    PauseReason? pauseReason,
    DateTime? startAt,
    DateTime? resumeAt,
    Duration? durationBeforeLastResume,
    DateTime? endAt,
    String? fileName,
  }) {
    return RecordEntity(
      pauseReason: pauseReason ?? this.pauseReason,
      startAt: startAt ?? this.startAt,
      resumeAt: resumeAt ?? this.resumeAt,
      durationBeforeLastResume:
          durationBeforeLastResume ?? this.durationBeforeLastResume,
      endAt: endAt ?? this.endAt,
      fileName: fileName ?? this.fileName,
    );
  }
}

enum PauseReason {
  user,
  silence,
}
