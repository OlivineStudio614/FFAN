// Usage: dart run tool/fetch_symbols.dart
// Resolves every `symbol` term in the core vocabulary to an ARASAAC
// pictogram, downloads a 300px PNG into assets/symbols/, and writes
// assets/symbols/manifest.json mapping term -> filename.
import 'dart:convert';
import 'dart:io';

const _vocabPath = 'assets/vocabulary/core_en.json';
const _outDir = 'assets/symbols';
const _searchBase = 'https://api.arasaac.org/api/pictograms/en/search';
const _staticBase = 'https://static.arasaac.org/pictograms';

Future<void> main() async {
  final terms = _collectTerms(File(_vocabPath));
  Directory(_outDir).createSync(recursive: true);
  final client = HttpClient();
  final manifest = <String, String>{};

  for (final term in terms) {
    try {
      final id = await _resolveId(client, term);
      if (id == null) {
        stderr.writeln('NO MATCH: "$term"');
        continue;
      }
      final fileName = '${_slug(term)}.png';
      await _download(client, '$_staticBase/$id/${id}_300.png',
          File('$_outDir/$fileName'));
      manifest[term] = fileName;
      stdout.writeln('OK  $term -> $fileName (id $id)');
    } catch (e) {
      stderr.writeln('ERROR "$term": $e');
    }
  }

  File('$_outDir/manifest.json')
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(manifest));
  client.close();
  stdout.writeln('Wrote ${manifest.length}/${terms.length} symbols.');
}

Set<String> _collectTerms(File vocab) {
  final json = jsonDecode(vocab.readAsStringSync()) as Map<String, dynamic>;
  final folders = json['folders'] as Map<String, dynamic>;
  final terms = <String>{};
  for (final cells in folders.values) {
    for (final c in cells as List) {
      final m = c as Map<String, dynamic>;
      if (m['symbol'] != null) terms.add(m['symbol'] as String);
    }
  }
  return terms;
}

Future<int?> _resolveId(HttpClient client, String term) async {
  final uri = Uri.parse('$_searchBase/${Uri.encodeComponent(term)}');
  final req = await client.getUrl(uri);
  final res = await req.close();
  if (res.statusCode != 200) return null;
  final body = await res.transform(utf8.decoder).join();
  final results = jsonDecode(body);
  if (results is List && results.isNotEmpty) {
    return (results.first as Map<String, dynamic>)['_id'] as int;
  }
  return null;
}

Future<void> _download(HttpClient client, String url, File out) async {
  final req = await client.getUrl(Uri.parse(url));
  final res = await req.close();
  if (res.statusCode != 200) {
    throw HttpException('status ${res.statusCode} for $url');
  }
  await res.pipe(out.openWrite());
}

String _slug(String term) =>
    term.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
