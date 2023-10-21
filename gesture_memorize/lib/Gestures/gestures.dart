class Gestures {
  String name;
  List<List<dynamic>> gestures = [];

  Gestures({required this.name, gesture}) {
    if (gesture != null) {
      gestures = gesture;
    }
  }

  factory Gestures.fromJson(Map<String, dynamic> json) {
    return Gestures(
      name: json['name'],
      gesture: json['gestures'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'gestures': gestures,
      };
}
