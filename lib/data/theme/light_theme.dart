import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: GoogleFonts.nunitoSans().fontFamily,
  primaryColor: AppColor.blue,
  brightness: Brightness.light,
  highlightColor: AppColor.white,
  hintColor: const Color(0xFF9E9E9E),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
