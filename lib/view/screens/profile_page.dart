import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/ProfileImageCubit/profile_image_cubit.dart';
import 'package:xo_game/services/services.dart';
import 'package:xo_game/view/screens/edit_profile_page.dart';
import 'package:xo_game/view/screens/home_page.dart';
import 'package:xo_game/view/widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.userName, required this.email});
  final String userName, email;

  @override
  Widget build(BuildContext context) {
    final imageState = context.watch<ProfileImageCubit>().state;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent, width: 1),
              ),
              child: IconButton(
                onPressed: () async {
                   bool loggedOut = await signOut(context);
                  if (loggedOut) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
                icon: const Icon(
                  size: 24,
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height / 32),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(userName: userName)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kDarkPurple,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: CircleAvatar(
                      backgroundImage: imageState.avatarImg.image,
                      radius: MediaQuery.of(context).size.width / 6,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontFamily: regFont,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontFamily: regFont,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProfileCard(
                  title: '+1000000',
                  image: coin,
                  sz: 10,
                ),
                ProfileCard(
                  title: '23',
                  image: kass,
                  sz: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
