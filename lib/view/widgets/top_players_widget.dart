import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class TopPlayersWidget extends StatelessWidget {
  TopPlayersWidget(
      {super.key, required this.userName, required this.points, this.avatar});
  final String userName;
  final int points;
  String? avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 8,
      decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24)),
      child: Row(
        children: [
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundImage: avatar == null || avatar!.isEmpty
                ? const AssetImage(kAvatar)
                : NetworkImage('https://xogame.runasp.net/$avatar'),
            radius: 24,
          ),
          const SizedBox(width: 16),
          Text(
            userName,
            style: const TextStyle(fontFamily: regFont, color: Colors.white),
          ),
          const Spacer(),
          Text(
            points.toString(),
            style: const TextStyle(fontFamily: font, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
