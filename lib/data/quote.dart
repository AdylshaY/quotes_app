class Quote {
  final String text;
  final String author;
  int? id;
  Quote({required this.text, required this.author});

  Quote.fromJson(Map<String, dynamic> map)
      : text = map['quote'] ?? '',
        author = map['author'] ?? '';

  Map<String, dynamic> toMap() {
    return {
      'quote': text,
      'author': author,
    };
  }
}
