import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:psx/models/psxUserInfo.dart';
import 'package:sqflite/sqflite.dart';

class DataBase {
  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    String? password = dotenv.env['DB_PASSWORD'];
    String? DataBaseFile = dotenv.env['DBName'];

    return openDatabase(
      join(path, '$DataBaseFile.db'),
      version: 2,
      onCreate: (Database db, int version) async {
        try {
          // Create the table
          await db.execute('''
              CREATE TABLE IF NOT EXISTS $DataBaseFile(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              accountName TEXT,
              login TEXT,
              password TEXT
            )''');
          print("Table created successfully");
        } catch (e) {
          print("Error creating table: $e");
        } finally {
          //await db.close();
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        try {
          await db.execute('DROP TABLE IF EXISTS $DataBaseFile');
          await db.execute('''
            CREATE TABLE $DataBaseFile(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              accountName TEXT,
              login TEXT,
              password TEXT
            )
          ''');
          print("Table dropped and created successfully");
        } catch (e) {
          print("Error creating table: $e");
        } finally {
          //await db.close();
        }
      },
    );
  }

  Future<void> addUserAccount(PSXUserInfo psxUserInfo) async {
    String path = await getDatabasesPath();
    String? password = dotenv.env['DB_PASSWORD'];
    String? DataBaseFile = dotenv.env['DBName'];
    Database database = await openDatabase(join(path, '$DataBaseFile.db'));

    print('Database insert path: $path');
    try {
      // Insert data into the table
      await database.rawInsert('''
      INSERT OR REPLACE INTO $DataBaseFile (accountName, login, password) VALUES (?, ?, ?)''',
          [psxUserInfo.accountName, psxUserInfo.login, psxUserInfo.password]);
      print("Data inserted successfully");
    } catch (e) {
      print("Error inserting data: $e");
    } finally {
      // Close the database
      await database.close();
    }
  }

  Future<List<Map<String, dynamic>>> retrieveUserAccount() async {
    // Open the database
    String path = await getDatabasesPath();
    String? password = dotenv.env['DB_PASSWORD'];
    String? DataBaseFile = dotenv.env['DBName'];
    Database db = await openDatabase(
      join(path, '$DataBaseFile.db'),
    );

    try {
      // Query the table and retrieve the results
      List<Map<String, dynamic>> results = await db.query('$DataBaseFile');
      return results;
    } catch (e) {
      print("Error retrieving data: $e");
      return [];
    } finally {
      // Close the database
      await db.close();
    }
  }

// delete user
  Future<void> deleteUserAccount(int id) async {
    final db = await initializedDB();
    String? password = dotenv.env['DB_PASSWORD'];
    String? DataBaseFile = dotenv.env['DBName'];
    await db.delete(
      '$DataBaseFile',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteTable() async {
    // Open the database (assuming it's already created)
    String path = await getDatabasesPath();
    String? password = dotenv.env['DB_PASSWORD'];
    String? DataBaseFile = dotenv.env['DBName'];
    Database db = await openDatabase(
      join(path, '$DataBaseFile.db'),
    );

    try {
      // Execute the DROP TABLE command
      await db.execute("DROP TABLE IF EXISTS $DataBaseFile");
      print("Table deleted successfully");
    } catch (e) {
      print("Error deleting table: $e");
    } finally {
      await db.close();
    }
  }

  Future<void> updateRecord(
      int id, String accountName, String login, String password) async {
    String? password = dotenv.env['DB_PASSWORD'];
    String? DataBaseFile = dotenv.env['DBName'];
    // Get a reference to the database
    Database db = await openDatabase('$DataBaseFile.db');

    // Define the updated data as a Map
    Map<String, dynamic> updatedData = {
      'accountName': accountName,
      'login': login,
      'password': password,
    };

    // Update the record in the database
    try {
      await db.update(
        '$DataBaseFile', // Table name
        updatedData, // Updated data
        where: 'id = ?', // Condition to identify the record to update
        whereArgs: [id], // Arguments for the condition
      );
    } catch (e) {
      print("Error deleting table: $e");
    } finally {
      await db.close();
    }
  }

/*   Future<void> updateUserAccount(PSXUserInfo psxUserInfo) async {
    String path = await getDatabasesPath();
    Database database = await openDatabase(join(path, '$DataBaseFile.db'));

    try {
      // Create a map with the updated fields
      Map<String, dynamic> updatedFields = {};

      // Check each field and add it to the updatedFields map if it's not null
      if (psxUserInfo.accountName != null) {
        updatedFields['accountName'] = psxUserInfo.accountName;
      }
      if (psxUserInfo.login != null) {
        updatedFields['login'] = psxUserInfo.login;
      }
      if (psxUserInfo.password != null) {
        updatedFields['password'] = psxUserInfo.password;
      }

      // Update the record with the updatedFields map
      await database.update(
        '$DataBaseFile',
        updatedFields,
        where: 'id = ?',
        whereArgs: [psxUserInfo.id],
      );
      print("Data updated successfully");
    } catch (e) {
      print("Error updating data: $e");
    } finally {
      await database.close();
    }
  } */

  Future<void> updateUserAccount(PSXUserInfo psxUserInfo) async {
    String path = await getDatabasesPath();
    String? password = dotenv.env['DB_PASSWORD'];
    String? DataBaseFile = dotenv.env['DBName'];
    Database database = await openDatabase(join(path, '$DataBaseFile.db'));

    try {
      await database.update(
        '$DataBaseFile',
        psxUserInfo.toMap(),
        where: 'id = ?',
        whereArgs: [psxUserInfo.id],
      );
      print("Data updated successfully");
    } catch (e) {
      print("Error updating data: $e");
    } finally {
      await database.close();
    }
  }

  Future<PSXUserInfo?> getUserAccountById(int id) async {
    String path = await getDatabasesPath();
    String? password = dotenv.env['DB_PASSWORD'];
    String? DataBaseFile = dotenv.env['DBName'];
    Database database = await openDatabase(join(path, '$DataBaseFile.db'));

    try {
      List<Map<String, dynamic>> results = await database.query(
        '$DataBaseFile',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (results.isNotEmpty) {
        return PSXUserInfo.fromMap(results.first);
      } else {
        return null;
      }
    } catch (e) {
      print("Error retrieving data: $e");
      return null;
    } finally {
      await database.close();
    }
  }
}
