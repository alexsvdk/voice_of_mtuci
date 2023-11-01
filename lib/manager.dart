import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:record/record.dart';
import 'package:voice_of_mtuci/api.dart';

import 'permission_manager.dart';

const _tickerDelay = Duration(milliseconds: 500);
final _triggerOffsetDuration = const Duration(seconds: 5) + _tickerDelay;
const _silenceRestartDuratuionr = Duration(minutes: 5);

const _ampThreshehold = -20;

enum RecordStatus {
  permissionRequired,
  inactive,
  active,
}

class RecordManager {
  final StateController<RecordStatus> _statusController;
  final PermissionManager _permissionManager;
  final MyApi _api;

  final _audioRecorder = AudioRecorder();

  RecordManager(
    this._statusController,
    this._permissionManager,
    this._api,
  );

  late final Directory _recDir;

  DateTime? startTime;
  Timer? _ampTimer;
  DateTime? _triggered;
  DateTime? _leastTriggered;
  int recId = 0;
  File? _recFile;
  Completer<void>? _trimmerCompleter;

  void init() async {
    _recDir = await getTemporaryDirectory();
    bool appFolderExists = await _recDir.exists();
    if (!appFolderExists) {
      await _recDir.create(recursive: true);
    }
    _permissionManager.validatePermission();
  }

  Future<void> start() async {
    if (!await _permissionManager.validatePermission()) {
      _statusController.state = RecordStatus.permissionRequired;
      return;
    }

    await _restartRec();
    _ampTimer = Timer.periodic(_tickerDelay, (_) => _onTick());
    _statusController.state = RecordStatus.active;
  }

  Future<void> _onTick() async {
    try {
      if (startTime == null) {
        return;
      }

      final amp = await _audioRecorder.getAmplitude();
      final now = DateTime.now();
      if (amp.current > _ampThreshehold) {
        _triggered ??= now.difference(startTime!) > _triggerOffsetDuration
            ? now.subtract(_triggerOffsetDuration)
            : startTime;
        _leastTriggered = now;

        return;
      }

      if (_triggered != null) {
        if (now.difference(_leastTriggered!) > _triggerOffsetDuration) {
          _audioRecorder.stop();
          final recFile = _recFile;
          final startSec =
              _triggered!.difference(startTime!).inMilliseconds / 1000;
          final endSec = now.difference(startTime!).inMilliseconds / 1000;
          await _restartRec();
          _postRec(recFile!, startSec, endSec);
        }

        return;
      }

      if (now.difference(startTime!) > _silenceRestartDuratuionr) {
        _audioRecorder.stop();
        _recFile?.delete();
        _restartRec();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _restartRec() async {
    recId++;
    final filepath = '${_recDir.path}/$recId.rn';
    _recFile = File(filepath);
    startTime = DateTime.now();
    _leastTriggered = null;
    _triggered = null;
    await _audioRecorder.start(
      const RecordConfig(),
      path: filepath,
    );
  }

  Future<void> _postRec(File recFile, double startSec, double endSec) async {
    await _trimmerCompleter?.future;
    _trimmerCompleter = Completer();
    try {
      _api.sendFile(recFile, 'test');
    } catch (e) {
      print(e);
    }
    if (kDebugMode) {
      // FlutterShare.shareFile(
      //   title: 'Example share',
      //   text: 'Example share text',
      //   filePath: recFile.absolute.path,
      // );
    }
    _trimmerCompleter?.complete();
    _trimmerCompleter = null;
  }

  Future<void> getPermission() async {
    if (await _permissionManager.validatePermission()) {
      _statusController.state = RecordStatus.inactive;
    }
  }

  Future<void> stop() async {
    String? path = await _audioRecorder.stop();
    _statusController.state = RecordStatus.inactive;
    _ampTimer?.cancel();
    _ampTimer = null;
  }

  void dispose() {}
}
