import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindful_app/data/db_helper.dart';
import 'dart:convert';

import 'package:mindful_app/data/quote.dart';
import 'package:mindful_app/screens/quotes_list_screen.dart';
import 'package:mindful_app/screens/settings_screen.dart';

class QuoteSscreen extends StatefulWidget {
  const QuoteSscreen({super.key});

  @override
  State<QuoteSscreen> createState() => _QuoteSscreenState();
}

class _QuoteSscreenState extends State<QuoteSscreen> {
  static const address = 'https://dummyjson.com/quotes/random';
  Quote quote = Quote(text: "", author: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindful Quote'),
        actions: [
          IconButton(
            onPressed: _goToSettings,
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: _goToList,
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _fetchQuote().then(
                  (value) {
                    quote = value;
                  },
                );
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: _fetchQuote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            quote = snapshot.data;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      quote.text,
                      style: const TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      quote.author,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          DbHelper helper = DbHelper();
          helper.insertQuote(quote).then((id) {
            final message = (id == 0)
                ? 'An error occured. The quote could not be saved.'
                : 'The quote was saved successfully.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 2),
              ),
            );
          });
        },
      ),
    );
  }

  Future _fetchQuote() async {
    final Uri url = Uri.parse(address);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final quoteJson = json.decode(response.body);
      Quote quote = Quote.fromJson(quoteJson);
      return quote;
    } else {
      return Quote(text: "Error retrieving quote.", author: "");
    }
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _goToList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuotesListScreen(),
      ),
    );
  }
}
