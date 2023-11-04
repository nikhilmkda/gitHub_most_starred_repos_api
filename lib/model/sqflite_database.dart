import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:github_repos_starred/model/github_api_modeldart';

/// A helper class responsible for managing the sqflite database operations
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

  /// Inserts the current page into the 'CurrentPage' table.
  ///
  /// The method takes a [currentPage] parameter representing the current page value to be saved.
  Future<void> saveCurrentPage(int currentPage) async {
    final db = await database;
    await db.insert(
      'CurrentPage',
      {'currentPage': currentPage},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves the saved current page value from the 'CurrentPage' table.
  ///
  /// Returns the saved current page value as an integer, or null if not found.
  Future<int?> getCurrentPage() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('CurrentPage');
    if (maps.isNotEmpty) {
      return maps.first['currentPage'] as int;
    }
    return null;
  }

  /// Initializes the sqflite database and creates the necessary table.
  ///
  /// It opens the database and executes a SQL command to create a table
  /// named 'GithubRepositories' with required columns.
  /// Initializes the sqflite database and creates necessary tables.
  ///
  /// This method is updated to include the 'CurrentPage' table.
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
        await db.execute('''
          CREATE TABLE CurrentPage (
            id INTEGER PRIMARY KEY,
            currentPage INTEGER
          )
        ''');
      },
    );
  }

  /// Inserts a single [GithubRepo] object into the sqflite database table named 'GithubRepositories'.
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

  /// Retrieves a list of [GithubRepo] objects from the sqflite database.
  ///
  /// The method queries the 'GithubRepositories' table and maps the retrieved data
  /// to a list of [GithubRepo] objects.
  Future<List<GithubRepo>> getRepositoriesFromDB() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('GithubRepositories');
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

  /// Saves a list of [GithubRepo] objects to the sqflite database.
  ///
  /// The method clears the existing data in the 'GithubRepositories' table
  /// and inserts each [GithubRepo] object from the provided [repos] list.
  ///
  /// It takes a [repos] parameter representing the list of [GithubRepo] objects to be saved.
  Future<void> saveReposToDB(List<GithubRepo> repos) async {
   

    for (var repo in repos) {
      final existingRepo = await getRepositoryByName(repo.name);

      if (existingRepo != null) {
        // Update existing data if it exists
        await updateRepository(repo);
        print('Updating repository: ${repo.name}');
      } else {
        // Insert new data if it doesn't exist
        await insertRepository(repo);
        print('Inserting new repository: ${repo.name}');
      }
    }
  }

  Future<GithubRepo?> getRepositoryByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'GithubRepositories',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return GithubRepo(
        name: map['name'],
        description: map['description'],
        stars: map['stars'],
        owner: GithubOwner(
          username: map['username'],
          avatarUrl: map['avatarUrl'],
        ),
        createdAt: null,
      );
    }

    return null;
  }

  Future<void> updateRepository(GithubRepo repo) async {
    final db = await database;
    await db.update(
      'GithubRepositories',
      {
        'description': repo.description,
        'stars': repo.stars,
        'username': repo.owner.username,
        'avatarUrl': repo.owner.avatarUrl,
      },
      where: 'name = ?',
      whereArgs: [repo.name],
    );
  }
}
