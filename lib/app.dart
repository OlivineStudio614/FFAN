import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/communication/presentation/communication_page.dart';

class FfanApp extends StatelessWidget {
  const FfanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFAN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const CommunicationPage(),
    );
  }
}
