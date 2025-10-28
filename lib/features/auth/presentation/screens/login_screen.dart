import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/login_form.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              // App logo or title
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.local_drink_outlined,
                      size: 80,
                      color: Color(0xFF2E7D32),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Dairy Manager',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Login form
              LoginForm(),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}