class Weight {
  final String text;
  final String weight;
  final List<String> best;

  Weight({
    required this.text,
    required this.weight,
    this.best = const ['', ''],
  });
}
