// Run with: dart run tools/convert_cards.dart
import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

/// Input Excel
const String kXlsxPath = 'tools/card_game_data.xlsx';

/// Output roots
const String kCardsRoot = 'assets/trading_card_game/cards';
const String kImagesRoot = 'assets/trading_card_game/images';
const String kAggregatePath = 'assets/trading_card_game/cards.json';

/// Fallback placeholder used when an image is missing or not provided.
const String kPlaceholderPath = 'assets/images/placeholders/card_placeholder.png';

/// Columns expected in the Excel (case-insensitive match, spaces/slashes allowed)
const expectedHeaders = <String>[
  'Region',
  'Name',
  'Type',
  'Culture/Region',
  'Domain/Role',
  'Short Lore Blurb',
  'Overlaps/Links',
  'Tags',
  'Status',
  'Impact',
  'Confidence/Belief Level',
  'Cluster/Theme',
  'Media/Pop Links',
  'Year/Timeline',
  'Primary Source',
  'Refrence',
  'Image_Name',
];

Future<void> main(List<String> args) async {
  final stopwatch = Stopwatch()..start();

  // Ensure output roots exist (so we can always write the aggregate file)
  Directory(kCardsRoot).createSync(recursive: true);
  Directory(kImagesRoot).createSync(recursive: true);

  final aggregateFile = File(kAggregatePath);
  aggregateFile.parent.createSync(recursive: true);

  final excelFile = File(kXlsxPath);
  if (!excelFile.existsSync()) {
    // Excel is missing — still create an empty aggregate so Flutter stops complaining.
    _writeAggregate(const [], aggregateFile);
    stdout.writeln(
      'WARN: Excel not found at "$kXlsxPath". Wrote empty $kAggregatePath.',
    );
    return;
  }

  final bytes = excelFile.readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);

  final List<Map<String, dynamic>> aggregate = [];

  for (final table in excel.tables.keys) {
    final sheet = excel.tables[table]!;
    if (sheet.maxRows == 0) continue;

    final sheetName = table.trim();
    final safeSheet = _safeName(sheetName);

    // Create matching per-sheet folders for JSON and IMAGES
    final sheetCardsDir = Directory(p.join(kCardsRoot, safeSheet));
    final sheetImagesDir = Directory(p.join(kImagesRoot, safeSheet));
    sheetCardsDir.createSync(recursive: true);
    sheetImagesDir.createSync(recursive: true);

    // Build header map (name -> column index)
    final headerRow = sheet.rows.first;
    final headerIndex = <String, int>{};

    for (var c = 0; c < headerRow.length; c++) {
      final raw = headerRow[c]?.value?.toString().trim() ?? '';
      if (raw.isEmpty) continue;
      headerIndex[_normalizeHeader(raw)] = c;
    }

    // Validate we have at least Name
    if (!headerIndex.keys
        .map(_normalizeHeader)
        .contains(_normalizeHeader('Name'))) {
      stderr.writeln('WARN: Sheet "$sheetName" has no "Name" header. Skipping.');
      continue;
    }

    // Iterate data rows
    for (var r = 1; r < sheet.maxRows; r++) {
      final row = sheet.row(r);

      String cell(String header) {
        final idx = headerIndex[_normalizeHeader(header)];
        if (idx == null || idx >= row.length) return '';
        final v = row[idx]?.value;
        if (v == null) return '';
        return v.toString().trim();
      }

      final name = cell('Name');
      if (name.isEmpty) continue; // skip empty rows

      final imageName = cell('Image_Name');
      final id = _makeId(safeSheet, r, suggested: name);

      // Compute the intended image asset path under trading_card_game/images/<sheet>/<file>
      final String intendedImagePath = (imageName.isEmpty)
          ? ''
          : p.join(kImagesRoot, safeSheet, imageName).replaceAll('\\', '/');

      // If no image specified or file doesn't exist on disk, use placeholder
      final String finalImagePath = (intendedImagePath.isEmpty)
          ? kPlaceholderPath
          : (File(intendedImagePath).existsSync() ? intendedImagePath : kPlaceholderPath);

      // Single-row JSON object (keeps *all* your columns)
      final record = <String, dynamic>{
        'id': id,
        'sheet': sheetName,
        'region': cell('Region'),
        'name': name,
        'type': cell('Type'),
        'cultureRegion': cell('Culture/Region'),
        'domainRole': cell('Domain/Role'),
        'shortLoreBlurb': cell('Short Lore Blurb'),
        'overlapsLinks': cell('Overlaps/Links'),
        'tags': cell('Tags'),
        'status': cell('Status'),
        'impact': cell('Impact'),
        'confidenceBeliefLevel': cell('Confidence/Belief Level'),
        'clusterTheme': cell('Cluster/Theme'),
        'mediaPopLinks': cell('Media/Pop Links'),
        'yearTimeline': cell('Year/Timeline'),
        'primarySource': cell('Primary Source'),
        'reference': cell('Refrence'),
        'imageName': imageName,
        // Convenience fields for your game model (defaults; adjust later if needed)
        'attack': 0,
        'defense': 0,
        // IMPORTANT: points to the image under trading_card_game/images/<sheet>/<Image_Name>
        // or falls back to the global placeholder.
        'imageAssetPath': finalImagePath,
        // For the aggregated list expected by your app:
        'description': cell('Short Lore Blurb'),
        'ownedCount': 0,
      };

      // Write per-row JSON
      final jsonPath = p.join(sheetCardsDir.path, '$id.json');
      File(jsonPath).writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(record),
      );

      // Also append to aggregation (what your app usually loads)
      aggregate.add({
        'id': record['id'],
        'name': record['name'],
        'description': record['description'],
        'attack': record['attack'],
        'defense': record['defense'],
        'imageAssetPath': record['imageAssetPath'],
        'ownedCount': record['ownedCount'],
      });
    }
  }

  // Write aggregate file (even if aggregate is empty)
  _writeAggregate(aggregate, aggregateFile);

  stdout.writeln(
    'Done. Mirrored folders created:\n'
    '  JSON:   $kCardsRoot/<sheet>/*.json\n'
    '  IMAGES: $kImagesRoot/<sheet>/\n'
    'Aggregate: $kAggregatePath  (${aggregate.length} records)\n'
    'Placeholder used when image is missing: $kPlaceholderPath',
  );
}

/// Write the aggregate file with pretty JSON.
void _writeAggregate(List<Map<String, dynamic>> aggregate, File outFile) {
  outFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(aggregate),
  );
}

/// Normalize header names for matching (lowercase, remove non-alphanum)
String _normalizeHeader(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');

/// Turn names/sheet labels into safe filesystem names
String _safeName(String input) {
  var s = input.toLowerCase().trim();
  s = s.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  s = s.replaceAll(RegExp(r'_+'), '_');
  return s.replaceAll(RegExp(r'^_|_$'), '');
}

/// Make a deterministic id per row
String _makeId(String sheetSafe, int rowIndex, {required String suggested}) {
  final base = _safeName(suggested);
  if (base.isEmpty) {
    return '${sheetSafe}_${rowIndex.toString().padLeft(3, '0')}';
  }
  return '${sheetSafe}_$base';
}
