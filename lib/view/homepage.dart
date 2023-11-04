import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:github_repos_starred/view/user_tile.dart';
import 'package:provider/provider.dart';
import '../controller/api_call_provider.dart';
import '../model/sqflite_database.dart';

class GithubReposScreen extends StatefulWidget {
  const GithubReposScreen({Key? key}) : super(key: key);

  @override
  _GithubReposScreenState createState() => _GithubReposScreenState();
}

class _GithubReposScreenState extends State<GithubReposScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final githubProvider =
          Provider.of<GithubProvider>(context, listen: false);

      githubProvider.fetchNextRepos();

      // Fetch repositories on initial load
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final githubProvider = Provider.of<GithubProvider>(context, listen: false);

    if (currentScroll >= maxScroll &&
        githubProvider.hasMoreRepos &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      githubProvider.fetchNextRepos().then((_) {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    // Dispose of any other resources if needed

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final githubProvider = Provider.of<GithubProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Most Starred GitHub Repos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          if (githubProvider.repos.isEmpty) // Check if the repos list is empty
            Center(
              child: Column(
                children: [
                  SizedBox(
                      height: 600,
                      width: 600,
                      child: Image.asset('assets/nodata.png')),
                  Center(
                    child: Text(
                      'No repositories available\n \n- Check your Internet Connection.\n- Restart the App',
                      textAlign:
                          TextAlign.start, // Set text alignment to center
                      style: TextStyle(
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              controller: _scrollController,
              itemCount: githubProvider.repos.length + 1,
              itemBuilder: (context, index) {
                if (index < githubProvider.repos.length) {
                  final repo = githubProvider.repos[index];

                  return UserDetailsTile(
                    repoName: repo.name,
                    repodescription: repo.description,
                    stars: repo.stars,
                    userName: repo.owner.username,
                    userAvatar: repo.owner.avatarUrl,
                  );
                }
                return null;
              },
            ),
          if (githubProvider.isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
