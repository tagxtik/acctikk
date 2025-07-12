 
 import 'package:firebase_auth/firebase_auth.dart';
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
double? validateDouble(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  try {
    return double.parse(value);
  } catch (e) {
    return null;
  }
  
}

 double roundThree(double value) {
  return double.parse((value).toStringAsFixed(3));
}