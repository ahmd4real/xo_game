import 'package:flutter/material.dart';

class LevelsButton extends StatelessWidget {
  const LevelsButton(
      {super.key,
      required this.color1,
      required this.color2,
      required this.text});
  final Color color1, color2;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(colors: [color1, color2])),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      Positioned(

        left: 0,
        child: Container(
          height: 64,
          width: 64,
          
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
              color: Colors.white, 
             
              ),
        ),
      )
    ]);
  }
}
