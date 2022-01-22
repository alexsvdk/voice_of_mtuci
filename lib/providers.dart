import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/manager.dart';

import 'manager.dart';

final recSatusProvider =
    StateProvider<RecordStatus>((_) => RecordStatus.inactive);

final recManagerProvider = Provider(
  (ref) {
    final res = RecordManager(
      ref.watch(recSatusProvider.notifier),
    );
    ref.onDispose(res.dispose);
    res.init();
    return res;
  },
);
