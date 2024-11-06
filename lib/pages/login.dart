import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../widgets/snackbar_widget.dart';
import '../services/auth_service.dart';
import 'forgot_password.dart';
import 'signup.dart';
import '../widgets/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onPressed;
  const LoginPage({super.key, required this.onPressed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final AuthService _authService = AuthService();

  bool isObscureText = true;

  Future<void> signIn(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      final bool isLoggedIn =
          await _authService.login(email: email, password: password);
      if (!isLoggedIn) {
        alertSnackBar(message: "Login Failed");
      } else {
        widget.onPressed();
        alertSnackBar(message: "Login Successful");
      }
    } catch (e) {
      alertSnackBar(message: e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cardWidget(
            scHeight: size.height,
            scWidth: size.width,
            child: Column(
              children: [
                titleText('Welcome Back. Sign in to continue.'),
                const SizedBox(height: 10),
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(height: 10),
                textFieldWidget(
                    hintText: 'Email ID',
                    focusNode: _emailFocusNode,
                    controller: _emailIdController,
                    textInputType: TextInputType.emailAddress,
                    autofillHints: [AutofillHints.email]),
                const SizedBox(
                  height: 20,
                ),
                textFieldWidget(
                    hintText: 'Password',
                    focusNode: _passwordFocusNode,
                    obscureText: isObscureText,
                    controller: _passwordController,
                    textInputType: TextInputType.visiblePassword,
                    autofillHints: [AutofillHints.password],
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscureText = !isObscureText;
                        });
                      },
                    )),
                const SizedBox(
                  height: 5,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                authButton(
                    scWidth: size.width,
                    text: 'Login',
                    onPressed: () {
                      if ((_emailIdController.text.isNotEmpty &&
                              EmailValidator.validate(
                                  _emailIdController.text)) &&
                          _passwordController.text.isNotEmpty) {
                        signIn(
                            _emailIdController.text, _passwordController.text);
                      } else {
                        alertSnackBar(message: 'Please Fill the fields');
                      }
                    }),
              ],
            ),
            action: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.redAccent),
                    ))
              ],
            )),
        if (isLoading)
          Container(
              color: Colors.grey.shade200.withOpacity(0.1),
              height: size.height,
              width: size.width,
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )))
      ],
    );
  }
}
