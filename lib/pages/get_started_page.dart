import 'package:flutter/material.dart';
import 'package:flype/common/app_assets.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/pages/login_page.dart';
import 'package:flype/widgets/button_custom.dart';
import 'package:flype/widgets/footer_custom.dart';
// import 'package:flype/widgets/navbar.dart';
import 'package:flype/widgets/title_custom.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                AppAsset.background,
                fit: BoxFit.cover,
              ),
            ),

            // Judul
            const Padding(
              padding:
                  EdgeInsets.only(top: 30, left: 24, bottom: 24, right: 24),
              child: TitleCustom(
                title: "Best Social App To\nMake New Friends",
                subtitle: "Find People With The Same\nInsterets As You",
              ),
            ),

            // Logo
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

            // Tombol
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FooterCustom(
                      onSignUp: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const Navbar(),
                        //   ),
                        // );
                      },
                      label: "Want See Our FLYPE?",
                      labelTap: "Guest",
                    ),
                    OutButtonCustom(
                      label: "Login",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              onLogin: () {},
                              onRegister: () {},
                            ),
                          ),
                        );
                      },
                      isExpanded: true,
                    ),
                    const SizedBox(height: 16), // Tambahkan jarak antara tombol
                    FillButtonCustom(
                      label: "Register",
                      onTap: () {},
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
