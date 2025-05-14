import 'package:auth/src/domain/signup_service_contract.dart';
import 'package:auth/src/infra/managers/auth_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_restaurant_app/models/user_model.dart';
import 'package:food_restaurant_app/state_management/auth/auth_bloc.dart';
import 'package:food_restaurant_app/state_management/auth/auth_event.dart';
import 'package:food_restaurant_app/state_management/auth/auth_state.dart';
import 'package:food_restaurant_app/ui/widgets/custom_outlined_button.dart';
import 'package:food_restaurant_app/ui/widgets/custom_text_button.dart';
import 'package:food_restaurant_app/ui/widgets/custom_text_field.dart';

class AuthPage extends StatefulWidget {
  final AuthManager manager;
  final SignupServiceContract signupService;
  const AuthPage({
    super.key,
    required this.manager,
    required this.signupService,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final PageController _controller = PageController();
  String _userName = '';
  String _email = '';
  String _password = '';
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
            BlocConsumer<AuthBloc, AuthState>(
              builder: (_, state) {
                return _buildUI();
              },
              listener: (context, state) {
                if (state is LoadingState) {
                  _showLoader();
                }

                if (state is ErrorState) {
                  //Incase of error state
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMessage,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                }

                _hideLoader();
              },
            ),
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
      controller: _controller,
      children: [_signIn(), _signUp()],
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
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(
              SignInEvent(
                authService: widget.manager.email(
                  email: _email,
                  password: _password,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 30),
        CustomOutlinedButton(
          onPressed: () {
            BlocProvider.of<AuthBloc>(
              context,
            ).add(SignInEvent(authService: widget.manager.google));
          },
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
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.elasticOut,
                        );
                      },
              ),
            ],
          ),
        ),
      ],
    ),
  );

  _signUp() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      children: [
        CustomTextField(
          height: 50,
          hint: 'Username',
          keyboardType: TextInputType.name,
          isPassword: false,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          onChanged: (val) {
            _userName = val;
          },
        ),
        SizedBox(height: 30),
        ..._emailAndPassword(),
        SizedBox(height: 30),
        CustomTextButton(
          text: 'Sign Up',
          size: Size(double.infinity, 54),
          onPressed: () {
            final user = UserModel(
              name: _userName,
              email: _email,
              password: _password,
            );

            BlocProvider.of<AuthBloc>(context).add(
              SignUpEvent(signUpService: widget.signupService, userModel: user),
            );
          },
        ),

        SizedBox(height: 30),

        RichText(
          text: TextSpan(
            text: "Already have an account?",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: "Sign In",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        _controller.previousPage(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.elasticOut,
                        );
                      },
              ),
            ],
          ),
        ),
      ],
    ),
  );

  List<Widget> _emailAndPassword() => [
    CustomTextField(
      height: 50,
      hint: 'Email',
      keyboardType: TextInputType.emailAddress,
      isPassword: false,
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      onChanged: (val) {
        _email = val;
      },
    ),
    SizedBox(height: 30),
    CustomTextField(
      height: 50,
      isPassword: true,
      keyboardType: TextInputType.text,
      hint: 'Password',
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      onChanged: (val) {
        _password = val;
      },
    ),
  ];

  _showLoader() {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(backgroundColor: Colors.white70),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => alert,
    );
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
