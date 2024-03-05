import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';

class CustomOutlinedTextFormField extends StatefulWidget {
  final String title;
  final String hintText;
  final bool isPassword;
  final IconData? iconData;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const CustomOutlinedTextFormField({
    Key? key,
    required this.title,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
    this.validator,
    this.onChanged,
    this.iconData,
  }) : super(key: key);

  @override
  State<CustomOutlinedTextFormField> createState() =>
      _CustomOutlinedTextFormFieldState();
}

class _CustomOutlinedTextFormFieldState
    extends State<CustomOutlinedTextFormField> {
  bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.white,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          obscureText: widget.isPassword ? _isObscure : false,
          validator: widget.validator,
          onChanged: widget.onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(color: AppColor.white),
          decoration: InputDecoration(
            suffixIcon: !widget.isPassword
                ? Icon(widget.iconData ?? Icons.person, color: AppColor.white)
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    color: AppColor.white,
                  ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppColor.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }
}
