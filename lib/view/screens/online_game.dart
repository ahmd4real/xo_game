import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/main.dart';
import 'package:xo_game/models/GameCubit/game_cubit.dart';
import 'package:xo_game/models/Internet/internet_bloc.dart';
import 'package:xo_game/models/player.dart';
import 'package:xo_game/services/services.dart';
import 'package:xo_game/services/signal_r.dart';
import 'package:xo_game/view/screens/enter_teams_page.dart';
import 'package:xo_game/view/screens/game_page.dart';

SignalRService signalRServiceGlobal = SignalRService();

int receivedId = player1Id, receivedMove = -1;
int? receivedWinnerId;

class OnlineGame extends StatefulWidget {
  const OnlineGame({super.key});

  @override
  State<OnlineGame> createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  Timer? searchTimer;
  bool showLoading = false;
  bool isTimerRunning = false;

  @override
  void dispose() {
    //signalRService.dispose();
    searchTimer?.cancel();
    signalRServiceGlobal.dispose();
    super.dispose();
  }

  void startSearchTimer() {
    if (!isTimerRunning) {
      // Ensure the timer is started only once
      isTimerRunning = true;
      searchTimer = Timer(const Duration(seconds: 30), () {
        _showNoPlayersDialog(); // Show dialog after 30 seconds
      });
    }
  }

  void _showNoPlayersDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return BounceInDown(
          child: AlertDialog(
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            backgroundColor: background,
            title: const Text(
              textAlign: TextAlign.center,
              'No Players Found',
              style: TextStyle(fontFamily: font, color: Colors.amber),
            ),
            content: const Text(
              textAlign: TextAlign.center,
              'Would you like to play offline?',
              style: TextStyle(fontFamily: regFont, color: Colors.amber),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red, fontFamily: font),
                ),
              ),
              Pulse(
                infinite: true,
                child: TextButton(
                  onPressed: () {
                    signalRServiceGlobal.dispose();
                    searchTimer?.cancel();
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnterTeamsPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: Colors.white24,
                        )),
                    child: Text(
                      'Play Offline',
                      style: TextStyle(fontFamily: font, color: kGreen),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetState>(builder: (context, state) {
      if (state is ConnectedState) {
        startSearchTimer();
        return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Spin(
                spins: 5,
                duration: const Duration(seconds: 5),
                onFinish: (direction) {
                  setState(() {
                    showLoading = true;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInLeft(
                      onFinish: (direction) {
                        //setup connection and call the callback function

                        signalRServiceGlobal.setupSignalR(
                          kToken,
                          onSearchForPlayers: (gameId, player1, player2) async {
                            print(
                                'Hello from onSearchForPlayers from onlineGame page and this parameters: [$gameId | $player1 | $player2]');

                          
                              Player p1 = await getPlayerInfo(player1);
                              Player p2 = await getPlayerInfo(player2);

                              player1Id = player1;
                              player2Id = player2;
                              searchTimer?.cancel();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GamePage(
                                    onlineMode: true,
                                    p1: player1 == yourId
                                        ? 'You'
                                        : p1.userName!,
                                    p2: player2 == yourId
                                        ? 'You'
                                        : p2.userName!,
                                    avatar1: p1.profilePicture ?? '',
                                    avatar2: p2.profilePicture ?? '',
                                    gameId: gameId,
                                  ),
                                ),
                              );
                          
                          },
                          onGameplay: (id, move, winnerId) {
                            print('Hello from onGameplay from onlineGame page');
                            {
                            setState(() {
                              receivedId = id;
                              receivedMove = move;
                              receivedWinnerId = winnerId;
                              points+=10;
                            });

                            // Call the GameCubit to update the board state.
                            if (winnerId != null && winnerId == yourId) {
                              addPoints(winnerId).then((value) {
                                print('Points added');

                                setState(() {
                                  points += 10;
                                });
                              });
                            }
                            context.read<GameCubit>().makeMoveOnline(move - 1, isRemoteMove: true);
                      }},
                          
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
                        print('Ready to search for players....');
                        signalRServiceGlobal.searchForPlayers();
                      },
                    ),
                    FadeInRight(
                      delay: const Duration(seconds: 2),
                      child: Image.asset(
                        'assets/images/toe.png',
                        width: 200,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    if (showLoading)
                      FadeIn(
                        child: const SpinKitThreeBounce(
                          color: Colors.amber,
                          size: 24.0,
                        ),
                      ),
                    const SizedBox(height: 8.0),
                    if (showLoading)
                      BounceInUp(
                        child: const Text(
                          'Searching for players...',
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16.0,
                              fontFamily: regFont),
                        ),
                      ),
                  ],
                ),
              ),
            ));
      } else if (state is DisconnectedState) {
        signalRServiceGlobal.dispose();
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
