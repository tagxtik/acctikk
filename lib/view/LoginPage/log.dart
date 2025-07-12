import 'package:flutter/material.dart';
import 'package:acctik/view/Widgets/side_login.dart';
import 'package:acctik/view/Widgets/data_login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: SizedBox(
                  child: SideLogin(),
                ),
              ),
              SizedBox(
                width: 60,
              ),
              const Expanded(
                flex: 6,
                child: SizedBox(
                  child: DataLogin(),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
