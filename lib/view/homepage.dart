import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/api_call.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StarredRepositoriesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Most Starred Repos'),
      ),
      body: Center(
        child: FutureBuilder(
          future: provider.fetchStarredRepositories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final starredRepositories = provider.starredRepositories;
              return ListView.builder(
                itemCount: starredRepositories.length,
                itemBuilder: (context, index) {
                  final repository = starredRepositories[index];
                  return ListTile(
                    title: Text(repository.name),
                    subtitle: Text(repository.description ?? ''),
                    trailing: Text('${repository.stargazersCount} stars'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}