import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/view/screens/game_page.dart';
import 'package:xo_game/view/screens/levels_page.dart';
import 'package:xo_game/view/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
  List <Color>colors=[kGreen,kBlue,kRed,kOrange,kPink,kPurple,];
  List<String>options=["Single Player","Offline Multi Player","Online Multi Player"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      backgroundColor: background,

      body: ListView(
        children: [
          const SizedBox(height: 80,),
          const Center(child: Text("XO GAME",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),)),
      
        const SizedBox(height: 240
        ,),
        for (int j = 0; j < 3; j++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: CustomButton(
              color1: colors[j*2],
              color2: colors[j*2+1],
              text: options[j],
              onTap: j==0?(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const LevelsPage()));
              }:j==1?(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const GamePage()));
              }:(){}
            ),
          ),
        ]

      ),


      
    );

  }
}