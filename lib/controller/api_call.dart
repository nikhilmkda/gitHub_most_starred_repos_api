import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/github_api.dart';

class StarredRepositoriesProvider extends ChangeNotifier {
  List<Item> _starredRepositories = [];

  List<Item> get starredRepositories => _starredRepositories;

  Future<void> fetchStarredRepositories() async {
    final response = await http.get(
      Uri.parse(
          'https://api.github.com/search/repositories?q=created:>2022-04-29&sort=stars&order=desc'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final welcome = Welcome.fromJson(data);
      _starredRepositories = welcome.items;
      notifyListeners();
    } else {
      // Handle error here
    }
  }
}
