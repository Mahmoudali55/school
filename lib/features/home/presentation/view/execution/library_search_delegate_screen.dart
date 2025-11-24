import 'package:flutter/material.dart';

class LibrarySearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<Map<String, dynamic>> searchResults = [
      {'title': 'كتاب الرياضيات المتقدم', 'type': 'كتاب', 'subject': 'الرياضيات'},
      {'title': 'ملخص قوانين الفيزياء', 'type': 'ملخص', 'subject': 'الفيزياء'},
    ].where((item) => item['title']!.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final item = searchResults[index];
        return ListTile(
          title: Text(item['title']),
          subtitle: Text('${item['type']} - ${item['subject']}'),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }
}
