import 'package:isar/isar.dart';

part 'record_model.g.dart';

@collection
class RecordModel {
  Id id = Isar.autoIncrement;

  DateTime recordedAt = DateTime.now();

  String filePath = '';

  int durationMills = 0;
}