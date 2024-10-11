import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class SignalRService {
  late HubConnection hubConnection;
  Function(String gameId, int player1, int player2)? onSearchForPlayers;
  Function(int winnerId)? onGameplay;

  Future<void> setupSignalR(
    String token, {
    Function(String gameId, int player1, int player2)? onSearchForPlayers,
    Function(int winnerId)? onGameplay,
  }) async {
    this.onSearchForPlayers = onSearchForPlayers;
    this.onGameplay = onGameplay;
    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://xogame.runasp.net/xo',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .build();

    if (hubConnection.state != HubConnectionState.Connected) {
      await hubConnection.start();
      print('SignalR connection started successfully');
    }else{
      print('SignalR connection already started');
    }

    hubConnection.on('SearchForPlayers', (parameters) {
      print('Hello from onSearchForPlayers: $parameters');
      if (parameters != null && parameters.length == 3) {
        final gameId = parameters[0] as String;
        final player1 = parameters[1] as int;
        final player2 = parameters[2] as int;

        if (onSearchForPlayers != null) {
          onSearchForPlayers(gameId, player1, player2);
        }
      }
    });

    hubConnection.on('Gameplay', (parameters) {
      print('Hello from Gameplay the callBack fun: $parameters');
      if (parameters != null && parameters.length == 1) {
        final winnerId = parameters[0] as int;

        if (onGameplay != null) {
          onGameplay(winnerId);
        }
      }
    });
  }



  Future<void> gamePlay(GameTurns gameTurn) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      print('Gameplay invoked');
      try {
        await hubConnection.invoke('Gameplay', args: [gameTurn]);
        print('Gameplay invoked successfully');
      } catch (e) {
        print('Error invoking Gameplay: $e');
      }
    }
  }

  Future<void> searchForPlayers() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        await hubConnection.invoke('SearchForPlayers');
        print('SearchForPlayers invoked successfully');
      } catch (e) {
        print('Error invoking SearchForPlayers: $e');
      }
    }
  }

  @override

  void dispose() {
    print('Dispose method called, stopping SignalR connection...');
    hubConnection.stop().then((_) {
      print('SignalR connection stopped successfully.');
    }).catchError((error) {
      print('Error stopping SignalR connection: $error');
    });
  }
}


  class GameTurns{
    String id;
    int move;

    GameTurns(this.id, this.move);
  }