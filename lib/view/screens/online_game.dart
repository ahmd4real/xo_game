import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/Internet/internet_bloc.dart';
import 'package:xo_game/services/signal_r.dart';

class OnlineGame extends StatefulWidget {
  OnlineGame({super.key});

  @override
  State<OnlineGame> createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  final SignalRService signalRService = SignalRService();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetState>(
      builder: (context, state) {
       if (state is ConnectedState) {
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
              )
              
              
              );
    
        } else if (state is DisconnectedState) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(
                "Not Connected",
                style: const TextStyle(
                    fontSize: 18, fontFamily: font, color: Colors.white),
              ),
            ),
          );
        }
        return const SizedBox();
      }
        );
        
        
  }
}

// class OnlineGame extends StatefulWidget {
//   const OnlineGame({super.key});

//   @override
//   State<OnlineGame> createState() => _OnlineGameState();
// }

// class _OnlineGameState extends State<OnlineGame> {
//   String inter = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         child: BlocConsumer<InternetBloc, InternetState>(
//           listener: (context, state) {
//               if (state is ConnectedState) {
//               inter = state.internetState;
//               print('Connected');
             
//             } else if (state is DisconnectedState) {
//               inter = state.internetState;
//               print('Disconnected');
//             }
//           },
//           builder: (context, state) {
          
//             return Center(
//               child: Text(
//                 inter,
//                 style: const TextStyle(
//                     fontSize: 18, fontFamily: font, color: Colors.white),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
