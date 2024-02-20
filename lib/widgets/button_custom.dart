import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/common/app_fonts.dart';

class FillButtonCustom extends StatelessWidget {
  const FillButtonCustom({
    super.key,
    required this.label,
    required this.onTap,
    this.isExpanded,
  });

  final String label;
  final Function onTap;
  final bool? isExpanded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Align(
        child: Material(
          color: AppColor.blue,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onTap(),
            child: Container(
              width: isExpanded == null
                  ? null
                  : isExpanded!
                      ? double.infinity
                      : null,
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 12,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: semiBold,
                  color: AppColor.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class OutButtonCustom extends StatelessWidget {
  const OutButtonCustom({
    Key? key,
    required this.label,
    required this.onTap,
    this.isExpanded,
  }) : super(key: key);

  final String label;
  final Function onTap;
  final bool? isExpanded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Align(
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent, 
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onTap(),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.blue, 
                  width: 2, // Set border width
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              width: isExpanded == null
                  ? null
                  : isExpanded!
                      ? double.infinity
                      : null,
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 12,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: semiBold,
                  color: AppColor.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}