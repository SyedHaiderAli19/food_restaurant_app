import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Size size;
  final void Function() onPressed;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.black,
        overlayColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Container(
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.labelSmall!.copyWith(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
