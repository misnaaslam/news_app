import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        children: [
          Text("Register Now"),
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
                        controller: username,
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
                      controller: password,
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.pinkAccent.withOpacity(.3),
                    ),
                    child: TextFormField(
                      controller: password,
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
                    child: const Text("Register"),
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
}

