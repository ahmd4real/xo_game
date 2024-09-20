import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        iconTheme:  IconThemeData(color: kOrange),
        title:  Text(
          "Profile",
          style: TextStyle(color: kOrange,
        ),

        )),
        body: Center(
          child: Column(
            
            
          children: [
             SizedBox(
              height:  MediaQuery.sizeOf(context).height / 8,
            ),
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(kAvatar),
            ),
            const SizedBox(height: 16,),
            const Text("user name",style: TextStyle(color: Colors.white,fontSize: 32,fontWeight: FontWeight.bold),),
          const SizedBox(height: 16,),
          const Text('Points ',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
          
          ],
          ),
        ),
    );
  }
}
