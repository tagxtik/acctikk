import 'package:flutter/material.dart';

class JornalCard extends StatelessWidget {
 
   final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  const JornalCard({super.key, required this.color, this.padding, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          color: color ?? const Color.fromARGB(255, 48, 50, 53),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(3.0),
          child: child,
        ));
  }
}