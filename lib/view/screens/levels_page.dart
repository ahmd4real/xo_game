import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/view/widgets/levels_button.dart';

class LevelsPage extends StatelessWidget {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: ListView(children: [
          const SizedBox(
            height: 80,
          ),
          const Center(
              child: Text(
            "Select Difficulty",
            style: TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          )),
          const SizedBox(
            height: 32,
          ),
          LevelsButton(
            color1: kRed,
            color2: kOrange,
            text: 'Easy',
          ),
          const SizedBox(
            height: 64,
          ),
          LevelsButton(
            color1: kGreen,
            color2: kBlue,
            text: 'Medium',
          ),
          const SizedBox(
            height: 64,
          ),
          LevelsButton(
            color1: kPurple,
            color2: kPink,
            text: 'Hard',
          ),
          const SizedBox(
            height: 64,
          ),
        ]),
      ),
    );
  }
}
