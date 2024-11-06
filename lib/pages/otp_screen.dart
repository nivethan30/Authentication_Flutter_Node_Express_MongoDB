import 'package:flutter/material.dart';
import '../pages/reset_password.dart';
import '../utils/constants.dart';
import '../widgets/snackbar_widget.dart';
import '../widgets/auth_widgets.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String generatedOtp;
  const OtpScreen({super.key, required this.generatedOtp, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isLoading = false;
  final TextEditingController _pinController = TextEditingController();
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
      body: cardWidget(
          scHeight: size.height,
          scWidth: size.width,
          child: Column(
            children: [
              titleText('Verify OTP'),
              const SizedBox(height: 10),
              Text(
                maxLines: 2,
                textAlign: TextAlign.center,
                'Please Enter the OTP sent to your email ${widget.email}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Pinput(
                length: 6,
                onCompleted: (pin) {
                  _pinController.text = pin;
                },
                autofocus: true,
                obscureText: true,
                obscuringWidget: Container(
                  height: 7,
                  width: 7,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black87),
                ),
                pinAnimationType: PinAnimationType.fade,
              ),
              const SizedBox(height: 20),
              authButton(
                  scWidth: size.width,
                  text: 'Verify',
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    if (_pinController.text == widget.generatedOtp) {
                      navigatorkey.currentState?.push(MaterialPageRoute(
                          builder: (context) => ResetPassword(
                              email: widget.email, isForgot: true)));
                    } else {
                      alertSnackBar(message: 'Invalid OTP, Please try again');
                    }
                    setState(() {
                      isLoading = false;
                    });
                  })
            ],
          ),
          action: null),
    );
  }
}
