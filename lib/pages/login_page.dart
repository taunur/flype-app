import 'package:flutter/material.dart';
import 'package:flype/common/app_assets.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/pages/register_page.dart';
import 'package:flype/widgets/button_custom.dart';
import 'package:flype/widgets/footer_custom.dart';
import 'package:flype/widgets/input_custom.dart';
import 'package:flype/widgets/title_custom.dart';

class LoginPage extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;
  const LoginPage({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

            // Layout utama menggunakan Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Widget di atas
                const Padding(
                  padding: EdgeInsets.only(top: 30, left: 24, bottom: 24, right: 24),
                  child: TitleCustom(
                    title: "Let’s login you in.",
                    subtitle: "Welcome back.\nYou’ve been missed.",
                  ),
                ),

                // Widget tengah
                const Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomOutlinedTextFormField(
                              title: "Email",
                              hintText: "example@gmail.com",
                              iconData: Icons.email,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomOutlinedTextFormField(
                              title: "Password",
                              hintText: "*****",
                              iconData: Icons.lock,
                              isPassword: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Widget di bawah
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    top: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FooterCustom(
                        onSignUp: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(
                                onLogin: () {},
                                onRegister: () {},
                              ),
                            ),
                          );
                        },
                        label: "Don’t have an account?",
                        labelTap: "Register",
                      ),
                      FillButtonCustom(
                        label: "Login",
                        onTap: () {},
                        isExpanded: true,
                      ),
                    ],
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
