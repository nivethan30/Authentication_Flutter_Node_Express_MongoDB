import 'package:flutter/material.dart';
import 'pages/main_screen.dart';
import 'providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Node Auth',
          theme: ThemeData.light().copyWith(
              textTheme:
                  ThemeData.light().textTheme.apply(fontFamily: 'Poppins')),
          navigatorKey: navigatorkey,
          home: const MainScreen()),
    );
  }
}
