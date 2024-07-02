import 'package:comments_app/Authentication/authentication.dart';
import 'package:comments_app/feature/Login/presentation/home_screen.dart';
import 'package:comments_app/feature/Login/presentation/login_screen.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  controller: _nameController,
                  validator: (value) {
                    String pattern = '([a-zA-Z])';
                    RegExp regExp = RegExp(pattern);
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    } else if (!regExp.hasMatch(_nameController.text)) {
                      return 'Invalid name';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 12, color: Colors.black),
                    hintText: 'Name',
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length != 6) {
                      return 'Please enter 6 digit password';
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
                  if (_key.currentState!.validate()) {
                    try {
                      final message = await AuthService().registration(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      if (message == 'Success') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => HomeScreen(),
                          ),
                        );
                        _emailController.clear();
                        _passwordController.clear();
                        _nameController.clear();
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Something went wrong!'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0C54BE)),
                child: const Text(
                  'Signup',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const LoginScreen()),
                        );
                      },
                      child: const Text('Login')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

//   void createUser() async {
//     dynamic result = await _auth.createNewUser(
//         _nameController.text, _emailContoller.text, _passwordController.text);
//     if (result == null) {
//       print('Email is not valid');
//     } else {
//       print(result.toString());
//       _nameController.clear();
//       _passwordController.clear();
//       _emailContoller.clear();
//       Navigator.pop(context);
//     }
//   }
}

class AuthenticationService {}
