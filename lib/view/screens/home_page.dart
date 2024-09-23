import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/screens/Auth/login_page.dart';
import 'package:xo_game/view/screens/enter_teams_page.dart';
import 'package:xo_game/view/screens/levels_page.dart';
import 'package:xo_game/view/screens/online_game.dart';
import 'package:xo_game/view/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<Color> colors = [
    kBlue,
    kGreen,
    kRed,
    kOrange,
    kPink,
    kPurple,
  ];
  List<String> options = ["vs Bot", "Offline Game", "Online Game"];
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        const SizedBox(
          height: 40,
        ),
        titleWidget(context, sz: 12),
        const SizedBox(
          height: 32,
        ),
        for (int i = 0; i < 3; i++)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: BounceInLeft(
              delay: const Duration(seconds: 1),
              duration: const Duration(seconds: 1),
              child: CustomButton(
                  color1: colors[i * 2],
                  color2: colors[i * 2 + 1],
                  text: options[i],
                  onTap: i == 0
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LevelsPage()));
                        }
                      : i == 1
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EnterTeamsPage()));
                            }
                          : () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => isLogin
                                          ? const OnlineGame()
                                          : LoginPage()));
                            }),
            ),
          ),
      ]),
    );
  }
}
