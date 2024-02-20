import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';

class FooterCustom extends StatelessWidget {
  final VoidCallback onSignUp;
  final String label;
  final String labelTap;

  const FooterCustom({
    Key? key,
    required this.onSignUp, required this.label, required this.labelTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.normal,
                ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onSignUp,
            child: Text(
              labelTap,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
