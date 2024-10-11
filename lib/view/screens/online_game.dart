import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/Internet/internet_bloc.dart';
import 'package:xo_game/models/Player.dart';
import 'package:xo_game/services/services.dart';
import 'package:xo_game/services/signal_r.dart';
import 'package:xo_game/view/screens/game_page.dart';

class OnlineGame extends StatefulWidget {
  const OnlineGame({super.key});

  @override
  State<OnlineGame> createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  final SignalRService signalRService = SignalRService();
  @override
  void dispose() {
    signalRService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetState>(builder: (context, state) {
      if (state is ConnectedState) {
        return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Spin(
                spins: 5,
                duration: const Duration(seconds: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInLeft(
                      onFinish: (direction) {
                        //setup connection and call the callback function

                        signalRService.setupSignalR(kToken, onSearchForPlayers:
                            (gameId, player1, player2) async {
                          final Player p1 = await getPlayerInfo(player1);
                          final Player p2 = await getPlayerInfo(player2);
                          

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GamePage(
                                p1: p1.userName!,
                                p2: p2.userName!,
                                gameId: gameId,
                              ),
                            ),
                          );
                        },
                       
                        );

                      },
                      delay: const Duration(seconds: 1),
                      child: Image.asset(
                        'assets/images/tic.png',
                        width: 200,
                      ),
                    ),
                    SpinPerfect(
                      duration: const Duration(seconds: 3),
                      delay: const Duration(seconds: 2),
                      child: Image.asset(
                        'assets/images/tac.png',
                        width: 200,
                      ),
                      //invoke search for players
                      onFinish: (direction) {
                        signalRService.searchForPlayers();
                     
                      },
                    ),
                    FadeInRight(
                      delay: const Duration(seconds: 2),
                      child: Image.asset(
                        'assets/images/toe.png',
                        width: 200,
                      ),
                    ),
                  ],
                ),
              ),
            ));
      } else if (state is DisconnectedState) {
        return Scaffold(
          appBar: AppBar(),
          body: BounceInDown(
            child: const Center(
                child: Image(image: AssetImage('assets/images/error.png'))),
          ),
        );
      }
      return const SizedBox();
    });
  }
}
