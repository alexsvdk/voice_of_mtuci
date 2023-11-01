import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/src/features/permissions/di.dart';

import '../../../../theme.dart';

class NeedPermissions extends ConsumerWidget {
  const NeedPermissions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Для работы приложения необходимы разрешения'),
        TextButton(
          style: kButtonStyle,
          child: const Text('Продоставить разрешения'),
          onPressed: () {
            ref.read(permissionsManagerProvider).validatePermissions();
          },
        ),
      ],
    );
  }
}
