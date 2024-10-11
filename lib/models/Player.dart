class Player{
  String? userName;
  int? id;
  int?points;
  Player({this.userName,this.id,this.points});
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userName: json['userName'],
      id: json['id'],
      points: json['points'],
    );
  }

}