import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  _AddStaffPageState createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _staffCollection = FirebaseFirestore.instance.collection('staff');


  Future<void> _addStaff() async {
  if (_formKey.currentState!.validate()) {
    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get the UID of the new user
      String uid = userCredential.user!.uid;

      // Add the user details to Firestore using the UID as the document ID
      await _staffCollection.doc(uid).set({
        'id': _idController.text,
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'dateAdded': Timestamp.fromDate(DateTime.now()), // Automatically sets to current date and time
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff added successfully')),
      );

      // Clear the form fields
      _formKey.currentState!.reset();

      // Optional: Log out the created user if you don’t want them logged in right away
      await _auth.signOut();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add staff: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Staff'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Staff ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a staff ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the password';
                  }
                  return null;
                },
                obscureText: true, // To hide the password input
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _addStaff,
                child: const Text('Add Staff'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}