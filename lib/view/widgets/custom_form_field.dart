import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.hidden,
    super.key,
    this.onChanged,
    this.hintText,
    required this.controller,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines,
    this.prefixIcon,
  });

  final String? labelText, hintText;
  final bool hidden;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final int? maxLines;
  final IconData? prefixIcon;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isHidden;

  @override
  void initState() {
    super.initState();
    isHidden = widget.hidden;
  }

  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: font,
        color: Colors.white,
        fontSize: 20,
      ),
      obscureText: isHidden,
      validator: widget.validator ??
          (value) {
            if (value!.isEmpty) {
              return 'Field is required';
            }
            return null;
          },
      cursorColor: kBlue,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 2),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: Colors.amber, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          gapPadding: 16,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(
            color: Colors.amber,
            width: 2,
          ),
        ),
        suffixIcon: widget.hidden
            ? IconButton(
                icon: Icon(
                  isHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white70,
                ),
                onPressed: toggleVisibility,
              )
            : null,
      ),
    );
  }
}
