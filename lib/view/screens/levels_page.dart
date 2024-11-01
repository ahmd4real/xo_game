import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/GameCubit/game_cubit.dart';
import 'package:xo_game/models/ProfileImageCubit/profile_image_cubit.dart';
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
          BounceInLeft(
            child: LevelsButton(
              image: 'assets/images/easy.png',
              color1: kRed,
              color2: kOrange,
              text: 'Easy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          GameCubit(gameMode: GameMode.playerVsBotEasy),
                      child:  GamePage(
                        botMode: true,
                        avatar2: 'assets/images/easy.png',
                        p1: 'You',
                        avatar1: profilePic??kAvatar,
                        p2: 'Bot',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          BounceInLeft(
            delay: const Duration(milliseconds: 250),
            child: LevelsButton(
              image: 'assets/images/medium.png',
              color1: kGreen,
              color2: kBlue,
              
              text: 'Medium',
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          GameCubit(gameMode: GameMode.playerVsBotMedium),
                      child:  GamePage(
                        botMode: true,
                        avatar2: 'assets/images/medium.png',
                        p1: 'You',
                        avatar1: profilePic??kAvatar,
                        p2: 'Bot',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          BounceInLeft(
            delay: const Duration(milliseconds: 500),
            child: LevelsButton(
              image: 'assets/images/hard.png',
              color1: kPurple,
              color2: kPink,
              text: 'Hard',
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          GameCubit(gameMode: GameMode.playerVsBotHard),
                      child:  GamePage(
                        botMode: true,
                        avatar2: 'assets/images/hard.png',
                        p1: 'You',
                        avatar1: profilePic??kAvatar,
                        p2: 'Bot',

                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ]),
      ),
    );
  }
}
