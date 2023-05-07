class Weight {
  final String text;
  final String weight;
  final List<String> best;

  Weight({
    required this.text,
    required this.weight,
    this.best = const ['', ''],
  });

  Weight.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        weight = json['weight'],
        best = json['best'].map<String>((item) => item.toString()).toList();

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'weight': weight,
      'best': best,
    };
  }

  @override
  String toString() {
    return '$text | $weight% ${best[0].isNotEmpty && best[1].isNotEmpty ? 'Best ${best[0]} from ${best[1]}' : ''}';
  }
}
