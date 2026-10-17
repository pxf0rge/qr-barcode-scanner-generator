import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/data/history/history_repository.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';
import 'package:qr_barcode_app/features/settings/presentation/theme_preference.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(ref.watch(sharedPreferencesProvider));
});

final historyEntriesProvider =
    NotifierProvider<HistoryEntriesNotifier, List<HistoryEntry>>(
  HistoryEntriesNotifier.new,
);

class HistoryEntriesNotifier extends Notifier<List<HistoryEntry>> {
  @override
  List<HistoryEntry> build() {
    return ref.watch(historyRepositoryProvider).load();
  }

  void refresh() {
    state = ref.read(historyRepositoryProvider).load();
  }

  Future<void> clear() async {
    await ref.read(historyRepositoryProvider).clear();
    state = const [];
  }

  Future<void> removeSelected(Set<String> ids) async {
    final remaining =
        state.where((e) => !ids.contains(e.id)).toList(growable: false);
    await ref.read(historyRepositoryProvider).replaceAll(remaining);
    state = remaining;
  }
}

enum _HistoryFilter { all, scanned, created }

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  _HistoryFilter _filter = _HistoryFilter.all;
  bool _selecting = false;
  final Set<String> _selected = {};
  String _query = '';
  bool _searching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(historyEntriesProvider);
    final filtered = entries.where((e) {
      final matchFilter = switch (_filter) {
        _HistoryFilter.all => true,
        _HistoryFilter.scanned => e.kind == HistoryKind.scanned,
        _HistoryFilter.created => e.kind == HistoryKind.generated,
      };
      if (!matchFilter) return false;
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          e.payload.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.actionSearch,
                  isDense: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              )
            : Text(l10n.historyTitle),
        actions: [
          IconButton(
            tooltip: l10n.actionSearch,
            onPressed: () {
              setState(() {
                _searching = !_searching;
                if (!_searching) {
                  _query = '';
                  _searchController.clear();
                }
              });
            },
            icon: Icon(_searching ? Icons.close : Icons.search),
          ),
          IconButton(
            tooltip: l10n.actionClearHistory,
            onPressed: () {
              setState(() {
                _selecting = !_selecting;
                _selected.clear();
              });
            },
            icon: Icon(
              _selecting ? Icons.close_fullscreen_outlined : Icons.checklist_rtl,
              color: _selecting ? AppColors.primary : null,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.historyFilterAll),
                  selected: _filter == _HistoryFilter.all,
                  onSelected: (_) =>
                      setState(() => _filter = _HistoryFilter.all),
                ),
                ChoiceChip(
                  label: Text(l10n.historyScanned),
                  selected: _filter == _HistoryFilter.scanned,
                  onSelected: (_) =>
                      setState(() => _filter = _HistoryFilter.scanned),
                ),
                ChoiceChip(
                  label: Text(l10n.historyGenerated),
                  selected: _filter == _HistoryFilter.created,
                  onSelected: (_) =>
                      setState(() => _filter = _HistoryFilter.created),
                ),
              ],
            ),
          ),
          if (_selecting && _selected.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    await ref
                        .read(historyEntriesProvider.notifier)
                        .removeSelected(_selected);
                    setState(() {
                      _selected.clear();
                      _selecting = false;
                    });
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.actionClearHistory),
                ),
              ),
            ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: AppColors.primary.withValues(alpha: 0.45),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.historyEmptyShort,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.historyEmpty,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.muted,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
                      final id = entry.id;
                      final isScan = entry.kind == HistoryKind.scanned;
                      return Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          leading: _selecting
                              ? Checkbox(
                                  value: _selected.contains(id),
                                  activeColor: AppColors.primary,
                                  onChanged: (v) {
                                    setState(() {
                                      if (v == true) {
                                        _selected.add(id);
                                      } else {
                                        _selected.remove(id);
                                      }
                                    });
                                  },
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColors.primary
                                      .withValues(alpha: 0.12),
                                  child: Icon(
                                    isScan
                                        ? Icons.qr_code_scanner_rounded
                                        : Icons.qr_code_2_rounded,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                          title: Text(
                            entry.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            entry.payload,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            if (_selecting) {
                              setState(() {
                                if (_selected.contains(id)) {
                                  _selected.remove(id);
                                } else {
                                  _selected.add(id);
                                }
                              });
                              return;
                            }
                            if (isScan) {
                              context.push(
                                AppRoutes.result,
                                extra: ScanResultData(
                                  rawValue: entry.payload,
                                  formatName:
                                      entry.formatName ?? entry.title,
                                  timestamp: entry.timestamp,
                                ),
                              );
                            } else {
                              final kind =
                                  entry.generatedKind ?? GeneratedKind.qr;
                              if (kind == GeneratedKind.barcode &&
                                  entry.barcodeSymbology != null) {
                                context.push(
                                  AppRoutes.preview,
                                  extra: GeneratedCode.barcode(
                                    symbology: entry.barcodeSymbology!,
                                    payload: entry.payload,
                                    title: entry.title,
                                  ),
                                );
                              } else {
                                context.push(
                                  AppRoutes.preview,
                                  extra: GeneratedCode.qr(
                                    type:
                                        entry.qrType ?? QrContentType.text,
                                    payload: entry.payload,
                                    title: entry.title,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
