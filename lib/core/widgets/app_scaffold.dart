import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_barcode_app/core/theme/app_theme.dart';

/// Shared scaffold with an optional bottom ad slot.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomAd,
    this.bottomNavigationBar,
    this.leading,
    this.resizeToAvoidBottomInset,
    this.extendBodyBehindAppBar = false,
    this.transparentAppBar = false,
  });

  final Widget body;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomAd;
  final Widget? bottomNavigationBar;
  final Widget? leading;
  final bool? resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool transparentAppBar;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ad = bottomAd ?? const SizedBox.shrink();
    final showAppBar = title != null || actions != null || leading != null;

    final styledActions = actions
        ?.map((action) {
          if (action is IconButton) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Material(
                color: scheme.onSurface.withValues(alpha: 0.06),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: action,
              ),
            );
          }
          return action;
        })
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor:
          transparentAppBar ? Colors.transparent : scheme.surface,
      appBar: showAppBar
          ? AppBar(
              title: title == null
                  ? null
                  : DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: scheme.onSurface,
                      ),
                      child: title!,
                    ),
              actions: styledActions,
              leading: leading,
              backgroundColor:
                  transparentAppBar ? Colors.transparent : scheme.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: transparentAppBar ? 0 : 0.5,
              forceMaterialTransparency: transparentAppBar,
              systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ?bottomNavigationBar,
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: ad,
            ),
          ),
        ],
      ),
    );
  }
}
