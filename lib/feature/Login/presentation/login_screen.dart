import 'dart:developer';

import 'package:comments_app/Authentication/authentication.dart';
import 'package:comments_app/Services/AuthenticationServices.dart';
import 'package:comments_app/feature/Login/presentation/home_screen.dart';
import 'package:comments_app/feature/Login/presentation/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

GlobalKey<FormState> _key = GlobalKey<FormState>();
final AuthenticationServices _auth = AuthenticationServices();

TextEditingController _nameController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  bool _emailHasError = false;
  bool _passwordHasError = false;
  final _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 72, bottom: 16),
        child: Form(
          key: _key,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Comments',
                  style: TextStyle(
                      color: Color(0xff0C54BE),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email address';
                    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 12, color: Colors.black),
                    hintText: 'Email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  maxLength: 6,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length != 6) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 12, color: Colors.black),
                    hintText: 'Password',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final form = _key.currentState;
                  if ( _key.currentState!.validate()) {
                    final message = await AuthService().login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    log('message $message');
                    if (message == 'Success') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const HomeScreen(),
                        ),
                      );
                      _emailController.clear();
                      _passwordController.clear();
                    } else if (message != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message ?? 'Something went wrong!'),
                        ),
                      );
                    }
                  } else {
                    log('not valid');
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0C54BE)),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New here?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => RegistrationScreen()),
                        );
                      },
                      child: const Text('Signup')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
