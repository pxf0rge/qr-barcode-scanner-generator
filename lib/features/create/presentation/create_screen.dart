import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_barcode_app/core/router/routes.dart';
import 'package:qr_barcode_app/core/theme/app_theme.dart';
import 'package:qr_barcode_app/core/widgets/brand_marks.dart';
import 'package:qr_barcode_app/domain/entities/generated_code.dart';
import 'package:qr_barcode_app/domain/entities/qr_models.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

enum _CreateCategory { all, qr, barcode, social }

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  _CreateCategory _category = _CreateCategory.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final qrItems = <_CreateItem>[
      _CreateItem(
        label: l10n.createTypeLink,
        icon: Icons.link_rounded,
        category: _CreateCategory.qr,
        onTap: () => context.push(AppRoutes.qrUrl),
      ),
      _CreateItem(
        label: l10n.createTypeText,
        icon: Icons.notes_rounded,
        category: _CreateCategory.qr,
        onTap: () => context.push(AppRoutes.qrText),
      ),
      _CreateItem(
        label: l10n.createTypeWifi,
        icon: Icons.wifi_rounded,
        category: _CreateCategory.qr,
        onTap: () => context.push(AppRoutes.qrWifi),
      ),
      _CreateItem(
        label: l10n.createTypeContact,
        icon: Icons.person_outline_rounded,
        category: _CreateCategory.qr,
        onTap: () => context.push(AppRoutes.qrContact),
      ),
      _CreateItem(
        label: l10n.createTypeTelephone,
        icon: Icons.phone_outlined,
        category: _CreateCategory.qr,
        onTap: () => context.push(AppRoutes.qrPhone),
      ),
      _CreateItem(
        label: l10n.createTypeEmail,
        icon: Icons.mail_outline_rounded,
        category: _CreateCategory.qr,
        onTap: () => context.push(AppRoutes.qrEmail),
      ),
      _CreateItem(
        label: l10n.createTypeCalendar,
        icon: Icons.event_outlined,
        category: _CreateCategory.qr,
        onTap: () => context.push(AppRoutes.qrCalendar),
      ),
      _CreateItem(
        label: l10n.createTypeMyCard,
        icon: Icons.badge_outlined,
        category: _CreateCategory.qr,
        onTap: () => context.push(AppRoutes.qrMyCard),
      ),
    ];

    final barcodeItems = <_CreateItem>[
      _CreateItem(
        label: l10n.createTypeBarcode,
        icon: Icons.view_week_rounded,
        category: _CreateCategory.barcode,
        accent: AppColors.warm,
        onTap: () => context.push(AppRoutes.barcode),
      ),
    ];

    final socialItems = <_CreateItem>[
      _CreateItem(
        label: l10n.qrTypeWhatsapp,
        brand: BrandKind.whatsapp,
        category: _CreateCategory.social,
        onTap: () => context.push(AppRoutes.qrWhatsapp),
      ),
      _CreateItem(
        label: l10n.qrTypeInstagram,
        brand: BrandKind.instagram,
        category: _CreateCategory.social,
        onTap: () => context.push(AppRoutes.qrInstagram),
      ),
      _CreateItem(
        label: l10n.createTypeFacebook,
        brand: BrandKind.facebook,
        category: _CreateCategory.social,
        onTap: () => context.push(AppRoutes.qrFacebook),
      ),
      _CreateItem(
        label: l10n.createTypeYoutube,
        brand: BrandKind.youtube,
        category: _CreateCategory.social,
        onTap: () => context.push(AppRoutes.qrYoutube),
      ),
    ];

    final filtered = switch (_category) {
      _CreateCategory.all => [...qrItems, ...barcodeItems, ...socialItems],
      _CreateCategory.qr => qrItems,
      _CreateCategory.barcode => barcodeItems,
      _CreateCategory.social => socialItems,
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.navCreate,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.appSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.muted,
                            height: 1.35,
                          ),
                    ),
                    const SizedBox(height: 18),
                    _ClipboardChip(
                      label: l10n.createClipboard,
                      onTap: () => _fromClipboard(context, l10n),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _CategoryChip(
                            label: l10n.historyFilterAll,
                            selected: _category == _CreateCategory.all,
                            onTap: () => setState(
                              () => _category = _CreateCategory.all,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _CategoryChip(
                            label: l10n.qrTypeTitle,
                            selected: _category == _CreateCategory.qr,
                            onTap: () => setState(
                              () => _category = _CreateCategory.qr,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _CategoryChip(
                            label: l10n.barcodeTypeTitle,
                            selected: _category == _CreateCategory.barcode,
                            onTap: () => setState(
                              () => _category = _CreateCategory.barcode,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _CategoryChip(
                            label: l10n.createSectionSocial,
                            selected: _category == _CreateCategory.social,
                            onTap: () => setState(
                              () => _category = _CreateCategory.social,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.92,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _TypeTile(item: filtered[index]),
                childCount: filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fromClipboard(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (text.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.createClipboardEmpty)),
        );
      }
      return;
    }
    if (!context.mounted) return;
    context.push(
      AppRoutes.preview,
      extra: GeneratedCode.qr(
        type: QrContentType.text,
        payload: text,
        title: l10n.createClipboard,
      ),
    );
  }
}

class _CreateItem {
  const _CreateItem({
    required this.label,
    required this.onTap,
    required this.category,
    this.icon,
    this.brand,
    this.accent,
  });

  final String label;
  final VoidCallback onTap;
  final _CreateCategory category;
  final IconData? icon;
  final BrandKind? brand;
  final Color? accent;
}

class _ClipboardChip extends StatelessWidget {
  const _ClipboardChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.content_paste_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: selected ? Colors.white : AppColors.primaryDark,
        fontSize: 13,
      ),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _TypeTile extends StatelessWidget {
  const _TypeTile({required this.item});

  final _CreateItem item;

  @override
  Widget build(BuildContext context) {
    final accent = item.accent ?? AppColors.primary;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: accent.withValues(alpha: 0.14),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: item.brand != null
                      ? BrandMark(kind: item.brand!, size: 20)
                      : Icon(item.icon, color: accent, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
