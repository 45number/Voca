import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizes.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      colorScheme:
          ColorScheme.fromSeed(
        seedColor:
            AppColors.primary,
        brightness:
            Brightness.light,
      ),

      scaffoldBackgroundColor:
          AppColors.background,

      appBarTheme:
          const AppBarTheme(
        centerTitle: false,
      ),

      dividerTheme:
          const DividerThemeData(
        space: 1,
      ),

      listTileTheme:
          const ListTileThemeData(
        contentPadding:
            EdgeInsets.symmetric(
          horizontal: 16,
        ),
      ),

      cardTheme: CardThemeData(
        elevation:
            AppSizes.cardElevation,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            AppRadius.lg,
          ),
        ),
      ),

      inputDecorationTheme:
          InputDecorationTheme(
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppRadius.md,
          ),
        ),
      ),

      filledButtonTheme:
          FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
          // minimumSize:
          //     const Size(
          //   double.infinity,
          //   AppSizes.buttonHeight,
          // ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              AppRadius.md,
            ),
          ),
        ),
      ),

      outlinedButtonTheme:
          OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
          // minimumSize:
          //     const Size(
          //   double.infinity,
          //   AppSizes.buttonHeight,
          // ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              AppRadius.md,
            ),
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,

      colorScheme:
          ColorScheme.fromSeed(
        seedColor:
            AppColors.primaryDark,
        brightness:
            Brightness.dark,
      ),

      scaffoldBackgroundColor:
          AppColors.backgroundDark,

      appBarTheme:
          const AppBarTheme(
        centerTitle: false,
      ),

      dividerTheme:
          const DividerThemeData(
        space: 1,
      ),

      listTileTheme:
          const ListTileThemeData(
        contentPadding:
            EdgeInsets.symmetric(
          horizontal: 16,
        ),
      ),

      cardTheme: CardThemeData(
        color:
            AppColors.surfaceDark,
        elevation:
            AppSizes.cardElevation,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            AppRadius.lg,
          ),
        ),
      ),

      inputDecorationTheme:
          InputDecorationTheme(
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            AppRadius.md,
          ),
        ),
      ),

      filledButtonTheme:
          FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
          // minimumSize:
          //     const Size(
          //   double.infinity,
          //   AppSizes.buttonHeight,
          // ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              AppRadius.md,
            ),
          ),
        ),
      ),

      outlinedButtonTheme:
          OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
          // minimumSize:
          //     const Size(
          //   double.infinity,
          //   AppSizes.buttonHeight,
          // ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              AppRadius.md,
            ),
          ),
        ),
      ),
    );
  }
}