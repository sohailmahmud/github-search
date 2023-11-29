import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_search_flutter_client_rxdart_example/src/models/github_search_result.dart';
import 'package:github_search_flutter_client_rxdart_example/src/models/repo.dart';
import 'package:github_search_flutter_client_rxdart_example/src/services/github_search_service.dart';

class GitHubSearchDelegate extends SearchDelegate<Repo?> {
  GitHubSearchDelegate(this.searchService);
  final GitHubSearchService searchService;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    // search-as-you-type if enabled
    searchService.searchUser(query);
    return buildMatchingSuggestions(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    // always search if submitted
    searchService.searchUser(query);
    return buildMatchingSuggestions(context);
  }

  Widget buildMatchingSuggestions(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final resultsValue = ref.watch(searchResultsProvider);
        return resultsValue.when(
          data: (result) {
            return result.when(
              (repos) => ListView.builder(
                itemCount: repos.length,
                itemBuilder: (context, index) {
                  return GitHubUserSearchResultTile(
                    repo: repos[index],
                    onSelected: (repo) => close(context, repo),
                  );
                },
              ),
              error: (error) => SearchPlaceholder(title: error.message),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text(e.toString())),
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : <Widget>[
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          ];
  }
}

class GitHubUserSearchResultTile extends StatelessWidget {
  const GitHubUserSearchResultTile(
      {Key? key, required this.repo, required this.onSelected})
      : super(key: key);
  final Repo repo;
  final ValueChanged<Repo> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: InkWell(
          onTap: () {
            onSelected(repo);
          },
          highlightColor: Colors.lightBlueAccent,
          splashColor: Colors.red,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    repo.name ?? '',
                    style: theme.textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(repo.description ?? '',
                        style: theme.textTheme.bodySmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(repo.owner!.login!,
                                textAlign: TextAlign.start,
                                style: theme.textTheme.bodySmall)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.star,
                                color: Colors.deepOrange,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(repo.stargazersCount!.toString(),
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodySmall),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Text(repo.language ?? '',
                                textAlign: TextAlign.end,
                                style: theme.textTheme.bodySmall)),
                      ],
                    ),
                  ),
                ]),
          )),
    );
  }
}

class SearchPlaceholder extends StatelessWidget {
  const SearchPlaceholder({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Text(
        title,
        style: theme.textTheme.headline5,
        textAlign: TextAlign.center,
      ),
    );
  }
}
