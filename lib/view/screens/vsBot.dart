// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:xo_game/models/GameCubit/game_cubit.dart';
// import 'package:xo_game/view/screens/game_page.dart';

// class BotGamePage extends StatelessWidget {
//   const BotGamePage({super.key, required this.p1, required this.difficulty});
//   final String p1;
//   final GameMode difficulty;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => GameCubit(gameMode: difficulty, ),
//       child: GamePage(p1: p1, p2: 'Bot'),
//     );
//   }
// }
