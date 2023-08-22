import 'package:flutter/material.dart';

import '../../themes/app_themes.dart';
import '../constants/ui_helpers.dart';

class KTextFormField extends StatefulWidget {
  final String? Function(String?)? validator;
  final void Function(dynamic)? onChanged;
  final TextEditingController? controller;
  final String? hint;
  final String? initialValue;
  final String? label;
  final bool obscureText;
  final bool isRequired;
  final TextInputType keyboardType;
  final int maxLines;
  final Widget? prefixIcon;

  const KTextFormField(
      {super.key,
      this.validator,
      this.onChanged,
      this.controller,
      this.hint,
      this.initialValue,
      this.label,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.maxLines = 1,
      this.prefixIcon,
      this.isRequired = true});

  @override
  State<KTextFormField> createState() =>
      _KTextFormFieldState(obscureText: obscureText);
}

class _KTextFormFieldState extends State<KTextFormField> {
  String? errorText;
  bool interacted = false;
  bool obscureText;
  _KTextFormFieldState({required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.label != null)
          Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.label!,
                    ),
                  ),
                  xsWidthSpan,
                  widget.isRequired
                      ? const Text(
                          "*",
                          style: TextStyle(color: Colors.red),
                        )
                      : const Text("")
                ],
              ),
              sHeightSpan,
            ],
          ),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: obscureText,
          initialValue: widget.initialValue,
          maxLines: widget.maxLines,
          validator: widget.validator,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: errorText != null
                  ? const BorderSide(color: ERROR_COLOR)
                  : const BorderSide(color: LIGHT_PRIMARY_COLOR),
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: DARK_GREY,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                  )
                : interacted && errorText == null
                    ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                    : null,
          ),
          onChanged: (value) {
            if (widget.validator != null) {
              setState(() {
                errorText = widget.validator!(value);
                interacted = true;
              });
            }

            widget.onChanged?.call(value);
          },
        ),
        if (errorText != null)
          Column(
            children: [
              sHeightSpan,
              Text(
                errorText ?? "",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: ERROR_COLOR,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
