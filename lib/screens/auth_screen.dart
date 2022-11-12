import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/services/auth_firebase.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailText = TextEditingController();
  final _passwordText = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Instagram',
                style: GoogleFonts.lobsterTwo(
                  textStyle: const TextStyle(fontSize: 38),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailText,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!value!.contains('@')) {
                    return 'enter valid email address';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 12),
                    constraints: BoxConstraints(
                      maxHeight: 45,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    hintText: 'email address'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordText,
                validator: (value) {
                  if (value!.length < 8) {
                    return 'password length must be 7+ characters';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 12),
                  constraints: BoxConstraints(
                    maxHeight: 45,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  hintText: 'your password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                minWidth: double.infinity,
                color: Colors.blueAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                height: 45,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Auth().signInWithEmailAndPassword(
                        email: _emailText.text.trim(),
                        password: _passwordText.text.trim(),
                        context: context);
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                elevation: 0,
                height: 45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                minWidth: double.infinity,
                color: Colors.blue,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Auth().createUserWithEmailAndPassword(
                        email: _emailText.text.trim(),
                        password: _passwordText.text.trim(),
                        context: context);
                  }
                },
                child: const Text(
                  'Signup',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ])),
      ),
    );
  }
}
