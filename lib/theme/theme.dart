import 'package:flutter/material.dart';
import 'package:abaez/theme/colors.dart';
import 'package:abaez/theme/text_style.dart';

class AppTheme {
  static ThemeData bootcampTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surface,
    disabledColor: AppColors.neutralGray,     // Gris neutro corporativo
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDarkBlue,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.gray01,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16, 
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter', 
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Colors.transparent,
      backgroundColor: AppColors.gray01,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.bodyXs.copyWith(color: AppColors.primary);
          }
          return AppTextStyles.bodyXs.copyWith(color: AppColors.disabled);
        },
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: AppColors.disabled);
        },
      ),
    ),
    radioTheme:
    RadioThemeData(fillColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.gray07;
        }
        return AppColors.gray05;
      },
    ), overlayColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else if (states.contains(WidgetState.pressed)) {
          return AppColors.red07;
        } else if (states.contains(WidgetState.hovered)) {
          return AppColors.red03;
        } else if (states.contains(WidgetState.focused)) {
          return AppColors.primary;
        }
        return AppColors.gray05;
      },
    )),
    checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            } else if (states.contains(WidgetState.disabled)) {
              return AppColors.gray07;
            }
            return AppColors.gray01;
          },
        ),
        side: const BorderSide(color: AppColors.gray05)),
    cardTheme: CardTheme(
      color: AppColors.gray01,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: AppColors.gray05),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.gray01,
        disabledBackgroundColor: AppColors.disabled,
        disabledForegroundColor: AppColors.gray08,
        textStyle: AppTextStyles.bodyLgMedium.copyWith(color: AppColors.gray01),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      labelStyle: AppTextStyles.bodyLgSemiBold,
      unselectedLabelStyle: AppTextStyles.bodyLg,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.gray14,
      indicator: const BoxDecoration(
        color: AppColors.blue02,
        borderRadius: BorderRadius.all(Radius.circular(80)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle:
        AppTextStyles.bodyLgMedium.copyWith(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    textTheme: TextTheme(
      // Display styles
      displayLarge: AppTextStyles.heading3xl,
      displayMedium: AppTextStyles.heading2xl,
      displaySmall: AppTextStyles.headingXl,

      // Headline styles
      headlineLarge: AppTextStyles.headingLg,
      headlineMedium: AppTextStyles.headingMd,
      headlineSmall: AppTextStyles.headingSm,

      // Body styles
      bodyLarge: AppTextStyles.bodyLg,
      bodyMedium: AppTextStyles.bodyMd,
      bodySmall: AppTextStyles.bodySm,

      // Subtitle styles
      titleLarge: AppTextStyles.bodyLgMedium,
      titleMedium: AppTextStyles.bodyMdMedium,
      titleSmall: AppTextStyles.bodyXs,

      // Label styles (button text, etc.)
      labelLarge: AppTextStyles.bodyLgSemiBold,
      labelMedium: AppTextStyles.bodyMdSemiBold,
      labelSmall: AppTextStyles.bodyXsSemiBold,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryDarkBlue,    // Azul oscuro corporativo
      secondary: AppColors.primaryLightBlue,  // Azul claro corporativo
      error: AppColors.destructive,
      // background: AppColors.gray01,
      surface: AppColors.surface,
      onPrimary: AppColors.gray01,
      // Text color on primary elements
      onSecondary: AppColors.gray01,
      // Text color on secondary elements
      onError: AppColors.gray01, // Text color on error elements
    ),
  );
  static final BoxDecoration sectionBorderGray05 = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: AppColors.gray05),
    color: Colors.white, // Fondo blanco
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(51), // Sombra suave
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
}