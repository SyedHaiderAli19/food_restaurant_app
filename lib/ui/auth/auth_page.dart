import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_restaurant_app/ui/widgets/custom_outlined_button.dart';
import 'package:food_restaurant_app/ui/widgets/custom_text_button.dart';
import 'package:food_restaurant_app/ui/widgets/custom_text_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 110),
              child: _buildLogo(),
            ),
            SizedBox(height: 50),
            _buildUI(),
          ],
        ),
      ),
    );
  }

  _buildLogo() => Container(
    alignment: Alignment.center,
    child: Column(
      children: [
        SvgPicture.asset('assets/logo.svg', fit: BoxFit.cover),
        SizedBox(height: 10),
        Text(
          'Foodie',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  _buildUI() => Expanded(
    child: PageView(
      physics: NeverScrollableScrollPhysics(),
      children: [_signIn()],
    ),
  );

  _signIn() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      children: [
        ..._emailAndPassword(),
        SizedBox(height: 30),
        CustomTextButton(
          text: 'Sign In',
          size: Size(double.infinity, 54),
          onPressed: () {},
        ),
        SizedBox(height: 30),
        CustomOutlinedButton(
          onPressed: () {},
          text: 'Sign In With Google',
          size: Size(double.infinity, 50),
          icon: SvgPicture.asset(
            'assets/google-icon.svg',
            height: 18,
            width: 18,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 30),
        RichText(
          text: TextSpan(
            text: "Don't have an account?",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: "Sign Up",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
        ),
      ],
    ),
  );

  List<Widget> _emailAndPassword() => [
    CustomTextField(
      hint: 'Email',
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      onChanged: (val) {},
    ),
    SizedBox(height: 30),
    CustomTextField(
      hint: 'Password',
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      onChanged: (val) {},
    ),
  ];
}
