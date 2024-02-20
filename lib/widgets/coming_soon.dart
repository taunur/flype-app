import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.developer_mode_rounded,
            color: AppColor.white,
          ),
          const SizedBox(height: 20),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'We are developing this page\nfor new great features',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
