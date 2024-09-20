import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   CustomButton(
      {super.key,
      required this.color1,
      required this.color2,
      required this.text,
      this.onTap
      });
  final Color color1, color2;
  final String text;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
           // border: Border.all(width: 3,color: kBlue),
            gradient: LinearGradient(colors: [color1, color2])),
        child: Center(
          child: Text(
                textAlign: TextAlign.center,
            text,
            style: const TextStyle(
            
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
