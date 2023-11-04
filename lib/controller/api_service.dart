// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../model/github_api_modeldart';

// class GithubApiService {
//   int currentPage = 1;
//   final int perPage = 7;

//   Future<List<GithubRepo>> fetchRepos(currentPage) async {
//     final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
//     final formattedDate = thirtyDaysAgo.toIso8601String();

//     final String apiUrl =
//         'https://api.github.com/search/repositories?q=created:>$formattedDate&sort=stars&order=desc&page=$currentPage&per_page=$perPage';

//     final response = await http.get(Uri.parse(apiUrl));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final items = data['items'] as List<dynamic>;

//       final newRepos = items
//           .map((item) => GithubRepo(
//                 name: item['name'],
//                 description: item['description'] ?? '',
//                 stars: item['stargazers_count'],
//                 owner: GithubOwner(
//                   username: item['owner']['login'],
//                   avatarUrl: item['owner']['avatar_url'],
//                 ),
//                 createdAt: null,
//               ))
//           .toList();

//       return newRepos;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
// }
