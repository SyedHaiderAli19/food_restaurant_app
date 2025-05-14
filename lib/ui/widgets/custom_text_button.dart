import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Color? color;
  final String text;
  final Size? size;
  final void Function() onPressed;
  const CustomTextButton({
    super.key,
    this.color,
    required this.text,
    this.size,
    required this.onPressed,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        shadowColor: Colors.black,
        overlayColor: Theme.of(context).colorScheme.secondary,
        minimumSize: size,
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelSmall!.copyWith(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
