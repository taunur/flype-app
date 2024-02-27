import 'package:flutter/material.dart';
import 'package:flype/common/app_assets.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/export.dart';
import 'package:flype/data/model/user_model.dart';
import 'package:flype/data/provider/auth_provider.dart';
import 'package:flype/routes/config_go_router.dart';
import 'package:flype/widgets/button_custom.dart';
import 'package:flype/widgets/footer_custom.dart';
import 'package:flype/widgets/input_custom.dart';
import 'package:flype/widgets/loading_button.dart';
import 'package:flype/widgets/title_custom.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    authProvider;
    final formKey = GlobalKey<FormState>();

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

            /// Layout utama menggunakan Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Widget di atas
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 24),
                  child: TitleCustom(
                    title: AppLocalizations.of(context)!.registerTitle,
                    subtitle: AppLocalizations.of(context)!.registerSub,
                  ),
                ),

                /// Widget tengah
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomOutlinedTextFormField(
                                title:
                                    AppLocalizations.of(context)!.hintInputName,
                                hintText:
                                    AppLocalizations.of(context)!.hintInputName,
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomOutlinedTextFormField(
                                title: AppLocalizations.of(context)!.emailTitle,
                                hintText: AppLocalizations.of(context)!
                                    .hintEmailTitle,
                                iconData: Icons.email,
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomOutlinedTextFormField(
                                title:
                                    AppLocalizations.of(context)!.passwordTitle,
                                hintText: "*****",
                                iconData: Icons.lock,
                                isPassword: true,
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password.';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters long.';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Widget di bawah
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
                        onSignUp: () => context.go('/login'),
                        label: AppLocalizations.of(context)!.footerRegister,
                        labelTap: AppLocalizations.of(context)!.buttonLogin,
                      ),
                      context.read<AuthProvider>().isLoadingRegister
                          ? const LoadingButton()
                          : FillButtonCustom(
                              label: AppLocalizations.of(context)!.buttonRegister,
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  final scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  final UserModel user = UserModel(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  final result = await authProvider.register(
                                    name: user.name!,
                                    email: user.email!,
                                    password: user.password!,
                                  );
                                  if (result) {
                                    return goRouter.go('/login');
                                  } else {
                                    final registerError =
                                        authProvider.authError;
                                    if (registerError != null &&
                                        registerError.contains(
                                            'Email is already taken')) {
                                      scaffoldMessenger.showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Email is already taken"),
                                        ),
                                      );
                                    } else {
                                      scaffoldMessenger.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Failed to register, please try again later."),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
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
