import 'package:flutter/material.dart';
import 'package:github_repos_starred/view/user_tile.dart';
import 'package:provider/provider.dart';
import '../controller/api_call_provider.dart';

/// A screen that displays a list of the most starred GitHub repositories.
class GithubReposScreen extends StatefulWidget {
  const GithubReposScreen({super.key});

  @override
  _GithubReposScreenState createState() => _GithubReposScreenState();
}

class _GithubReposScreenState extends State<GithubReposScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GithubProvider>(context, listen: false).fetchRepos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repos = Provider.of<GithubProvider>(context).repos;
    final isLoading = Provider.of<GithubProvider>(context).isLoading;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Most Starred GitHub Repos',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        backgroundColor: Colors.black87,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your data is getting ready...",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: repos.length,
              itemBuilder: (context, index) {
                final repo = repos[index];

                return UserTile(
                    repoName: repo.name,
                    repodescription: repo.description,
                    stars: repo.stars,
                    userName: repo.owner.username,
                    userAvatar: repo.owner.avatarUrl);
              },
            ),
    );
  }
}
