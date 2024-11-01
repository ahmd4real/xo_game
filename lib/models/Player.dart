import 'package:xo_game/constants.dart';

class Player {
  String? userName;
  String? profilePicture;
  int ? points;

  Player({this.userName,this.profilePicture,this.points});
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userName: json['userName']??'Unknown',
      profilePicture: json['profilePicture'],
      points: json['points']??0,
      
    );
  }
}
