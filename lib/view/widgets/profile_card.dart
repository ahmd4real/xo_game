import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {super.key, required this.image, required this.title, this.sz = 6,this.fontSz=20});

  final String image, title;
  final double sz,fontSz;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: kDarkPurple.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(24),
            color: Colors.white10),
        
        height: MediaQuery.of(context).size.height / sz,
        margin: const EdgeInsets.only(top: 8.0),
 
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / (sz * 2),
                    child: Image.asset(image),
                  ),
                    const SizedBox(
                    width: 8,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: kOrange, fontSize: fontSz, fontFamily: font),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
