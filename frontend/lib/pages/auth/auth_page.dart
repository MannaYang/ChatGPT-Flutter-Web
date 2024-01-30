import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/view/auth_form.dart';

///
/// User authorize page
///
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(child: SizedBox(width: 348, child: AuthForm())));
  }
}
