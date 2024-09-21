import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/GameCubit/game_cubit.dart';
import 'package:xo_game/models/GameCubit/game_state.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/widgets/board_sq.dart';
import 'package:xo_game/view/widgets/user_card.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.p1, required this.p2});
  final String p1, p2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        iconTheme: IconThemeData(color: kOrange),
      ),
      backgroundColor: background,
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          if (state.winner != null || state.isDraw) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              String message = state.winner != null
                  ? '${state.winner == 'X' ? p1 : p2} wins!'
                  : 'It\'s a draw!';
              showGameEndDialog(context, message);
            });
          }
          return buildGameUI(context, state, p1, p2);
        },
      ),
    );
  }
}

Widget buildGameUI(
    BuildContext context, GameState state, String p1, String p2) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BounceInRight(
            child: UserCard(
              avatar: kAvatar,
              userName: p1,
              symbol: 'X',
              isActive: state.isXturn,
            ),
          ),
          BounceInLeft(
            child: UserCard(
              avatar: kAvatar,
              userName: p2,
              symbol: 'O',
              isActive: !state.isXturn,
            ),
          ),
        ],
      ),
      SizedBox(
        height: MediaQuery.sizeOf(context).height / 8,
      ),
      buildBoard(context, state),
      const SizedBox(height: 32),
    ],
  );
}



Widget buildBoard(BuildContext context, GameState state) {
  return Column(
    children: [
      BounceInUp(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoardSq(
              left: false,
              top: false,
              symbol: state.board[0],
              onTap: () => context.read<GameCubit>().makeMove(0),
            ),
            BoardSq(
              top: false,
              symbol: state.board[1],
              onTap: () => context.read<GameCubit>().makeMove(1),
            ),
            BoardSq(
              top: false,
              right: false,
              symbol: state.board[2],
              onTap: () => context.read<GameCubit>().makeMove(2),
            ),
          ],
        ),
      ),
      BounceInRight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              BoardSq(
                left: i == 0 ? false : true,
                right: i == 2 ? false : true,
                symbol: state.board[i == 0
                    ? 3
                    : i == 1
                        ? 4
                        : i == 2
                            ? 5
                            : -1],
                onTap: () => context.read<GameCubit>().makeMove(i == 0
                    ? 3
                    : i == 1
                        ? 4
                        : i == 2
                            ? 5
                            : -1),
              ),
          ],
        ),
      ),
      BounceInLeft(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoardSq(
              left: false,
              bottom: false,
              symbol: state.board[6],
              onTap: () => context.read<GameCubit>().makeMove(6),
            ),
            BoardSq(
              symbol: state.board[7],
              onTap: () => context.read<GameCubit>().makeMove(7),
              bottom: false,
            ),
            BoardSq(
              symbol: state.board[8],
              onTap: () => context.read<GameCubit>().makeMove(8),
              bottom: false,
              right: false,
            ),
          ],
        ),
      ),
    ],
  );
}
