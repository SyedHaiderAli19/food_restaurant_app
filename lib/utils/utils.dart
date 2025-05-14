import 'package:flutter/material.dart';

bottomLoader() => Container(
  alignment: Alignment.center,
  child: Center(
    child: SizedBox(
      width: 33,
      height: 33,
      child: CircularProgressIndicator(strokeWidth: 1.5),
    ),
  ),
);
