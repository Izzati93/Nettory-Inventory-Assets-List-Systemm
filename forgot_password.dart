import 'package:flutter/material.dart';
import 'package:nettory_app/auth.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: const Color.fromARGB(255, 43, 162, 253),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Enter your email address',
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Send password reset link button
            TextButton(
              onPressed: () async {
                await _sendPasswordResetEmail(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 43, 162, 253)),
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 80, vertical: 15)),
              ),
              child: const Text(
                'Send Reset Link',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to send the password reset email
  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    try {
      // Call the resetPassword method in your Auth class to send a reset email
      await Auth().resetPassword(emailController.text);
      // Show a success message after the reset link is sent
      _showDialog(context, 'Password reset link has been sent to your email.');
    } catch (e) {
      // Handle errors like invalid email or other issues
      _showDialog(context, 'Failed to send reset link. Please try again.');
    }
  }

  // Helper function to show a dialog with the message
  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Password Reset'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
