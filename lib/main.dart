import 'package:da_order/common/component/custom_text_form_field.dart';
import 'package:da_order/common/view/splash_screen.dart';
import 'package:da_order/user/view/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: SplashScreen()
    );
  }
}
