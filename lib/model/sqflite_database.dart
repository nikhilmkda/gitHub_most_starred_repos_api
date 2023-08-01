import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'github_api.dart';

class DatabaseHelper {
 
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }
// creating a database table to store data
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
//inserting a single GithubRepo object into the SQLite database table named GithubRepositories
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
   Future<void> saveReposToDB(List<GithubRepo> repos) async {
    final db = await database;
    //to have  latest data Clear the existing data before inserting new data
    await db.delete('GithubRepositories');
    for (var repo in repos) {
      await insertRepository(repo);
    }
  }
}
