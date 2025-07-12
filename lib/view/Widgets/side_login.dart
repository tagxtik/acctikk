import 'package:flutter/material.dart';

class SideLogin extends StatelessWidget {
  const SideLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
       mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height:130,
         ),
        Container(
          width: 250,
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/imgs/icon1.png"),
            ),
          ),
        ),
      ],
    );
  }
}
