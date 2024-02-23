import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/app_fonts.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: AppColor.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColor.white),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              'Loading',
              style: whiteTextstyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
                color: AppColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
