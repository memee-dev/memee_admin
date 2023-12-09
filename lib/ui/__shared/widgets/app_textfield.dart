import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

// ignore: must_be_immutable
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool readOnly;
  final double? width;
  final Function(String)? onChanged;
  List<TextInputFormatter>? inputFormatters;

  AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.readOnly = false,
    this.width,
    this.inputFormatters,
    this.onChanged,
  });

  AppTextField.digits({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.readOnly = false,
    this.width,
    this.onChanged,
  }) {
    inputFormatters = [
      FilteringTextInputFormatter.digitsOnly,
    ];
  }

  AppTextField.decimals({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.readOnly = false,
    this.width,
    this.onChanged,
  }) {
    inputFormatters = [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      controller: controller,
      style: Theme.of(context).textTheme.bodySmall,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    ).sizedBoxW(width);
  }
}
