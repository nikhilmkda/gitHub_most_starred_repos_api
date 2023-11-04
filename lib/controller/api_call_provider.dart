import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/github_api_modeldart';
import '../model/sqflite_database.dart';

class GithubProvider extends ChangeNotifier {
  List<GithubRepo> _repos = [];
  List<GithubRepo> get repos => _repos;
  final dbHelper = DatabaseHelper();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool _hasMoreRepos = true;
  bool get hasMoreRepos => _hasMoreRepos;

  int _currentPage = 1;
  int get currentPage => _currentPage;
  final int _perPage = 7;

  void setCurrentPage(int savedpage) {
    _currentPage = savedpage;
    notifyListeners();
  }

  Future<bool> _checkInternetConnection() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  Future<void> fetchNextRepos() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    bool hasInternetConnection = await _checkInternetConnection();

    try {
      if (hasInternetConnection) {
        final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
        final formattedDate = thirtyDaysAgo.toIso8601String();

        final String apiUrl =
            'https://api.github.com/search/repositories?q=created:>$formattedDate&sort=stars&order=desc&page=$_currentPage&per_page=$_perPage';

        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final items = data['items'] as List<dynamic>;

          if (items.length < _perPage) {
            _hasMoreRepos = false;
          }

          final existingRepoNames = _repos.map((repo) => repo.name).toList();
          final newRepos = items
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
              .where((newRepo) => !existingRepoNames.contains(newRepo.name))
              .toList();
          await dbHelper.saveReposToDB(newRepos);
          _repos.addAll(newRepos);
          _currentPage++;
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        final List<GithubRepo> savedRepos =
            await dbHelper.getRepositoriesFromDB();

        _repos.clear();
        _repos.addAll(savedRepos);
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _hasError = true;
      print(error);
      _isLoading = false;
      notifyListeners();
    }
  }
}




// import 'dart:convert';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../model/github_api_modeldart';

// class GithubProvider extends ChangeNotifier {
//   List<GithubRepo> _repos = [];
//   List<GithubRepo> get repos => _repos;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   bool _hasError = false;
//   bool get hasError => _hasError;

//   int _currentPage = 1;
 
//   final int _perPage = 7;
//   bool _hasMoreRepos = true;
//   bool get hasMoreRepos => _hasMoreRepos;

//   resetCurrentPage() {
//    _currentPage = 1;
//   }

//   Future<bool> _checkInternetConnection() async {
//     try {
//       var connectivityResult = await Connectivity().checkConnectivity();
//       return connectivityResult != ConnectivityResult.none;
//     } catch (e) {
//       print('Error checking connectivity: $e');
//       return false;
//     }
//   }

//   Future<void> fetchNextRepos() async {
//     if (_isLoading) return;

//     _isLoading = true;
//     notifyListeners();

//     bool hasInternetConnection = await _checkInternetConnection();

//     try {
//       if (hasInternetConnection) {
//         final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
//         final formattedDate = thirtyDaysAgo.toIso8601String();

//         final String apiUrl =
//             'https://api.github.com/search/repositories?q=created:>$formattedDate&sort=stars&order=desc&page=$_currentPage&per_page=$_perPage';

//         final response = await http.get(Uri.parse(apiUrl));
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//           final items = data['items'] as List<dynamic>;

//           if (items.length < _perPage) {
//             _hasMoreRepos = false;
//           }

//           final existingRepoNames = _repos.map((repo) => repo.name).toList();
//           final newRepos = items
//               .map((item) => GithubRepo(
//                     name: item['name'],
//                     description: item['description'] ?? '',
//                     stars: item['stargazers_count'],
//                     owner: GithubOwner(
//                       username: item['owner']['login'],
//                       avatarUrl: item['owner']['avatar_url'],
//                     ),
//                     createdAt: null,
//                   ))
//               .where((newRepo) => !existingRepoNames.contains(newRepo.name))
//               .toList();

//           _repos.addAll(newRepos);
//           _currentPage++;
//         } else {
//           throw Exception('Failed to load data');
//         }
//       }

//       _isLoading = false;
//       notifyListeners();
//     } catch (error) {
//       _hasError = true;
//       print(error);
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
