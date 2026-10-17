import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qr_barcode_app/domain/entities/barcode_models.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';

enum HistoryKind { generated, scanned }

class HistoryEntry extends Equatable {
  const HistoryEntry({
    required this.id,
    required this.kind,
    required this.title,
    required this.payload,
    required this.timestamp,
    this.formatName,
    this.qrType,
    this.barcodeSymbology,
    this.generatedKind,
  });

  final String id;
  final HistoryKind kind;
  final String title;
  final String payload;
  final DateTime timestamp;
  final String? formatName;
  final QrContentType? qrType;
  final BarcodeSymbology? barcodeSymbology;
  final GeneratedKind? generatedKind;

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'title': title,
        'payload': payload,
        'timestamp': timestamp.toIso8601String(),
        'formatName': formatName,
        'qrType': qrType?.name,
        'barcodeSymbology': barcodeSymbology?.name,
        'generatedKind': generatedKind?.name,
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] as String,
      kind: HistoryKind.values.byName(json['kind'] as String),
      title: json['title'] as String,
      payload: json['payload'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      formatName: json['formatName'] as String?,
      qrType: json['qrType'] == null
          ? null
          : QrContentType.values.byName(json['qrType'] as String),
      barcodeSymbology: json['barcodeSymbology'] == null
          ? null
          : BarcodeSymbology.values
              .byName(json['barcodeSymbology'] as String),
      generatedKind: json['generatedKind'] == null
          ? null
          : GeneratedKind.values.byName(json['generatedKind'] as String),
    );
  }

  @override
  List<Object?> get props => [id, kind, title, payload, timestamp];
}

class HistoryRepository {
  HistoryRepository(this._prefs);

  static const _key = 'vectorqr_history_v1';
  static const maxEntries = 100;

  final SharedPreferences _prefs;

  List<HistoryEntry> load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> addGenerated(GeneratedCode code) async {
    final entry = HistoryEntry(
      id: '${code.createdAt.millisecondsSinceEpoch}_${code.payloadString.hashCode}',
      kind: HistoryKind.generated,
      title: code.displayTitle,
      payload: code.payloadString,
      timestamp: code.createdAt,
      qrType: code.qrType,
      barcodeSymbology: code.barcodeSymbology,
      generatedKind: code.kind,
    );
    await _prepend(entry);
  }

  Future<void> addScan(ScanResultData data) async {
    final entry = HistoryEntry(
      id: '${data.timestamp.millisecondsSinceEpoch}_${data.rawValue.hashCode}',
      kind: HistoryKind.scanned,
      title: data.formatName,
      payload: data.rawValue,
      timestamp: data.timestamp,
      formatName: data.formatName,
    );
    await _prepend(entry);
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }

  Future<void> replaceAll(List<HistoryEntry> entries) async {
    await _prefs.setString(
      _key,
      jsonEncode(entries.take(maxEntries).map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _prepend(HistoryEntry entry) async {
    final current = load()
        .where((e) => e.payload != entry.payload || e.kind != entry.kind)
        .toList();
    final next = [entry, ...current].take(maxEntries).toList();
    await _prefs.setString(
      _key,
      jsonEncode(next.map((e) => e.toJson()).toList()),
    );
  }
}
