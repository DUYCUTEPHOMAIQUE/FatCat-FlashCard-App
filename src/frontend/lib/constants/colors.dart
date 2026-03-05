import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Neutral ──────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF7F6FB);
  static const Color black = Color(0xFF000000);
  static const Color black87 = Color(0xDD000000);
  static const Color black54 = Color(0x8A000000);

  // Grey scale
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFBDBDBD);   // grey[400]
  static const Color greyMedium = Color(0xFF757575);  // grey[600]
  static const Color greyDark = Color(0xFF424242);    // grey[800]
  static const Color greyBackground = Color(0xFFF5F5F5);

  // ── Brand / Primary ──────────────────────────────────────────
  static const Color orange = Color(0xFFF2994A);       // custom warm orange
  static const Color materialOrange = Color(0xFFFF9800);// Colors.orange
  static const Color green = Color(0xFF4CAF50);        // Colors.green
  static const Color brown = Color(0xFF795548);        // Colors.brown
  static const Color purple = Color(0xFF9C27B0);       // Colors.purple
  static const Color red = Color(0xFFF44336);          // Colors.red
  static const Color blue = Color(0xFF2196F3);         // Colors.blue
  static const Color teal = Color(0xFF009688);

  // ── Bottom Navigation tab colors ─────────────────────────────
  static const Color tabHome = materialOrange;
  static const Color tabDecks = brown;
  static const Color tabLibrary = purple;
  static const Color tabClass = green;
  static const Color tabSettings = black;

  // ── Backgrounds ──────────────────────────────────────────────
  static const Color backgroundScreen = Color(0xFFF5F6F8);
  static const Color backgroundCard = Color(0xFFFEFEFE);
  static const Color backgroundButton = black;
  static const Color lightMintGreen = Color(0xFFF0F7F4);
  static const Color greenBg = Color(0xFF6FCF97);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2C2C37);    // blackText
  static const Color textSecondary = Color(0xFF5D5E5F);  // greyText
  static const Color textHint = grey;

  // ── Icons ────────────────────────────────────────────────────
  static const Color iconGrey = Color(0xFF7C7D91);

  // ── Misc ─────────────────────────────────────────────────────
  static const Color progressBar = Color(0xFF54555D);
  static const Color borderCard = Color(0xFF636363);
  static const Color transparent = Colors.transparent;

  // ── Deprecated aliases (giữ để không break code cũ) ─────────
  @Deprecated('Dùng AppColors.offWhite')
  static const Color appWhite = offWhite;
  @Deprecated('Dùng AppColors.textPrimary')
  static const Color blackText = textPrimary;
  @Deprecated('Dùng AppColors.textSecondary')
  static const Color greyText = textSecondary;
  @Deprecated('Dùng AppColors.iconGrey')
  static const Color greyIcon = iconGrey;
  @Deprecated('Dùng AppColors.backgroundButton')
  static const Color backgroundButtonColor = backgroundButton;
  @Deprecated('Dùng AppColors.progressBar')
  static const Color progressBarColor = progressBar;
}

// ── Adaptive color set (thay đổi theo light/dark mode) ─────────────────────
/// Tập màu adaptive, trả về giá trị khác nhau tùy theo light/dark.
/// Sử dụng: `context.appColors.background` thay vì `AppColors.backgroundScreen`
class _AdaptiveColors {
  final Brightness _brightness;
  const _AdaptiveColors(this._brightness);

  bool get isDark => _brightness == Brightness.dark;

  // Backgrounds
  Color get background => isDark ? const Color(0xFF121212) : AppColors.backgroundScreen;
  Color get surface    => isDark ? const Color(0xFF1C1C1E) : AppColors.backgroundCard;
  Color get surfaceVariant => isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF0F0F0);

  // Text
  Color get textPrimary   => isDark ? const Color(0xFFEAEAEA) : AppColors.textPrimary;
  Color get textSecondary => isDark ? const Color(0xFFAAAAAA) : AppColors.textSecondary;
  Color get textHint      => isDark ? const Color(0xFF757575) : AppColors.grey;

  // Elements
  Color get divider     => isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0);
  Color get border      => isDark ? const Color(0xFF555555) : AppColors.greyLight;
  Color get icon        => isDark ? const Color(0xFFBBBBBB) : AppColors.iconGrey;
  Color get cardShadow  => isDark ? Colors.black54 : Colors.black12;

  // Buttons
  Color get buttonPrimary     => isDark ? const Color(0xFFFF9800) : AppColors.backgroundButton;
  Color get buttonPrimaryText => AppColors.white;

  // Nav bar
  Color get navBarBackground => isDark ? const Color(0xFF1C1C1E) : AppColors.white;
}

extension AppColorsExtension on BuildContext {
  /// Truy cập màu adaptive theo light/dark mode hiện tại.
  ///
  /// Ví dụ:
  /// ```dart
  /// color: context.appColors.textPrimary
  /// backgroundColor: context.appColors.background
  /// ```
  _AdaptiveColors get appColors {
    final brightness = Theme.of(this).brightness;
    return _AdaptiveColors(brightness);
  }
}
