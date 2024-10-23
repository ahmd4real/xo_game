import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/GameCubit/game_cubit.dart';
import 'package:xo_game/models/GameCubit/game_state.dart';
import 'package:xo_game/services/signal_r.dart';
import 'package:xo_game/utilities.dart';
import 'package:xo_game/view/screens/online_game.dart';
import 'package:xo_game/view/widgets/board_sq.dart';
import 'package:xo_game/view/widgets/user_card.dart';

class GamePage extends StatelessWidget {
  GamePage(
      {super.key,
      this.gameId = '',
      this.p1 = 'Player1',
      this.p2 = 'Player2',
      this.avatar1 = kAvatar,
      this.avatar2 = kAvatar,
      });

  String p1, p2, avatar1, avatar2, gameId;

  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          if (state.winner != null || state.isDraw) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              String message = state.winner != null
                  ? '${state.winner == 'X' ? p1 : p2}  wins!'
                  : 'It\'s a draw!';
              List<String> players = [p1, p2];

              if (!players.contains('Bot')) {
                players.shuffle();
                p1 = players[0];
                p2 = players[1];
              }
              Future.delayed(const Duration(milliseconds: 500), () {
                showGameEndDialog(context, message);
              });
            });
          }
          return buildGameUI(context, state, p1, p2, avatar1, avatar2,
              signalRServiceGlobal, gameId);
        },
      ),
    );
  }
}

Widget buildGameUI(
    BuildContext context,
    GameState state,
    String p1,
    String p2,
    String avatar1,
    String avatar2,
    SignalRService signalRService,
    String gameId) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BounceInRight(
            child: UserCard(
              avatar: avatar1,
              userName: p1,
              symbol: 'X',
              isActive: state.isXturn,
            ),
          ),
          BounceInLeft(
            child: UserCard(
              avatar: avatar2,
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
      buildBoard(context, state, signalRService, gameId),
      const SizedBox(height: 32),
    ],
  );
}

Widget buildBoard(BuildContext context, GameState state,
    SignalRService signalRService, String gameId) {
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
              onTap: () {
                context.read<GameCubit>().makeMove(0);
                signalRService.gamePlay(gameId, 1);
              },
            ),
            BoardSq(
                top: false,
                symbol: state.board[1],
                onTap: () {
                  context.read<GameCubit>().makeMove(1);
                  signalRService.gamePlay(gameId, 2);
                }),
            BoardSq(
                top: false,
                right: false,
                symbol: state.board[2],
                onTap: () {
                  context.read<GameCubit>().makeMove(2);
                  signalRService.gamePlay(gameId, 3);
                }),
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
                  onTap: () {
                    context.read<GameCubit>().makeMove(i == 0
                        ? 3
                        : i == 1
                            ? 4
                            : i == 2
                                ? 5
                                : -1);
                    GameTurns gameTurn = GameTurns(
                        gameId,
                        i == 0
                            ? 4
                            : i == 1
                                ? 5
                                : i == 2
                                    ? 6
                                    : -1);

                    signalRService.gamePlay(
                        gameId,
                        i == 0
                            ? 4
                            : i == 1
                                ? 5
                                : i == 2
                                    ? 6
                                    : -1);
                  }),
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
                onTap: () {
                  context.read<GameCubit>().makeMove(6);
                  signalRService.gamePlay(gameId, 7);
                }),
            BoardSq(
              symbol: state.board[7],
              onTap: () {
                context.read<GameCubit>().makeMove(7);
                signalRService.gamePlay(gameId, 8);
              },
              bottom: false,
            ),
            BoardSq(
              symbol: state.board[8],
              onTap: () {
                context.read<GameCubit>().makeMove(8);
                signalRService.gamePlay(gameId, 9);
              },
              bottom: false,
              right: false,
            ),
          ],
        ),
      ),
    ],
  );
}
