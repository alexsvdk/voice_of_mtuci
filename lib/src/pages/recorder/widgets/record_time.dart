import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/src/features/recorder/entities/record_entity.dart';

class RecordTime extends ConsumerStatefulWidget {
  final RecordEntity recordEntity;

  const RecordTime({
    super.key,
    required this.recordEntity,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecordTimeState();
}

class _RecordTimeState extends ConsumerState<RecordTime> {
  late final Timer timer;



  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diff = widget.recordEntity.totalDuration;
    final inMinutes = diff.inMinutes;
    final inSeconds = diff.inSeconds - inMinutes * 60;
    return Text(
      "${inMinutes.toString().padLeft(2, "0")}:${inSeconds.toString().padLeft(2, "0")}",
    );
  }
}
