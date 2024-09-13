import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/view/widgets/board_sq.dart';
import 'package:xo_game/view/widgets/user_card.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UserCard(avatar: kAvatar, userName: 'Ahmed', symbol: 'X'),
              UserCard(avatar: kAvatar, userName: 'Jemmy', symbol: 'O'),
            ],
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoardSq(
                left: false,
                top: false,
              ),
              BoardSq(
                top: false,
              ),
              BoardSq(
                top: false,
                right: false,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 3; i++) BoardSq(
                left: i == 0 ? false : true,
                right: i==2?false:true,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoardSq(
                left: false,
                bottom: false,
              ),
              BoardSq(
                bottom: false,
              ),
              BoardSq(
                bottom: false,
                right: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
