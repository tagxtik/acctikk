import 'package:acctik/services/firestore.dart';
import 'package:acctik/view/Widgets/popup_one_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({super.key});
  final FirestoreService fbs = FirestoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();
  String getUser() {
    String email; // <-- Their email

    User? user = FirebaseAuth.instance.currentUser;

// Check if the user is signed in
    if (user != null) {
      email = user.email!; // <-- Their email
    } else {
      email = "Null";
    }
    return email;
  }

  void _addOrgPop(BuildContext context) {
    String email = getUser();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUpOneText(
          title: 'Add Organization',
          message: '',
          orgname: _nameController,
          orgDesc: _orgController,
          onConfirm: (text) {
            // Handle the confirmed text here
            fbs.AddOrg(_nameController.text, _orgController.text, email);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black45,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(0, 53, 53, 53)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              hintText: 'Search',
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
                size: 21,
              ),
            ),
          ),
        ),
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Organization',
            onPressed: () {
              _addOrgPop(context);
            },
          ),
        )
      ],
    );
  }
}
