import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/screens/game_page.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/custom_form_field.dart';

class EnterTeamsPage extends StatelessWidget {
  EnterTeamsPage({super.key});
  final TextEditingController p1 = TextEditingController();
  final TextEditingController p2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ListView(children: [
          titleWidget(context),
          const SizedBox(height: 32),
          //SizedBox(height: MediaQuery.sizeOf(context).height / 3),
          CustomTextFormField(
            hidden: false,
            controller: p1,
            hintText: 'player 1',
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            hidden: false,
            controller: p2,
            hintText: 'Player 2',
          ),
          const SizedBox(height: 16),
          CustomButton(
            color1: kPink,
            color2: Colors.amber,
            text: 'Start Game',
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (contxet) => GamePage(
                            p1: p1.text,
                            p2: p2.text,
                          )));
            },
          )
        ]),
      ),
    );
  }
}
