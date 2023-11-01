import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/src/features/recorder/di.dart';
import 'package:voice_of_mtuci/src/features/recorder/entities/recorder_states.dart';
import 'package:voice_of_mtuci/src/pages/recorder/widgets/inactive_record.dart';
import 'package:voice_of_mtuci/src/pages/recorder/widgets/need_permissions.dart';

import 'widgets/active_record.dart';

class RecorderScreen extends ConsumerWidget {
  const RecorderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordEntity = ref.watch(recorderState);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'МТУСИ.Прослушка',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Center(
                child: Builder(
                  builder: (context) {
                    switch (recordEntity) {
                      case RecorderState.permissionRequired:
                        return const NeedPermissions();
                      case RecorderState.inactive:
                        return const InactiveRecord();
                      case RecorderState.active:
                        return const ActiveRecord();
                      case RecorderState.loading:
                        return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              const Text('by @a1exs & @webmadness'),
            ],
          ),
        ),
      ),
    );
  }
}
