import 'package:flutter/material.dart';
import 'package:github_search_flutter_client_rxdart_example/src/models/repo.dart';
import 'package:intl/intl.dart';

class RepoDetails extends StatefulWidget {
  const RepoDetails({Key? key, required this.repo}) : super(key: key);

  final Repo repo;

  @override
  _RepoDetailsState createState() => _RepoDetailsState();
}

class _RepoDetailsState extends State<RepoDetails> {
  bool _isStarred = false;
  DateFormat dateFormat = DateFormat('MM-dd-yyyy HH:mm aa');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.repo.name!}\'s details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              setState(() {
                _isStarred = !_isStarred;
              });
            },
            color: _isStarred ? Colors.amber : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.repo.owner!.avatarUrl!),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Selected repo: ${widget.repo.owner!.login!}'),
                const SizedBox(height: 8),
                Text('URL: ${widget.repo.description}'),
                const SizedBox(height: 8),
                Text(
                    'Stars: ${dateFormat.format(DateTime.parse(widget.repo.createdAt!))}'),
                const SizedBox(height: 8),
                Text('Forks: ${widget.repo.forksCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
