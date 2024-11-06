import 'package:flutter/material.dart';
import '../pages/homepage.dart';
import '../pages/login.dart';
import '../utils/storage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    String? data = await SecureStorage.instance.read("token");
    if (data != null) {
      if (data.isNotEmpty) {
        setState(() {
          isLoggedIn = true;
        });
      }
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  void toggleStatus() {
    setState(() {
      isLoggedIn = !isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoggedIn
            ? Homepage(
                onPressed: toggleStatus,
              )
            : LoginPage(
                onPressed: toggleStatus,
              ));
  }
}
