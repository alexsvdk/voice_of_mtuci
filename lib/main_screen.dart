import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/manager.dart';
import 'package:voice_of_mtuci/providers.dart';
import 'package:voice_of_mtuci/theme.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(recSatusProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'МТУСИ.Прослушка',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(child: status.mapToWidget()),
              const Text('by @a1exs'),
            ],
          ),
        ),
      ),
    );
  }
}

extension on RecordStatus {
  Widget mapToWidget() {
    switch (this) {
      case RecordStatus.permissionRequired:
        return const _Permission();
      case RecordStatus.inactive:
        return const _Inactive();
      case RecordStatus.active:
        return const _Active();
    }
  }
}

class _Inactive extends ConsumerWidget {
  const _Inactive({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: kButtonStyle,
          child: const Text('Начать прослушку'),
          onPressed: () {
            ref.read(recManagerProvider).start();
          },
        ),
      ],
    );
  }
}

class _Active extends ConsumerWidget {
  const _Active({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class _Permission extends ConsumerWidget {
  const _Permission({Key? key}) : super(key: key);
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
            ref.read(recManagerProvider).getPermission();
          },
        ),
      ],
    );
  }
}
