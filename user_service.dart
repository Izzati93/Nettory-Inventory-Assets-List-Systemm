import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save the user role
  Future<void> saveUserRole(String userId, String role) async {
    await _firestore.collection('users').doc(userId).set({
      'role': role,
    });
  }

  // Method to get the user role
  Future<String?> getUserRole() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
        
        if (snapshot.exists) {
          return snapshot['role']; // Access the 'role' field
        } else {
          print('User document does not exist');
          return null; // Return null if the document does not exist
        }
      } catch (e) {
        print('Error getting user role: $e');
      }
    }
    return null; // Return null if the user is not logged in
  }
}
