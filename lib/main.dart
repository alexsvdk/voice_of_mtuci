import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/providers.dart';

import 'src/pages/recorder/recorder_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceModule.configure();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => ProviderScope(
        child: child ?? const SizedBox.shrink(),
      ),
      home: const RecorderScreen(),
    );
  }
}
