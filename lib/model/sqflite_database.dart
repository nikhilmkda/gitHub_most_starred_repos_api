import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'github_api.dart';

/// A helper class responsible for managing the SQLite database operations
/// related to storing and retrieving GitHub repositories data.
class DatabaseHelper {
  static Database? _database;

  /// Retrieves the database instance asynchronously.
  ///
  /// If the database instance already exists, it returns the cached database;
  /// otherwise, it initializes and opens a new database instance using [initDatabase].
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  /// Initializes the SQLite database and creates the necessary table.
  ///
  /// It opens the database and executes a SQL command to create a table
  /// named 'GithubRepositories' with required columns.
  Future<Database> initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'github.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE GithubRepositories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            stars INTEGER,
            username TEXT,
            avatarUrl TEXT
          )
        ''');
      },
    );
  }

  /// Inserts a single [GithubRepo] object into the SQLite database table named 'GithubRepositories'.
  ///
  /// The method takes a [repo] parameter representing the [GithubRepo] object to be inserted.
  Future<void> insertRepository(GithubRepo repo) async {
    final db = await database;
    await db.insert(
      'GithubRepositories',
      {
        'name': repo.name,
        'description': repo.description,
        'stars': repo.stars,
        'username': repo.owner.username,
        'avatarUrl': repo.owner.avatarUrl,
      },
    );
  }

  /// Retrieves a list of [GithubRepo] objects from the SQLite database.
  ///
  /// The method queries the 'GithubRepositories' table and maps the retrieved data
  /// to a list of [GithubRepo] objects.
  Future<List<GithubRepo>> getRepositoriesFromDB() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('GithubRepositories');
    return List.generate(maps.length, (i) {
      return GithubRepo(
        name: maps[i]['name'],
        description: maps[i]['description'],
        stars: maps[i]['stars'],
        owner: GithubOwner(
          username: maps[i]['username'],
          avatarUrl: maps[i]['avatarUrl'],
        ),
        createdAt: null,
      );
    });
  }

  /// Saves a list of [GithubRepo] objects to the SQLite database.
  ///
  /// The method clears the existing data in the 'GithubRepositories' table
  /// and inserts each [GithubRepo] object from the provided [repos] list.
  ///
  /// It takes a [repos] parameter representing the list of [GithubRepo] objects to be saved.
  Future<void> saveReposToDB(List<GithubRepo> repos) async {
    final db = await database;
    // To have the latest data, clear the existing data before inserting new data
    await db.delete('GithubRepositories');
    for (var repo in repos) {
      await insertRepository(repo);
    }
  }
}
