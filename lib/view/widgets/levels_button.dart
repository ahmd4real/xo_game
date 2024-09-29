import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class LevelsButton extends StatelessWidget {
  const LevelsButton({
    super.key,
    required this.color1,
    required this.color2,
    required this.text,
    required this.image,
  });
  final Color color1, color2;
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(64),
            gradient: LinearGradient(colors: [color1, color2])),
        child: Center(
          child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: AssetImage(image),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      // foreground: Paint()
                      //   ..style = PaintingStyle.stroke
                      //   ..strokeWidth = 2.0
                      //   ..color = Colors.white54,
                        
                      fontFamily: font),
                ),
              ]),
        ),
      ),
    );
  }
}
