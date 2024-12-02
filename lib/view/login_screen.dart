import 'package:flutter/material.dart';
import 'package:news_app/view/sign_up.dart';
import 'home_screen.dart';
import '../controller/database_connection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> handleLogin(String username, String password) async {
    bool success = await DatabaseConnection.login(username, password);

    if (success) {
      // Navigate to HomeScreen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
      );
    } else {
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 40.0),
            Image.asset('assets/image/newslogo.png', height:200,width: 200),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.pinkAccent.withOpacity(.3),
                      ),
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          controller: usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Username is required";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person_3),
                            border: InputBorder.none,
                            labelText: "Username",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.pinkAccent.withOpacity(.3),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          border: InputBorder.none,
                          labelText: "Password",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          handleLogin(
                            usernameController.text,
                            passwordController.text,
                          );
                        }
                      },
                      child: const Text("Login"),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                      child: Text("Sign Up"),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
