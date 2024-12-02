import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../model/user_model.dart';

class DatabaseConnection {
  static Database? _db;

  // Singleton database getter
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initialiseDatabase();
    return _db!;
  }

  // Initialize the database
  static Future<Database> initialiseDatabase() async {
    Directory applicationDirectory = await getApplicationDocumentsDirectory();
    String databasePath = "${applicationDirectory.path}/news.db";

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE User (id INTEGER PRIMARY KEY, username TEXT, '
                'email TEXT, password TEXT)');
      },
    );
  }

  // Sign Up Method
  static Future<bool> signUp(String username, String email, String password) async {
    final db = await database;


    List<Map<String, dynamic>> existingUsers = await db.query(
      'User',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (existingUsers.isNotEmpty) {
      return false;
    }

    // Insert new user
    await db.insert(
      'User',
      {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    return true;
  }

  // Login Method
  static Future<bool> login(String username, String password) async {
    final db = await database;


    List<Map<String, dynamic>> users = await db.query(
      'User',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return users.isNotEmpty;
  }

  static Future<bool> updateUserDetails({
    required String newUsername,
    required String newEmail,
    required String newPassword,
    required String username,
  }) async {
    final db = await database;

    try {
      int result = await db.update(
        'User',
        {
          'username': newUsername,
          'email': newEmail,
          if (newPassword.isNotEmpty) 'password': newPassword,
        },
        where: 'username = ?',
        whereArgs: [username],
      );

      return result > 0;
    } catch (e) {
      print('Update error: $e');
      return false;
    }
  }



//View User Details
  static Future<Map<String, dynamic>?> getUserDetails(String username) async {
    final db = await database;


    List<Map<String, dynamic>> users = await db.query(
      'User',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (users.isNotEmpty) {
      return users.first;
    } else {
      return null;
    }
  }

  //Delete Profile
  static Future<bool> deleteUser(String username) async {
    final db = await database;
    try {
      int result = await db.delete(
        'User',
        where: 'username = ?',
        whereArgs: [username],
      );

      return result > 0;
    } catch (e) {

      return false;
    }
  }
}


