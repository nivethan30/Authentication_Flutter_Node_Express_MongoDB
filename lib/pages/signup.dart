import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/snackbar_widget.dart';
import '../services/auth_service.dart';
import '../widgets/auth_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _userNameFocusNode = FocusNode();

  final AuthService _authService = AuthService();

  bool passwordText = true;
  bool confirmPasswordText = true;

  Future<void> signUp(String userName, String email, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      final bool isCreated = await _authService.signUp(
          newUser: UserModel(name: userName, email: email, password: password));
      if (!isCreated) {
        alertSnackBar(message: 'Signup Failed');
      } else {
        _popContext();
        alertSnackBar(message: 'Signup Successful');
      }
    } catch (e) {
      alertSnackBar(message: e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _popContext() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _userNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          cardWidget(
              scHeight: size.height,
              scWidth: size.width,
              child: Column(
                children: [
                  titleText('Sign Up to Create an Account'),
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 100,
                  ),
                  const SizedBox(height: 10),
                  textFieldWidget(
                      hintText: 'UserName',
                      focusNode: _userNameFocusNode,
                      autofillHints: [AutofillHints.name],
                      textInputType: TextInputType.name,
                      controller: _userNameController),
                  const SizedBox(
                    height: 20,
                  ),
                  textFieldWidget(
                      hintText: 'Email ID',
                      focusNode: _emailFocusNode,
                      autofillHints: [AutofillHints.email],
                      textInputType: TextInputType.emailAddress,
                      controller: _emailIdController),
                  const SizedBox(
                    height: 20,
                  ),
                  textFieldWidget(
                      hintText: 'Password',
                      focusNode: _passwordFocusNode,
                      obscureText: passwordText,
                      controller: _passwordController,
                      textInputType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordText = !passwordText;
                          });
                        },
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  textFieldWidget(
                      hintText: 'Confirm Password',
                      focusNode: _confirmPasswordFocusNode,
                      obscureText: confirmPasswordText,
                      controller: _confirmPasswordController,
                      textInputType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          confirmPasswordText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            confirmPasswordText = !confirmPasswordText;
                          });
                        },
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  authButton(
                      scWidth: size.width,
                      text: 'Sign Up',
                      onPressed: () {
                        _signUpButtonAction();
                      }),
                ],
              ),
              action: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already Have an Account? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Sign In',
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
      ),
    );
  }

  Future<void> _signUpButtonAction() async {
    if ((_emailIdController.text.isNotEmpty &&
            EmailValidator.validate(_emailIdController.text)) &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      if (_passwordController.text == _confirmPasswordController.text) {
        signUp(_userNameController.text, _emailIdController.text,
            _passwordController.text);
      } else {
        alertSnackBar(message: 'Password and Confirm Password does not match');
      }
    } else {
      alertSnackBar(message: 'Please Fill the Fields');
    }
  }
}
