import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/Internet/internet_bloc.dart';
import 'package:xo_game/models/player.dart';
import 'package:xo_game/services/services.dart';
import 'package:xo_game/services/signal_r.dart';
import 'package:xo_game/view/screens/enter_teams_page.dart';
import 'package:xo_game/view/screens/game_page.dart';

SignalRService signalRServiceGlobal = SignalRService();

class OnlineGame extends StatefulWidget {
  const OnlineGame({super.key});

  @override
  State<OnlineGame> createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  
  Timer? searchTimer;
  bool foundPlayers = false;

  
  @override
  void dispose() {
    //signalRService.dispose();
    searchTimer?.cancel();
    super.dispose();
  }

  // Function to search for players in a while loop
  Future<void> searchForPlayers() async {
    searchTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (foundPlayers) {
        print('Found players');
        timer.cancel();
        print('Timer cancelled');
        return;
      }

      if (timer.tick >= 12) {
        // After 1 minute (12 * 5 seconds)
        timer.cancel();

        _showPlayOfflineDialog(); // Offer to play offline after 1 minute
      } else {
        print('Timer Value: ${timer.tick}');
        signalRServiceGlobal.searchForPlayers();
      }
    });
  }

  // Function to show a dialog offering the user to play offline
  Future<void> _showPlayOfflineDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No players found'),
          content: const Text('Do you want to play offline?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User wants to play offline
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => EnterTeamsPage()));
    } else {
      searchForPlayers();
    }
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
                      // Setup SignalR connection and start searching for players
                      signalRServiceGlobal.setupSignalR(
                        kToken,
                        onSearchForPlayers: (gameId, player1, player2) async {
                          final Player p1 = await getPlayerInfo(player1);
                          final Player p2 = await getPlayerInfo(player2);

                          setState(() {
                            foundPlayers = true;
                            searchTimer?.cancel();
                            signalRServiceGlobal.offSearchForPlayers();
                            // Mark players as found
                          });

                          // Stop the search timer when players are found

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
                        onGameplay: (winnerId) {
                          print('Hello from onGameplay from onlineGame page');
                        },
                      );

                      // Start searching for players in a loop for 1 minute
                      if (foundPlayers == false) {
                        searchForPlayers();
                      }
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
          ),
        );
      } else if (state is DisconnectedState) {
        return Scaffold(
          appBar: AppBar(),
          body: BounceInDown(
            child: const Center(
              child: Image(image: AssetImage('assets/images/error.png')),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}
