import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class TopPlayersWidget extends StatelessWidget {
  const TopPlayersWidget(
      {super.key, required this.userName, required this.points});
  final String userName;
  final int points;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.white12,
      leading: const CircleAvatar(
        backgroundImage: AssetImage(kAvatar),
        radius: 24,
      ),
      title: Text(
        userName,
        style: const TextStyle(fontFamily: regFont, color: Colors.white),
      ),
      trailing: Text(
        points.toString(),
        style: const TextStyle(fontFamily: font, color: Colors.white),
      ),
      onTap: () {},
    );
  }
}
