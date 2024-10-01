import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/constants.dart';

import 'package:xo_game/models/GameCubit/game_cubit.dart';
import 'package:xo_game/view/screens/game_page.dart';
import 'package:xo_game/view/widgets/levels_button.dart';

class LevelsPage extends StatelessWidget {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: ListView(children: [
          const SizedBox(
            height: 32,
          ),
          const Center(
              child: Text(
            "Select Difficulty",
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.amber, fontSize: 32, fontFamily: font),
          )),
          const SizedBox(
            height: 32,
          ),
          LevelsButton(
            image: 'assets/images/easy.png',
            color1: kRed,
            color2: kOrange,
            text: 'Easy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GamePage(
                    p1: 'Player',
                    p2: 'Bot',
                    gameMode: GameMode.playerVsBotEasy,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          LevelsButton(
            image: 'assets/images/medium.png',
            color1: kGreen,
            color2: kBlue,
            text: 'Medium',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GamePage(
                    p1: 'Player',
                    p2: 'Bot',
                    gameMode: GameMode.playerVsBotMedium,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          LevelsButton(
            image: 'assets/images/hard.png',
            color1: kPurple,
            color2: kPink,
            text: 'Hard',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => GameCubit(gameMode: GameMode.playerVsBotHard),
                    child: const GamePage(
                      p1: 'Player',
                      p2: 'Bot',
                      gameMode: GameMode.playerVsBotHard,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
        ]),
      ),
    );
  }
}
