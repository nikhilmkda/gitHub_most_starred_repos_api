import 'package:flutter_test/flutter_test.dart';
import 'package:github_repos_starred/model/github_api_modeldart';

import 'package:github_repos_starred/model/sqflite_database.dart';

void main() {
  
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Repository Database Tests', () {
    late DatabaseHelper databaseHelper;

    setUp(() {
      databaseHelper = DatabaseHelper();
    });

    tearDown(() async {
      final db = await databaseHelper.database;
      await db.close();
    });

    test('Insert and retrieve repository from database', () async {
      final repo = GithubRepo(
        name: 'Test Repo',
        description: 'Test Description',
        stars: 100,
        owner: GithubOwner(
          username: 'testuser',
          avatarUrl: 'avatar_url',
        ),
        createdAt: DateTime.now(),
      );

      await databaseHelper.insertRepository(repo);

      final reposFromDB = await databaseHelper.getRepositoriesFromDB();
      expect(reposFromDB.length, 1);
      expect(reposFromDB[0].name, repo.name);
      expect(reposFromDB[0].description, repo.description);
      expect(reposFromDB[0].stars, repo.stars);
      expect(reposFromDB[0].owner.username, repo.owner.username);
      expect(reposFromDB[0].owner.avatarUrl, repo.owner.avatarUrl);
    });

    test('Save and retrieve multiple repositories from database', () async {
      final repos = [
        GithubRepo(
          name: 'Repo 1',
          description: 'Description 1',
          stars: 100,
          owner: GithubOwner(
            username: 'user1',
            avatarUrl: 'avatar_url_1',
          ),
          createdAt: DateTime.now(),
        ),
        GithubRepo(
          name: 'Repo 2',
          description: 'Description 2',
          stars: 200,
          owner: GithubOwner(
            username: 'user2',
            avatarUrl: 'avatar_url_2',
          ),
          createdAt: DateTime.now(),
        ),
      ];

      await databaseHelper.saveReposToDB(repos);

      final reposFromDB = await databaseHelper.getRepositoriesFromDB();
      expect(reposFromDB.length, 2);
      expect(reposFromDB[0].name, repos[0].name);
      expect(reposFromDB[1].name, repos[1].name);
      // ... more assertions for other properties
    });

    // ... add more test cases for edge cases or specific scenarios ...
  });
}
