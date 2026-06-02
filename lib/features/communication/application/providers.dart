import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vocabulary_repository.dart';
import '../domain/vocabulary.dart';
import 'analytics_service.dart';
import 'flutter_tts_service.dart';
import 'tts_service.dart';

final vocabularyRepositoryProvider =
    Provider<VocabularyRepository>((ref) => const VocabularyRepository());

final ttsServiceProvider = Provider<TtsService>((ref) => FlutterTtsService());

final analyticsServiceProvider =
    Provider<AnalyticsService>((ref) => const DebugAnalyticsService());

/// Loads the bundled vocabulary once.
final vocabularyProvider = FutureProvider<Vocabulary>((ref) async {
  final repo = ref.watch(vocabularyRepositoryProvider);
  return repo.loadCore();
});

/// term -> asset filename, loaded from the generated manifest.
final symbolManifestProvider = FutureProvider<Map<String, String>>((ref) async {
  final raw = await rootBundle.loadString('assets/symbols/manifest.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return json.map((k, v) => MapEntry(k, v as String));
});
