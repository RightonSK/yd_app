import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    Key? key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText,
    this.lines,
    this.maxLength,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.enabled,
  }) : super(key: key);
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? lines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      cursorWidth: 2,
      maxLines: lines ?? 1,
      minLines: lines ?? 1,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: primaryNavyColor.withOpacity(.6),
          fontWeight: FontWeight.normal,
        ),
        fillColor: Colors.white.withOpacity(0.9),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: primaryNavyColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: primaryNavyColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
    );
  }
}
