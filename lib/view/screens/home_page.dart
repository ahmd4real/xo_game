import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/ProfileImageCubit/profile_image_cubit.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/screens/Auth/login_page.dart';
import 'package:xo_game/view/screens/enter_teams_page.dart';
import 'package:xo_game/view/screens/levels_page.dart';
import 'package:xo_game/view/screens/online_game.dart';
import 'package:xo_game/view/screens/profile_page.dart';
import 'package:xo_game/view/widgets/custom_button.dart';
import 'package:xo_game/view/widgets/profile_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  String userName = "";


  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!isLoggedIn) return false;

    final expirationString = prefs.getString('expirationOfJwt');
    if (expirationString == null) return false;

    final expirationDate = DateTime.tryParse(expirationString);
    if (expirationDate == null) return false;

    userName = prefs.getString('userName') ?? "";

    return DateTime.now().isBefore(expirationDate);
  }

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
    final imageState = context.watch<ProfileImageCubit>().state;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              const ProfileCard(
                image: coin,
                title: '+100000',
                sz: 20,
                fontSz: 16,
              ),
              IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kDarkPurple,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: CircleAvatar(
                    backgroundImage: imageState.avatarImg.image,
                  ),
                ),
                onPressed: () async {
                  bool isLogin = await isLoggedIn();
                  if (isLogin == false) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } else {
                    String userName = await getData('userName') ?? "";
                    String email = await getData('email') ?? '';
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  userName: userName,
                                  email: email,
                                )));
                  }
                },
              ),
            ],
          )
        ],
      ),
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
                        : () async {
                            bool loggedIn = await isLoggedIn();

                            if (loggedIn) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return OnlineGame();
                                }),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            }
                          },
              ),
            ),
          ),
        const SizedBox(
          height: 16,
        ),
      ]),
    );
  }
}
