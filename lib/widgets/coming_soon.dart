import 'package:flutter/material.dart';
import 'package:flype/common/export.dart';

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
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.comingSoon,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.descComingSoon,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
