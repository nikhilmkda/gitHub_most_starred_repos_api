import 'package:flutter/material.dart';
import 'package:github_repos_starred/view/homepage.dart';
import 'package:provider/provider.dart';
import 'controller/api_call_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GithubProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Github Repos',
        home: GithubReposScreen(),
      ),
    );
  }
}
