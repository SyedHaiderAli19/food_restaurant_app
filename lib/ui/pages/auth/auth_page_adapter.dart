import 'package:auth/auth.dart';
import 'package:flutter/material.dart';

abstract class IAuthPageAdapter {
  void onAuthSuccess(BuildContext context, AuthServiceContract authService);
}

class AuthPageAdapter implements IAuthPageAdapter {
  final Widget Function(AuthServiceContract authService) onUserAuthenticated;

  AuthPageAdapter({required this.onUserAuthenticated});

  @override
  void onAuthSuccess(BuildContext context, AuthServiceContract authService) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => onUserAuthenticated(authService),
        ),
        (Route<dynamic> route) => false,
      );
    });
  }
}
