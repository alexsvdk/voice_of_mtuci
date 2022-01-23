import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  Completer<bool>? _completer;
  bool? _res;

  Future<bool> validatePermission() async {
    if (_completer != null) return _completer!.future;
    if (_res != null) return _res!;

    _completer = Completer();
    final permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();

    final permissionsGranted =
        permissions.values.every((element) => element.isGranted);

    _completer!.complete(permissionsGranted);
    _completer = null;
    _res = permissionsGranted;

    if (!permissionsGranted &&
        permissions.values.any(
            (element) => element.isDenied || element.isPermanentlyDenied)) {
      openAppSettings();
    }

    return permissionsGranted;
  }
}
