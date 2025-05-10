import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final double fontSize;
  final FontWeight fontWeight;
  final void Function(String val) onChanged;
  const CustomTextField({
    super.key,
    required this.hint,
    required this.fontSize,
    required this.fontWeight,
    required this.onChanged,
  });

  final _border = const OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(color: Colors.black, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 0,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.black,
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
          color: Colors.black,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          hintText: hint,
          hintStyle: TextStyle(fontSize: fontSize, color: Colors.black),
          enabledBorder: _border,
          border: _border,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
