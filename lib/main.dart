import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_search_flutter_client_rxdart_example/src/features/github_search_delegate.dart';
import 'package:github_search_flutter_client_rxdart_example/src/models/repo.dart';
import 'package:github_search_flutter_client_rxdart_example/src/repo_details.dart';
import 'package:github_search_flutter_client_rxdart_example/src/services/github_search_service.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Search Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  void _showSearch(BuildContext context, WidgetRef ref) async {
    final service = ref.read(searchServiceProvider);
    final searchDelegate = GitHubSearchDelegate(service);
    final repo = await showSearch<Repo?>(
      context: context,
      delegate: searchDelegate,
    );
    // TODO: Service is now reused for the next search so it shouldn't be disposed
    //service.dispose();
    if (repo != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RepoDetails(repo: repo),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Search'),
      ),
      body: Center(
        child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
          child: Text(
            'Search',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white),
          ),
          onPressed: () => _showSearch(context, ref),
        ),
      ),
    );
  }
}
