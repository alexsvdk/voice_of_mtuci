import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

enum RecordStatus {
  permissionRequired,
  inactive,
  active,
}

class RecordManager {
  final StateController<RecordStatus> _statusController;

  RecordManager(
    this._statusController,
  );

  void init() {
    getPermission();
  }

  Future<void> start() async {
    if (!await getPermission()) {
      return;
    }
  }

  void stop() {}

  Future<bool> getPermission() async {
    final permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();

    final permissionsGranted =
        permissions.values.every((element) => element.isGranted);

    if (permissionsGranted) {
      _statusController.state = RecordStatus.inactive;
    } else {
      _statusController.state = RecordStatus.permissionRequired;
    }

    if (!permissionsGranted &&
        permissions.values.any(
            (element) => element.isDenied || element.isPermanentlyDenied)) {
      openAppSettings();
    }

    return permissionsGranted;
  }

  void dispose() {}
}
