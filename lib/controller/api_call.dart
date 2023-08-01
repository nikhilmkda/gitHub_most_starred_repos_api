import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/github_api.dart';

class GithubProvider extends ChangeNotifier {
  List<GithubRepo> _repos = [];

  List<GithubRepo> get repos => _repos;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchRepos() async {
    _isLoading = true;
    notifyListeners();
    try {
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
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load data');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load data');
    }
  }
}
