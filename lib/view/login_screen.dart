import 'package:flutter/material.dart';
import 'package:news_app/view/sign_up.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final username = TextEditingController();
  final password = TextEditingController();


  final formkey = GlobalKey <FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("lib/assets/image/newslogo.png", width: 200,),

          Center(
            child: Column(
              children: [
                const SizedBox( height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.pinkAccent.withOpacity(.3),
                    ),
                    child: Form(
                      key: formkey,
                      child: TextFormField(
                        validator: (value) {if(value!.isEmpty){
                          return "username is required";
                        }
                        return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person_3),
                          border: InputBorder.none,
                          label: Text("Username"),
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
                      validator: (value) {if(value!.isEmpty){
                        return "password is required";
                      }
                      return null;
                      },
                      obscureText: true, 
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        border: InputBorder.none,
                        label: Text("Password"),
                      ),
                    ),
                  ),
                ),
                const SizedBox( height: 20),
                Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if(formkey.currentState!.validate()){
                        //login here
                      }
                      },
                      child: const Text("Login"),
                       ),
                     ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                        child: Text('Sign up'))
                  ],
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}
