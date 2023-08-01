import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/github_api.dart';
import '../model/sqflite_database.dart';

/// A provider class responsible for fetching GitHub repositories data
/// and managing the state of the application related to repositories.
class GithubProvider extends ChangeNotifier {
  List<GithubRepo> _repos = [];
  List<GithubRepo> get repos => _repos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fetches GitHub repositories data from the API or SQLite database.
  ///
  /// If data exists in the local SQLite database, it will be used to populate
  /// the [_repos] list. Otherwise, it makes an API call to GitHub to fetch
  /// the most popular repositories created within the last 30 days and saves
  /// the data to SQLite for future use.
  ///
  /// Throws an [Exception] if there is a failure in fetching or saving data.
  Future<void> fetchRepos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final dbHelper = DatabaseHelper();
      final List<GithubRepo> savedRepos =
          await dbHelper.getRepositoriesFromDB();

      if (savedRepos.isNotEmpty) {
        // If data exists in SQLite, use it
        _repos = savedRepos;
        _isLoading = false;
        notifyListeners();
      } else {
        // If no data in SQLite, make API call and save to SQLite
        final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
        final formattedDate = thirtyDaysAgo.toIso8601String();

        final String apiUrl =
            'https://api.github.com/search/repositories?q=created:>$formattedDate&sort=stars&order=desc';

        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final items = data['items'] as List<dynamic>;

          _repos = items
              .map((item) => GithubRepo(
                    name: item['name'],
                    description: item['description'] ?? '',
                    stars: item['stargazers_count'],
                    owner: GithubOwner(
                      username: item['owner']['login'],
                      avatarUrl: item['owner']['avatar_url'],
                    ),
                    createdAt: null,
                  ))
              .toList();

          // Save data to SQLite
          await dbHelper.saveReposToDB(_repos);

          _isLoading = false;
          notifyListeners();
        } else {
          _isLoading = false;
          notifyListeners();
          throw Exception('Failed to load data');
        }
      }
    } catch (error) {
      print(error);
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load data');
    }
  }
}
