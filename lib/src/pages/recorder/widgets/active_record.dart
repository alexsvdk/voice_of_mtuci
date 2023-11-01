import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/src/features/recorder/di.dart';
import 'package:voice_of_mtuci/src/pages/recorder/widgets/record_time.dart';

import '../../../../theme.dart';

class ActiveRecord extends ConsumerWidget {
  const ActiveRecord({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(recorderManagerProvider);
    final ongoingProvider = ref.watch(ongoingRecordProviderProvider);

    final startAt = ongoingProvider.ongoingRecord?.startAt;

    if (startAt == null) return const SizedBox();

    return Column(
      children: [
        const Text(
          'Идет прослушка :)',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        RecordTime(startAt: startAt),
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
      ],
    );
  }
}
