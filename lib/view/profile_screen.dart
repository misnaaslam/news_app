import 'package:flutter/material.dart';
import '../controller/database_connection.dart';
import 'edit_profile_screen.dart'; // Import EditProfileScreen

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> userDetails;

  @override
  void initState() {
    super.initState();

    userDetails = DatabaseConnection.getUserDetails(widget.username);
  }

  Future<void> deleteProfile() async {
    final result = await DatabaseConnection.deleteUser(widget.username);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile deleted successfully!')),
      );
      Navigator.popUntil(context, (route) => route.isFirst); // Navigate back to the root
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete profile.')),
      );
    }
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text(
            'Are you sure you want to delete your profile? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              deleteProfile();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
          }final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/image/newslogo.png',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10), // Padding inside the border
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 2, // Border width
                          ),
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Username: ${user['username']}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Email: ${user['email']}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

                // Edit Profile button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to EditProfileScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            currentUsername: user['username'],
                            currentEmail: user['email'],
                          ),
                        ),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(height: 10),
                // Delete Profile button
                Center(
                  child: ElevatedButton(
                    onPressed: confirmDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red button for delete
                    ),
                    child: const Text('Delete Profile'),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
