import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/api.dart';
import 'package:voice_of_mtuci/manager.dart';
import 'package:voice_of_mtuci/permission_manager.dart';

import 'manager.dart';

final recSatusProvider =
    StateProvider<RecordStatus>((_) => RecordStatus.inactive);

final permissionManagerProvider = Provider((_) => PermissionManager());

final apiProvider = Provider((_) => MyApi());

final recManagerProvider = Provider(
  (ref) {
    final res = RecordManager(
      ref.watch(recSatusProvider.notifier),
      ref.watch(permissionManagerProvider),
      ref.watch(apiProvider),
    );
    ref.onDispose(res.dispose);
    res.init();
    return res;
  },
);
