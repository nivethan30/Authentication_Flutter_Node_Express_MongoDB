import 'package:flutter/material.dart';
import '../pages/main_screen.dart';
import '../utils/constants.dart';
import '../widgets/snackbar_widget.dart';
import '../services/auth_service.dart';
import '../widgets/auth_widgets.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final bool isForgot;
  const ResetPassword({super.key, required this.email, required this.isForgot});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isLoading = false;
  final AuthService _authService = AuthService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmFocusNode = FocusNode();

  bool passwordText = true;
  bool confirmPasswordText = true;

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
            action: null,
            child: Column(
              children: [
                titleText('Reset Your Passsword'),
                const SizedBox(height: 20),
                textFieldWidget(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    hintText: 'New Password',
                    obscureText: passwordText,
                    textInputType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordText ? Icons.visibility : Icons.visibility_off,
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
                    controller: _confirmPasswordController,
                    focusNode: _confirmFocusNode,
                    hintText: 'Confirm Password',
                    obscureText: confirmPasswordText,
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
                const SizedBox(height: 20),
                authButton(
                    onPressed: () async {
                      _updatePassword();
                    },
                    scWidth: size.width,
                    text: 'Update Password')
              ],
            ),
          ),
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

  Future<void> _updatePassword() async {
    if (_passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      if (_passwordController.text == _confirmPasswordController.text) {
        try {
          setState(() {
            isLoading = true;
          });
          await Future.delayed(const Duration(seconds: 2));
          final bool isUpdated = await _authService.resetPassword(
              email: widget.email, newPassword: _passwordController.text);
          if (isUpdated) {
            _navigate();
          }
        } catch (e) {
          alertSnackBar(message: e.toString());
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        alertSnackBar(message: 'Password and Confirm Password does not match');
      }
    } else {
      alertSnackBar(message: 'Please Fill the fields');
    }
  }

  void _navigate() {
    if (widget.isForgot) {
      navigatorkey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false);
      alertSnackBar(message: 'Password Updated Successfully');
    } else {
      navigatorkey.currentState?.pop();
      alertSnackBar(
          message: 'Password Updated Successfully',
          color: Colors.deepPurple.shade800);
    }
  }
}
