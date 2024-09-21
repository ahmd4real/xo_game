import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class OnlineGame extends StatelessWidget {
  const OnlineGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          iconTheme: IconThemeData(color: kOrange),
        ),
        body: Center(
          child: Spin(
            infinite: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/tic.png',
                  width: 200,
                ),
                Image.asset(
                  'assets/images/tac.png',
                  width: 200,
                ),
                Image.asset(
                  'assets/images/toe.png',
                  width: 200,
                ),
              ],
            ),
          ),
        ));
  }
}
