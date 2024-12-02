import 'package:flutter/material.dart';
import '../controller/database_connection.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentUsername;
  final String currentEmail;

  const EditProfileScreen({
    Key? key,
    required this.currentUsername,
    required this.currentEmail,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.currentUsername;
    emailController.text = widget.currentEmail;
  }

  Future<void> saveChanges() async {
    final newUsername = usernameController.text.trim();
    final newEmail = emailController.text.trim();
    final newPassword = passwordController.text.trim();

    if (newUsername.isEmpty || newEmail.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required.')),
      );
      return;
    }

    final result = await DatabaseConnection.updateUserDetails(
      username: widget.currentUsername,
      newUsername: newUsername,
      newEmail: newEmail,
      newPassword: newPassword,
    );

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),

          ],
        ),
      ),
    );
  }
}
