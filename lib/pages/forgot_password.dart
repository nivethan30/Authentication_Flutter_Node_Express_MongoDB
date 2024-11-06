import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../pages/otp_screen.dart';
import '../utils/constants.dart';
import '../widgets/snackbar_widget.dart';
import '../services/auth_service.dart';
import '../widgets/auth_widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  final TextEditingController _emailIdController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final AuthService _authService = AuthService();

  Future<void> _sendResetEmail(String email) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      final Tuple2<bool, String> isSent =
          await _authService.forgotPassword(email: email);
      if (isSent.item1) {
        navigatorkey.currentState?.push(MaterialPageRoute(
            builder: (context) => OtpScreen(
                  generatedOtp: isSent.item2,
                  email: email,
                )));
        alertSnackBar(message: "OTP Sent Your Email Successfully");
      } else {
        alertSnackBar(message: "Please Try Again");
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
    _emailFocusNode.dispose();
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
                  titleText('Reset Your Passsword'),
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    'Please Enter Your Email ID to reset your password',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  textFieldWidget(
                      hintText: 'Email ID',
                      focusNode: _emailFocusNode,
                      textInputType: TextInputType.emailAddress,
                      autofillHints: [AutofillHints.email],
                      controller: _emailIdController),
                  const SizedBox(
                    height: 20,
                  ),
                  authButton(
                      scWidth: size.width,
                      text: 'Send Email',
                      onPressed: () {
                        if (_emailIdController.text.isNotEmpty &&
                            EmailValidator.validate(_emailIdController.text)) {
                          _sendResetEmail(_emailIdController.text);
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              action: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Back to Sign in Screen',
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
}
