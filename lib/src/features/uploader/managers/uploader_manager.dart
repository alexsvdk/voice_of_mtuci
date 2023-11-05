import 'package:isar/isar.dart';
import 'package:voice_of_mtuci/src/features/recorder/entities/record_entity.dart';
import 'package:voice_of_mtuci/src/features/uploader/models/record_model.dart';
import 'package:voice_of_mtuci/src/features/uploader/providers/records_provider.dart';

class UploaderManager {
  final Isar isar;
  final RecordsProvider recordsProvider;

  UploaderManager(this.isar, this.recordsProvider);

  Future<void> saveRecord(RecordEntity recordEntity) async {
    await isar.writeTxn(() async {
      await isar.recordModels.put(
        RecordModel()
          ..filePath = recordEntity.fileName
          ..durationMills = recordEntity.totalDuration.inMilliseconds
          ..recordedAt = recordEntity.startAt,
      ); // insert & update
    });

    loadRecords();
  }

  Future<void> loadRecords() async {
    final recordModels = await isar.txn(() async {
      return await isar.recordModels
          .where()
          .sortByRecordedAtDesc()
          .findAll();
    });
    recordsProvider.loaded(recordModels);
  }
}
