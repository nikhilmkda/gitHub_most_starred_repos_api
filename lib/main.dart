import 'package:flutter/material.dart';
import 'package:github_repos_starred/view/homepage.dart';
import 'package:provider/provider.dart';

import 'controller/api_call.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => StarredRepositoriesProvider()),
        // Add more providers if needed
      ],
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
