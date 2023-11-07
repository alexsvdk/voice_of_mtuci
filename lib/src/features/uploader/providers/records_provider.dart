import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:voice_of_mtuci/src/features/uploader/models/record_model.dart';

class RecordsProvider {
  StreamController<List<RecordModel>>? _streamController;
  List<RecordModel> _records = [];

  List<RecordModel> get records => _records;

  Stream<List<RecordModel>> get recordsStream =>
      _streamController?.stream.startWith(records) ?? Stream.value([]);

  void loaded(List<RecordModel> records) {
    _records = records;
    _streamController?.add(records);
  }

  void init() {
    _streamController = StreamController<List<RecordModel>>.broadcast();
  }

  void dispose() {
    _streamController?.close();
  }
}
