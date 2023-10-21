class Gestures {
  String userName;
  List<Map<String, dynamic>> gestures = [];
  // [
  //   {
  //     "gesturesName": "test",
  //     "actions": [
  //       {
  //         "name": "function1",
  //         "time": 3,
  //       },
  //       {
  //         "name": "function2",
  //         "time": 3,
  //       }
  //     ],
  //   },
  // ]

  Gestures({required this.userName, gesture}) {
    if (gesture != null) {
      gestures = gesture;
    }
  }

  factory Gestures.fromJson(Map<String, dynamic> json) {
    return Gestures(
      userName: json['userName'],
      gesture: json['gestures'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'gestures': gestures,
      };
}
