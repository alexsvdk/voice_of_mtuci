import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/src/features/recorder/di.dart';

import '../../../../theme.dart';

class InactiveRecord extends ConsumerWidget {
  const InactiveRecord({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      style: kButtonStyle,
      child: const Text('Начать прослушку'),
      onPressed: () {
        ref.read(recorderManagerProvider).start();
      },
    );
  }
}
