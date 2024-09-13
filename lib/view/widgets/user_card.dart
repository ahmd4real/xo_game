import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class UserCard extends StatelessWidget {
  UserCard(
      {super.key, this.avatar, required this.userName, required this.symbol});
  String? avatar;
  final String userName, symbol;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width / 2.5,
        height: MediaQuery.sizeOf(context).height / 4,
        decoration: BoxDecoration(
          color: kDarkPurple,
          border: Border.all(color: Colors.amber),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(kAvatar),
            ),
            Text(
              userName,
              style: const TextStyle(color: Colors.amber),
            ),
            Text(
              symbol,
              style: TextStyle(color: Colors.amber),
            ),
          ],
        ));
  }
}
