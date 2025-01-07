import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // Import Firebase Analytics
import 'forgot_password.dart';
import 'package:nettory_app/auth.dart';
import 'register.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false); // Toggle for password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen gradient background
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 43, 162, 253),
                  Color.fromARGB(255, 177, 77, 253),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Title Text inside the gradient background
          const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Hello\nWelcome Back!',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // White form container, positioned on top of the gradient
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height * 0.75, // 75% of the screen height
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Email TextField
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Gmail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Password TextField
                    ValueListenableBuilder(
                      valueListenable: isPasswordVisible,
                      builder: (context, value, child) {
                        return TextField(
                          controller: passwordController,
                          obscureText: !value,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                value ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                isPasswordVisible.value = !value;
                              },
                            ),
                            label: const Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Forgot Password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          FirebaseAnalytics.instance.logEvent(
                            name: 'forgot_password_tapped',
                            parameters: {
                              'timestamp': DateTime.now().toString(),
                            },
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff281537),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Login Button
                    Container(
                      height: 55,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 43, 162, 253),
                            Color.fromARGB(255, 177, 77, 253),
                          ],
                        ),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          // Log login attempt event
                          FirebaseAnalytics.instance.logEvent(
                            name: 'login_attempt',
                            parameters: {
                              'email': email,
                              'timestamp': DateTime.now().toString(),
                            },
                          );

                          try {
                            await Auth().signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            // Log successful login
                            FirebaseAnalytics.instance.logEvent(
                              name: 'login_success',
                              parameters: {
                                'email': email,
                                'timestamp': DateTime.now().toString(),
                              },
                            );

                            Navigator.pushReplacementNamed(context, '/dashboard');
                          } catch (e) {
                            // Log login failure
                            FirebaseAnalytics.instance.logEvent(
                              name: 'login_failed',
                              parameters: {
                                'email': email,
                                'error': e.toString(),
                                'timestamp': DateTime.now().toString(),
                              },
                            );
                            debugPrint("Error logging in: $e");
                          }
                        },
                        child: const Center(
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign Up Link
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          FirebaseAnalytics.instance.logEvent(
                            name: 'sign_up_tapped',
                            parameters: {
                              'timestamp': DateTime.now().toString(),
                            },
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: const Text(
                          "Don't Have An Account? Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff281537),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
