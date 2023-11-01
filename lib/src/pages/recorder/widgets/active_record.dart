import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/src/features/recorder/di.dart';
import 'package:voice_of_mtuci/src/features/recorder/entities/record_entity.dart';
import 'package:voice_of_mtuci/src/features/recorder/entities/recorder_states.dart';
import 'package:voice_of_mtuci/src/pages/recorder/widgets/record_time.dart';

import '../../../../theme.dart';

class ActiveRecord extends ConsumerWidget {
  const ActiveRecord({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(recorderManagerProvider);
    final ongoingProvider = ref.watch(ongoingRecordProviderProvider);

    final recordState = ref.watch(recorderState);
    final ongoingRecord = ongoingProvider.ongoingRecord;

    if (ongoingRecord == null) return const SizedBox();

    return Column(
      children: [
        const Text(
          'Идет прослушка :)',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        RecordTime(recordEntity: ongoingRecord),
        TextButton(
          style: kButtonStyle,
          child: const Text(
            'Стоп',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            manager.stop();
          },
        ),
        if (recordState != RecorderState.paused) ...[
          TextButton(
            style: kButtonStyle,
            child: const Text(
              'Пауза',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              manager.pause();
            },
          ),
        ] else if (ongoingRecord.pauseReason == PauseReason.user) ...[
          TextButton(
            style: kButtonStyle,
            child: const Text(
              'Продолжить',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              manager.resume();
            },
          ),
        ] else if (ongoingRecord.pauseReason == PauseReason.user) ...[
          const Text('Вы ничего не говорите, запись приостановлена'),
          const Text('Начните говорить, чтобы продолжить запись'),
        ]
      ],
    );
  }
}
