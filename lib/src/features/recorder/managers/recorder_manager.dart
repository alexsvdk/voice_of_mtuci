import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:voice_of_mtuci/src/features/recorder/entities/record_entity.dart';

import '../../permissions/managers/permissions_manager.dart';
import '../entities/recorder_states.dart';
import '../providers/ongoing_record_provider.dart';

class RecorderManager {
  final PermissionsManager _permissionsManager;
  final OngoingRecordProvider _ongoingRecordProvider;
  final StateController<RecorderState> _recorderStateController;
  final AudioRecorder _audioRecorder;

  RecorderManager(
    this._permissionsManager,
    this._ongoingRecordProvider,
    this._audioRecorder,
    this._recorderStateController,
  );

  Future<void> start() async {
    _recorderStateController.state = RecorderState.loading;
    final permissionsGranted = await _permissionsManager.validatePermissions();
    if (!permissionsGranted) {
      _recorderStateController.state = RecorderState.permissionRequired;
      return;
    }

    final savePath = await getTemporaryDirectory();

    bool appFolderExists = await savePath.exists();
    if (!appFolderExists) {
      await savePath.create(recursive: true);
    }

    final startAt = DateTime.now();
    final filePath = "${savePath.path}/${startAt.toIso8601String()}.rn";

    _ongoingRecordProvider.recordStarted(
      RecordEntity(
        startAt: startAt,
        resumeAt: startAt,
        fileName: filePath,
        durationBeforeLastResume: Duration.zero,
      ),
    );

    await _audioRecorder.start(
      const RecordConfig(),
      path: filePath,
    );

    _recorderStateController.state = RecorderState.active;
  }

  Future<void> pause() async {
    _recorderStateController.state = RecorderState.loading;
    await _audioRecorder.pause();

    final ongoingRecord = _ongoingRecordProvider.ongoingRecord;

    if (ongoingRecord == null) {
      _recorderStateController.state = RecorderState.paused;
      return;
    }

    _ongoingRecordProvider.recordPaused(ongoingRecord.copyWith(
      pauseReason: PauseReason.user,
      durationBeforeLastResume: ongoingRecord.totalDuration,
    ));

    _recorderStateController.state = RecorderState.paused;
  }

  Future<void> resume() async {
    _recorderStateController.state = RecorderState.loading;
    await _audioRecorder.resume();

    final ongoingRecord = _ongoingRecordProvider.ongoingRecord;

    if (ongoingRecord == null) {
      _recorderStateController.state = RecorderState.active;
      return;
    }

    _ongoingRecordProvider.recordResumed(
      ongoingRecord.resumeCopyWith().copyWith(resumeAt: DateTime.now()),
    );

    _recorderStateController.state = RecorderState.active;
  }

  Future<void> stop() async {
    _recorderStateController.state = RecorderState.loading;
    if (!await _audioRecorder.isRecording()) {
      _recorderStateController.state = RecorderState.inactive;
    }

    final savePath = await _audioRecorder.stop();

    if (savePath == null) {
      _ongoingRecordProvider.recordEnd();
      return;
    }

    _ongoingRecordProvider.recordEnd();

    _recorderStateController.state = RecorderState.inactive;
  }
}
