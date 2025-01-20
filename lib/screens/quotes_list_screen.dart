import 'package:flutter/material.dart';
import '../data/quote.dart';
import '../data/db_helper.dart';

class QuotesListScreen extends StatelessWidget {
  const QuotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite Quotes'),
      ),
      body: FutureBuilder(
        future: getQuotes(),
        builder: (context, snapshot) {
          final List<Dismissible> listTiles = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final quotes = snapshot.data!;
            for (var quote in quotes) {
              listTiles.add(
                Dismissible(
                  key: Key(quote.id.toString()),
                  onDismissed: (_) {
                    DbHelper helper = DbHelper();
                    helper.deleteQuote(quote.id!);
                  },
                  child: ListTile(
                    title: Text(quote.text),
                    subtitle: Text(quote.author),
                  ),
                ),
              );
            }
            return ListView(
              children: listTiles,
            );
          }
        },
      ),
    );
  }

  Future<List<Quote>> getQuotes() async {
    DbHelper helper = DbHelper();
    final quotes = await helper.getQuotes();
    return quotes;
  }
}
