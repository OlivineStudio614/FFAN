import 'package:ffan/app.dart';
import 'package:ffan/features/communication/application/providers.dart';
import 'package:ffan/features/communication/application/tts_service.dart';
import 'package:ffan/features/communication/domain/cell.dart';
import 'package:ffan/features/communication/domain/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTts implements TtsService {
  final List<String> spoken = [];
  @override
  Future<void> setLanguage(String tag) async {}
  @override
  Future<void> speak(String text) async => spoken.add(text);
  @override
  Future<void> stop() async {}
}

/// A minimal in-memory vocabulary with the words used in the test.
Vocabulary _miniVocab() => const Vocabulary(
      id: 'test',
      name: 'Test',
      language: 'en-US',
      rows: 1,
      cols: 2,
      folders: {
        'root': [
          Cell.word(
              row: 0,
              col: 0,
              label: 'I',
              message: 'I',
              symbol: 'I',
              colorHex: 0xFFFFF176),
          Cell.word(
              row: 0,
              col: 1,
              label: 'want',
              message: 'want',
              symbol: 'want',
              colorHex: 0xFF81C784),
        ],
      },
    );

void main() {
  testWidgets('tap words then speak builds the utterance', (tester) async {
    final tts = _FakeTts();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        // Bypass asset loading entirely with an in-memory vocabulary.
        vocabularyProvider.overrideWith((_) async => _miniVocab()),
        // Suppress manifest asset load — page handles missing manifest gracefully.
        symbolManifestProvider.overrideWith((_) async => const <String, String>{}),
        ttsServiceProvider.overrideWithValue(tts),
      ],
      child: const FfanApp(),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('I').first);
    await tester.pump();
    await tester.tap(find.text('want').first);
    await tester.pump();

    await tester.tap(find.byKey(const Key('speak')));
    await tester.pump();

    expect(tts.spoken, ['I want']);
  });
}
