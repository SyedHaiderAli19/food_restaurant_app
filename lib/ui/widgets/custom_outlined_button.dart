import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final Size size;
  final SvgPicture icon;
  final void Function() onPressed;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.size,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        label: Text(
          text,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          overlayColor: Theme.of(context).colorScheme.secondary,
          side: BorderSide(width: 1.5, color: Colors.black),
        ),
        icon: icon ?? SizedBox(),
      ),
    );
  }
}
