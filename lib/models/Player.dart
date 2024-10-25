class Player {
  String? userName;

  Player({this.userName});
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userName: json['userName'],
    );
  }
}
