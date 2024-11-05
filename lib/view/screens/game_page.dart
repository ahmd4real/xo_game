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
      this.onlineMode = false,
      this.botMode = false});

  String p1, p2, avatar1, avatar2, gameId;
  bool onlineMode, botMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          if (state.winner != null || state.isDraw) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              String message = getResultMessage(
                  state, onlineMode, yourId, receivedWinnerId, p1, p2);

              print('Message Result : $message\nOnline Mode: $onlineMode');
              print(
                  "state.winner: ${state.winner}\nstate.isDraw: ${state.isDraw}");
              print("yourId: $yourId\nreceivedWinnerId: $receivedWinnerId");
              print("p1: $p1\np2: $p2");

              List<String> players = [p1, p2];
              if (!players.contains('Bot') && !onlineMode) {
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
              signalRServiceGlobal, gameId,
              onlineMode: onlineMode, botMode: botMode);
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
    String gameId,
    {bool onlineMode = false,
    bool botMode = false}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BounceInRight(
            child: UserCard(
              botMode: botMode,
              onlineMode: onlineMode,
              avatar: avatar1,
              userName: p1,
              symbol: 'X',
              isActive: state.isXturn,
            ),
          ),
          BounceInLeft(
            child: UserCard(
              botMode: botMode,
              onlineMode: onlineMode,
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
      buildBoard(context, state, signalRService, gameId, onlineMode),
      const SizedBox(height: 32),
    ],
  );
}

Widget buildBoard(BuildContext context, GameState state,
    SignalRService signalRService, String gameId, bool onlineMode) {
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
                if (state.isXturn == (player1Id == yourId) && onlineMode) {
                  context.read<GameCubit>().makeMoveOnline(0);

                  if (onlineMode) {
                    signalRService.gamePlay(gameId, 1);
                  }
                } else {
                  if (!onlineMode) {
                    context.read<GameCubit>().makeMove(0);
                  }
                  print("Not your turn!"); // Optional feedback
                }
              },
            ),
            BoardSq(
                top: false,
                symbol: state.board[1],
                onTap: () {
                  if (state.isXturn == (player1Id == yourId) && onlineMode) {
                    context.read<GameCubit>().makeMoveOnline(1);

                    if (onlineMode) {
                      signalRService.gamePlay(gameId, 1 + 1);
                    }
                  } else {
                    if (!onlineMode) {
                      context.read<GameCubit>().makeMove(1);
                    }
                    print("Not your turn!"); // Optional feedback
                  }
                }),
            BoardSq(
                top: false,
                right: false,
                symbol: state.board[2],
                onTap: () {
                  if (state.isXturn == (player1Id == yourId) && onlineMode) {
                    context.read<GameCubit>().makeMoveOnline(2);

                    if (onlineMode) {
                      signalRService.gamePlay(gameId, 2 + 1);
                    }
                  } else {
                    if (!onlineMode) {
                      context.read<GameCubit>().makeMove(2);
                    }
                    //print("Not your turn!"); // Optional feedback
                  }
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
                    if (state.isXturn == (player1Id == yourId) && onlineMode) {
                      context.read<GameCubit>().makeMoveOnline(i == 0
                          ? 3
                          : i == 1
                              ? 4
                              : i == 2
                                  ? 5
                                  : -1);

                      if (onlineMode) {
                        signalRService.gamePlay(
                            gameId,
                            i == 0
                                ? 4
                                : i == 1
                                    ? 5
                                    : i == 2
                                        ? 6
                                        : -1);
                      }
                    } else {
                      if (!onlineMode) {
                        context.read<GameCubit>().makeMove(i == 0
                            ? 3
                            : i == 1
                                ? 4
                                : i == 2
                                    ? 5
                                    : -1);
                      }

                      print("Not your turn!"); // Optional feedback
                    }
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
                  if (state.isXturn == (player1Id == yourId) && onlineMode) {
                    context.read<GameCubit>().makeMoveOnline(6);

                    if (onlineMode) {
                      signalRService.gamePlay(gameId, 7);
                    }
                  } else {
                    if (!onlineMode) {
                      context.read<GameCubit>().makeMove(6);
                    }
                    //print("Not your turn!"); // Optional feedback
                  }
                }),
            BoardSq(
              symbol: state.board[7],
              onTap: () {
                if (state.isXturn == (player1Id == yourId) && onlineMode) {
                  context.read<GameCubit>().makeMoveOnline(7);

                  if (onlineMode) {
                    signalRService.gamePlay(gameId, 8);
                  }
                } else {
                  if (!onlineMode) {
                    context.read<GameCubit>().makeMove(7);
                  }
                  //print("Not your turn!"); // Optional feedback
                }
              },
              bottom: false,
            ),
            BoardSq(
              symbol: state.board[8],
              onTap: () {
                if (state.isXturn == (player1Id == yourId) && onlineMode) {
                  context.read<GameCubit>().makeMoveOnline(8);

                  if (onlineMode) {
                    signalRService.gamePlay(gameId, 9);
                  }
                } else {
                  if (!onlineMode) {
                    context.read<GameCubit>().makeMove(8);
                  }
                  //print("Not your turn!"); // Optional feedback
                }
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
