import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecordTime extends ConsumerStatefulWidget {
  final DateTime startAt;

  const RecordTime({
    super.key,
    required this.startAt,
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
    final diff = DateTime.now().difference(widget.startAt);
    final inMinutes = diff.inMinutes;
    final inSeconds = diff.inSeconds - inMinutes * 60;
    return Text(
      "${inMinutes.toString().padLeft(2, "0")}:${inSeconds.toString().padLeft(2, "0")}",
    );
  }
}
