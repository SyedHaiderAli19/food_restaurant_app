import 'package:auth/auth.dart';
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
import 'package:food_restaurant_app/ui/pages/auth/auth_page_adapter.dart';
import 'package:food_restaurant_app/ui/widgets/custom_outlined_button.dart';
import 'package:food_restaurant_app/ui/widgets/custom_text_button.dart';
import 'package:food_restaurant_app/ui/widgets/custom_text_field.dart';

class AuthPage extends StatefulWidget {
  final AuthManager manager;
  final IAuthPageAdapter adapter;
  final SignupServiceContract signupService;
  const AuthPage({
    super.key,
    required this.manager,
    required this.adapter,
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
  AuthServiceContract? authService;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                builder: (context, state) {
                  return _buildUI();
                },
                listener: (context, state) {
                  if (state is LoadingState) {
                    _showLoader();
                  }

                  if (state is AuthSuccessState) {
                    _hideLoader();
                    if (authService != null) {
                      widget.adapter.onAuthSuccess(context, authService!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            "Auth Service Not Initialized",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  }
                  if (state is ErrorState) {
                    _hideLoader();
                    //Incase of error state
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.black,
                        content: Text(
                          state.errorMessage,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
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

  _buildUI() => SizedBox(
    height: 500,
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
          color: Colors.black,
          text: 'Sign In',
          size: Size(double.infinity, 54),
          onPressed: () {
            authService = widget.manager.serviceContract(AuthType.email);
            BlocProvider.of<AuthBloc>(context).add(
              SignInEvent(
                authService: authService!,
                type: AuthType.email,
                email: _email,
                password: _password,
              ),
            );
          },
        ),
        SizedBox(height: 30),
        CustomOutlinedButton(
          onPressed: () {
            authService = widget.manager.serviceContract(AuthType.google);
            BlocProvider.of<AuthBloc>(context).add(
              SignInEvent(authService: authService!, type: AuthType.google),
            );
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
          inputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
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
          color: Colors.black,
          size: Size(double.infinity, 54),
          text: 'Sign Up',
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
      inputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
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
      inputAction: TextInputAction.done,
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
