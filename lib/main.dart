import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/communication/application/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  container.read(analyticsServiceProvider).logSessionStart();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const FfanApp(),
    ),
  );
}
