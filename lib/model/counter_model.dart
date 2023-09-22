class CounterModel {
  final int? id;
  final String title;
  final String finish;
  final String start;

  CounterModel(
      {this.id,
      required this.finish,
      required this.start,
      required this.title});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'finish': finish,
      'start': start,
    };
  }

  @override
  String toString() {
    return 'Person{id: $id, title: $title, start: $start,finish: $finish}';
  }
}
