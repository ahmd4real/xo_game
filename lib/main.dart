import 'package:flutter/material.dart';
import 'package:xo_game/view/screens/home_page.dart';

void main(){
  runApp(const Game());
}


class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: HomePage(),
    );
  }
}