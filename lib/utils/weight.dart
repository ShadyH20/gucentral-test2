class Weight {
  final String text;
  final String weight;
  final List<String> best;

  Weight({
    required this.text,
    required this.weight,
    this.best = const ['', ''],
  });

  @override
  String toString() {
    return '$text | $weight% ${best[0].isNotEmpty && best[1].isNotEmpty ? 'Best ${best[0]} from ${best[1]}' : ''}';
  }
}
