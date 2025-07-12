 import 'package:flutter/material.dart';

class SubCard extends StatelessWidget {
  final TextEditingController accname;
  final TextEditingController accdesc;
 
  //  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Function(String) onConfirm;
  const SubCard({
    super.key,
    required this.accname,
    required this.accdesc,
 
    this.color,
    this.padding,
    required this.onConfirm,
  });
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
          child: Column(
            children: [
              TextField(
                controller: accname,
                decoration: const InputDecoration(
                  hintText: 'Enter name here',
                ),
              ),
              TextField(
                controller: accdesc,
                decoration: const InputDecoration(
                  hintText: 'Enter Description here',
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                        onConfirm(accname.text);
                        Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
