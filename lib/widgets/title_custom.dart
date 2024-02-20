import 'package:flutter/material.dart';
import 'package:flype/common/app_fonts.dart';

class TitleCustom extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleCustom({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontWeight: semiBold,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontWeight: regular,
              ),
        ),
      ],
    );
  }
}
