import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/snackbar_widget.dart';
import '../widgets/home_widgets.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'reset_password.dart';

class Homepage extends StatefulWidget {
  final VoidCallback onPressed;
  const Homepage({super.key, required this.onPressed});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: size.height,
        width: size.width,
        child: Consumer<UserProvider>(
            builder: (context, UserProvider userProvider, _) {
          if (userProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (userProvider.isError) {
            return Center(
                child: Column(
              children: [
                Text(userProvider.errorMessage),
                const SizedBox(
                  height: 20,
                ),
                homeButtons(
                  size.width,
                  text: 'SignOut',
                  iconData: Icons.logout,
                  onPressed: () async {
                    final bool isLoggedOut = await AuthService().signOut();
                    if (isLoggedOut) {
                      widget.onPressed();
                    }
                  },
                )
              ],
            ));
          } else {
            final UserModel user = userProvider.user;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Profile Details', style: TextStyle(fontSize: 30)),
                  const SizedBox(height: 20),
                  TitleValueRow(
                    title: 'Name',
                    value: user.name,
                  ),
                  TitleValueRow(
                    title: 'Email',
                    value: user.email,
                  ),
                  TitleValueRow(
                    title: 'Id',
                    value: user.id ?? "",
                  ),
                  TitleValueRow(
                    title: 'Token',
                    value: user.token ?? "",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (user.email.isNotEmpty)
                    homeButtons(
                      size.width,
                      text: 'Update Password',
                      iconData: Icons.password,
                      onPressed: () async {
                        navigatorkey.currentState?.push(MaterialPageRoute(
                            builder: (context) => ResetPassword(
                                  email: user.email,
                                  isForgot: false,
                                )));
                      },
                    ),
                  if (user.email.isNotEmpty)
                    const SizedBox(
                      height: 20,
                    ),
                  homeButtons(
                    size.width,
                    text: 'SignOut',
                    iconData: Icons.logout,
                    onPressed: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      final bool isLoggedOut = await AuthService().signOut();
                      if (isLoggedOut) {
                        widget.onPressed();
                        alertSnackBar(message: 'Logged Out Successfully');
                      }
                    },
                  )
                ],
              ),
            );
          }
        }));
  }
}
