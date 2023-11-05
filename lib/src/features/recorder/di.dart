import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:record/record.dart';
import 'package:voice_of_mtuci/src/features/recorder/entities/recorder_states.dart';
import 'package:voice_of_mtuci/src/features/recorder/managers/recorder_manager.dart';
import 'package:voice_of_mtuci/src/features/recorder/providers/ongoing_record_provider.dart';
import 'package:voice_of_mtuci/src/features/uploader/di.dart';

import '../permissions/di.dart';

final recorderState = StateProvider((ref) => RecorderState.inactive);

final ongoingRecordProviderProvider = Provider<OngoingRecordProvider>(
  (ref) {
    final instance = OngoingRecordProvider();
    ref.onDispose(instance.dispose);
    instance.init();
    return instance;
  },
);

final recorderManagerProvider = Provider(
  (ref) => RecorderManager(
    ref.read(permissionsManagerProvider),
    ref.read(ongoingRecordProviderProvider),
    AudioRecorder(),
    ref.read(recorderState.notifier),
    ref.read(uploaderManagerProvider),
  ),
);
