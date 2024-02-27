import 'package:flutter/material.dart';
import 'package:flype/common/app_assets.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/export.dart';
import 'package:flype/widgets/button_custom.dart';
import 'package:flype/widgets/title_custom.dart';
import 'package:go_router/go_router.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: Image.asset(
                AppAsset.background,
                fit: BoxFit.cover,
              ),
            ),

            /// Judul
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 24, bottom: 24, right: 24),
              child: TitleCustom(
                title: AppLocalizations.of(context)!.getStartedTitle,
                subtitle: AppLocalizations.of(context)!.getStartedSub,
              ),
            ),

            /// Logo
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAsset.getStarted,
                    height: 300,
                    width: 300,
                  ),
                ],
              ),
            ),

            /// Tombol
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutButtonCustom(
                      label: AppLocalizations.of(context)!.buttonLogin,
                      onTap: () => context.go("/login"),
                      isExpanded: true,
                    ),
                    const SizedBox(height: 16),
                    FillButtonCustom(
                      label: AppLocalizations.of(context)!.buttonRegister,
                      onTap: () => context.go("/register"),
                      isExpanded: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
