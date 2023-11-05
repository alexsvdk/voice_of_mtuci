import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_of_mtuci/api.dart';
import 'package:voice_of_mtuci/manager.dart';
import 'package:voice_of_mtuci/permission_manager.dart';
import 'package:voice_of_mtuci/src/features/uploader/models/record_model.dart';

class ServiceModule {
  static late final Isar isar;

  static Future<void> configure() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [RecordModelSchema],
      directory: dir.path,
    );
  }
}

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
