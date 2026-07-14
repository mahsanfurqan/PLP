import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static bool get isShowing => _currentEntry != null;

  static void show(
    String title,
    String message, {
    SnackPosition snackPosition = SnackPosition.TOP,
    Color? backgroundColor,
    Color? colorText,
    EdgeInsets? margin,
    double borderRadius = 14,
    Duration? duration,
  }) {
    final context =
        scaffoldMessengerKey.currentContext ??
        Get.overlayContext ??
        Get.context;

    if (context == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        show(
          title,
          message,
          snackPosition: snackPosition,
          backgroundColor: backgroundColor,
          colorText: colorText,
          margin: margin,
          borderRadius: borderRadius,
          duration: duration,
        );
      });
      return;
    }

    _hideCurrent();

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      _showWithScaffoldMessenger(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: colorText,
        margin: margin,
        borderRadius: borderRadius,
        duration: duration,
      );
      return;
    }

    final mediaQuery = MediaQuery.maybeOf(context);
    final padding = mediaQuery?.padding ?? EdgeInsets.zero;
    final effectiveMargin =
        margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    final effectiveDuration = duration ?? const Duration(seconds: 3);
    final effectiveBackground = backgroundColor ?? _colorForTitle(title);
    final effectiveTextColor = colorText ?? Colors.white;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        final position =
            snackPosition == SnackPosition.BOTTOM
                ? <String, double>{
                  'left': effectiveMargin.left,
                  'right': effectiveMargin.right,
                  'bottom': padding.bottom + effectiveMargin.bottom,
                }
                : <String, double>{
                  'left': effectiveMargin.left,
                  'right': effectiveMargin.right,
                  'top': padding.top + effectiveMargin.top,
                };

        return Positioned(
          left: position['left'],
          right: position['right'],
          top: position['top'],
          bottom: position['bottom'],
          child: Material(
            color: Colors.transparent,
            child: _SnackbarCard(
              title: title,
              message: message,
              backgroundColor: effectiveBackground,
              textColor: effectiveTextColor,
              borderRadius: borderRadius,
              onClose: _hideCurrent,
            ),
          ),
        );
      },
    );

    _currentEntry = entry;
    overlay.insert(entry);
    _dismissTimer = Timer(effectiveDuration, _hideCurrent);
  }

  static void _showWithScaffoldMessenger(
    String title,
    String message, {
    Color? backgroundColor,
    Color? colorText,
    EdgeInsets? margin,
    double borderRadius = 14,
    Duration? duration,
  }) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: margin ?? const EdgeInsets.all(16),
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: backgroundColor ?? _colorForTitle(title),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        content: _SnackbarContent(
          title: title,
          message: message,
          textColor: colorText ?? Colors.white,
        ),
      ),
    );
  }

  static void _hideCurrent() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }

  static Color _colorForTitle(String title) {
    final normalized = title.toLowerCase();

    if (normalized.contains('sukses') ||
        normalized.contains('berhasil') ||
        normalized.contains('success')) {
      return const Color(0xFF16A34A);
    }

    if (normalized.contains('gagal') ||
        normalized.contains('error') ||
        normalized.contains('ditolak')) {
      return const Color(0xFFEF4444);
    }

    if (normalized.contains('info') ||
        normalized.contains('validasi') ||
        normalized.contains('perhatian')) {
      return const Color(0xFFF59E0B);
    }

    return const Color(0xFF334155);
  }
}

class _SnackbarCard extends StatelessWidget {
  final String title;
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final VoidCallback onClose;

  const _SnackbarCard({
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Expanded(
              child: _SnackbarContent(
                title: title,
                message: message,
                textColor: textColor,
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close_rounded, color: textColor, size: 18),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}

class _SnackbarContent extends StatelessWidget {
  final String title;
  final String message;
  final Color textColor;

  const _SnackbarContent({
    required this.title,
    required this.message,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          message,
          style: TextStyle(
            color: textColor.withValues(alpha: 0.92),
            fontSize: 13,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
