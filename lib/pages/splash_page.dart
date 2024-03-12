import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flype/common/app_assets.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/app_fonts.dart';
import 'package:flype/config/flavor_config.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    /// time auto navigator
    Timer(
      const Duration(seconds: 3),
      () {
        context.replace("/");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    /// Flavor
    FlavorType flavor = FlavorConfig.instance.flavor;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (flavor == FlavorType.free)
                  Container(
                    height: 300,
                    width: 300,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppAsset.logoFree),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 300,
                    width: 300,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppAsset.logo),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.1),
                  child: Text(
                    'FlypeApp',
                    style: whiteTextstyle.copyWith(
                      fontSize: 32,
                      fontWeight: medium,
                      letterSpacing: 7,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
