import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/Internet/internet_bloc.dart';
import 'package:xo_game/services/signal_r.dart';

class OnlineGame extends StatelessWidget {
  OnlineGame({super.key});
  SignalRService signalRService = SignalRService();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetState>(
      builder: (context, state) {
        if (state is NotConnectedState) {
          return const Scaffold(
            body: Center(
              child: Icon(
                Icons.wifi_off_rounded,
                size: 300,
                color: Colors.amber
              ),
            ),
          );
          
        }
        return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Spin(
                onFinish: (direction) {
                  signalRService.searchForPlayers();
                },
                spins: 5,
                duration: const Duration(seconds: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInLeft(
                      onFinish: (direction) {
                        print('Finished spin 1');
                        signalRService.setupSignalR(
                          kToken,
                          onSearchForPlayers: () {
                            print('hello from onSearchForPlayers');
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
      },
    );
  }
}
