import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/view/widgets/top_players_widget.dart';

class TopRankedPage extends StatelessWidget {
  const TopRankedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'Top Players',
                  style: TextStyle(
                      color: Colors.amber, fontSize: 24, fontFamily: font),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Flexible(
              child: ListView(
                children: [
                  for (int i = 0; i < 10; i++)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: TopPlayersWidget(
                          userName: 'ahmd4real', points: 10000000),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
