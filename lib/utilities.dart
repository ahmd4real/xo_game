 
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/GameCubit/game_cubit.dart';

Widget titleWidget(BuildContext context,{int sz=8}){
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInLeft(
                  child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / sz,
                child: Image.asset('assets/images/tic.png'),
              )),
              FadeInUp(
                  child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / sz,
                child: Image.asset('assets/images/tac.png'),
              )),
              FadeInRight(
                  child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / sz,
                child: Image.asset('assets/images/toe.png'),
              ))
            ],
          ),
        );
  }


  void showGameEndDialog(
  BuildContext context,
  String message,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        backgroundColor: background,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: kDarkPurple, width: 2),
        ),
        content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              kAvatar,
              width: MediaQuery.sizeOf(context).width / 2,
              height: MediaQuery.sizeOf(context).width / 2,
            )),
        actions: [
          Center(
            child: Text(
              textAlign: TextAlign.center,
              message,
              style: const TextStyle(
                fontFamily: font,
                  color: Colors.amber,
                  fontSize: 24,
                  ),
            ),
          ),
          Center(
              child: Swing(
            infinite: true,
            child: Image.asset(winnerWord),
          )),
          Center(
            child: TextButton(
              style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(kOrange),
                
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GameCubit>().resetGame();
              },
              child: const Text('Play Again'),
            ),
          ),
        ],
      );
    },
  );
}


Widget symbolWidget(String symbol,double sz){
  return Center(
    child: Text(
              symbol,
              style: TextStyle(
                  fontFamily: font,
                  color: symbol == "X" ? kRed : Colors.amber,
                  fontSize: sz,
                  shadows: [
                     Shadow(
                     color: Colors.amber.withOpacity(0.5),
                    
                    blurRadius: 10,
                    offset: const Offset(0, 3), 
                    ),
                    Shadow(
                       color: Colors.purple.withOpacity(0.5),
                   
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    ),
                  ]),
            ),
  );
}


Future<String?> getData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

bool passwordMatched(String s1,String s2){
  return s1==s2;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

Widget snipkit(BuildContext context){
   return SpinKitCircle(
  itemBuilder: (BuildContext context, int index) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber,
      ),
    );
  }, 
);
}