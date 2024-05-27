import 'package:path/path.dart';
import 'package:psx/models/psxUserInfo.dart';
import 'package:sqflite/sqflite.dart';

class DataBase {
  static const DataBaseFile = 'voute';

  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    print('Database path: $path');
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
    await db.delete(
      '$DataBaseFile',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteTable() async {
    // Open the database (assuming it's already created)
    String path = await getDatabasesPath();
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
}
