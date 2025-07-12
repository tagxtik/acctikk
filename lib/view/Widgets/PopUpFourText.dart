 import 'package:flutter/material.dart';

class PopUpFourText extends StatelessWidget {
  final String title;
  final String message;
  final TextEditingController orgname;
  final TextEditingController orgDesc;

  final Function(String) onConfirm;

  const PopUpFourText({
    super.key,
    required this.title,
    required this.message,
    required this.orgname,
    required this.orgDesc,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          TextField(
            controller: orgname,
            decoration: const InputDecoration(
              hintText: 'Enter name here',
            ),
          ),
          TextField(
            controller: orgDesc,
            decoration: const InputDecoration(
              hintText: 'Enter Description here',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm(orgname.text);
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
