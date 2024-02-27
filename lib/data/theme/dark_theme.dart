import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.nunitoSans().fontFamily,
  primaryColor: AppColor.blue,
  brightness: Brightness.dark,
  highlightColor: AppColor.black,
  hintColor: const Color(0xFFc7c7c7),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
