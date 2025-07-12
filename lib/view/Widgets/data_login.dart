import 'package:acctik/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class DataLogin extends StatefulWidget {
  const DataLogin({super.key});

  @override
  State<DataLogin> createState() => _DataLoginState();
}

final _auth = AuthService();

final _email = TextEditingController();
final _password = TextEditingController();

@override
void dispose() {
  _email.dispose();
  _password.dispose();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _rememberMe = false;
String valid = "";

class _DataLoginState extends State<DataLogin> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 200),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                      .hasMatch(value)) {
                    return 'Invalid email format';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: _password,
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  const Text('Remember Me'),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Set persistence based on "Remember Me" checkbox
                        await FirebaseAuth.instance.setPersistence(
                          _rememberMe
                              ? Persistence.LOCAL  // Persistent session across browser restarts
                              : Persistence.SESSION,  // Session-only persistence
                        );

                        final user = await _auth.loginUserWithEmailAndPassword(
                            _email.text, _password.text);

                        if (user != null) {
                          print("User Logged In");
                          context.goNamed("Home");
                        } else {
                          setState(() {
                            valid = "Password or user name is wrong";
                          });
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     context.goNamed("Home");
                  //   },
                  //   child: const Text('Guest'),
                  // ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                valid,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
