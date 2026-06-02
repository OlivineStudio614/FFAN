import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../domain/vocabulary.dart';
import 'vocabulary_loader.dart';

/// Loads the bundled vocabulary from assets. The asset path is injectable so
/// tests can point at fixtures and later phases can load other languages.
class VocabularyRepository {
  const VocabularyRepository({this.assetPath = 'assets/vocabulary/core_en.json'});

  final String assetPath;

  Future<Vocabulary> loadCore() async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return VocabularyLoader.fromJson(json);
  }
}
