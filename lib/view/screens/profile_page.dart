import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/view/widgets/top_players_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 32,
              ),
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage(kAvatar),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                userName,
                style: const TextStyle(
                    color: Colors.amber, fontSize: 32, fontFamily: regFont),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Rank  ',
                style: TextStyle(
                    color: Colors.white, fontSize: 12, fontFamily: font),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Points ',
                style: TextStyle(
                    color: Colors.white, fontSize: 12, fontFamily: font),
              ),
              const SizedBox(
                height: 64,
              ),
              const Row(
                children: [
                  Text(
                    'Top Players',
                    style: TextStyle(
                        color: Colors.white, fontSize: 24, fontFamily: font),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView(children: [
                  for (int i = 0; i < 10; i++)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: TopPlayersWidget(
                          userName: 'ahmd4real', points: 10000000),
                    )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
