import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/src/features/uploader/managers/uploader_manager.dart';
import 'package:voice_of_mtuci/src/features/uploader/providers/records_provider.dart';

import '../../../providers.dart';

final uploaderManagerProvider = Provider(
  (ref) => UploaderManager(
    ServiceModule.isar,
    ref.read(recordsProviderProvider),
  )..loadRecords(),
);

final recordsProviderProvider = Provider(
  (ref) {
    final provider = RecordsProvider();

    provider.init();

    ref.onDispose(provider.dispose);

    return provider;
  },
);
