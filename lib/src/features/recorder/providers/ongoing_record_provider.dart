import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../entities/record_entity.dart';

class OngoingRecordProvider {
  StreamController<RecordEntity?>? _streamController;
  RecordEntity? _recordEntity;

  RecordEntity? get ongoingRecord => _recordEntity;

  Stream<RecordEntity?> get ongoingRecordStream =>
      _streamController?.stream.startWith(ongoingRecord) ??
      Stream.value(ongoingRecord);

  void recordStarted(RecordEntity recordEntity) {
    assert(_recordEntity == null);

    _recordEntity = recordEntity;

    _streamController?.add(recordEntity);
  }

  void recordEnd() {
    assert(_recordEntity != null);

    _recordEntity = null;

    _streamController?.add(null);
  }

  init() {
    _streamController = StreamController<RecordEntity?>();
  }

  dispose() {
    _streamController?.close();
  }
}
