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
    } else {
      print('SignalR connection already started');
    }

    hubConnection.on('SearchForPlayers', (parameters) {
      print('Received onSearchForPlayers: $parameters');
      if (parameters != null && parameters.length == 3) {
        final gameId = parameters[0] as String;
        final player1 = parameters[1] as int;
        final player2 = parameters[2] as int;

        onSearchForPlayers?.call(gameId, player1, player2);
      }
    });

    hubConnection.on('Gameplay', (parameters) {
      print('Received Gameplay callback: $parameters');
      if (parameters != null && parameters.length == 1) {
        final winnerId = parameters[0] as int;

        onGameplay?.call(winnerId);
      }
    });
  }

  Future<void> gamePlay(String id, int move) async {
    if (hubConnection.state == HubConnectionState.Connected) {
      print('Invoking Gameplay');
      try {
        await hubConnection.invoke('Gameplay', args: [id,move]);
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

  void dispose() {
    print('Dispose method called, cleaning up SignalR connection...');
    // Remove listeners to avoid memory leaks
    hubConnection.off('SearchForPlayers');
    hubConnection.off('Gameplay');

    // Stop the connection properly
    hubConnection.stop().then((_) {
      print('SignalR connection stopped successfully.');
    }).catchError((error) {
      print('Error stopping SignalR connection: $error');
    });
  }
  void offSearchForPlayers() {
    if (hubConnection.state == HubConnectionState.Connected) {
      hubConnection.off('SearchForPlayers');
      print('Off SearchForPlayers successfully');
    }
  }



}



class GameTurns {
  String id;
  int move;

  GameTurns(this.id, this.move);
}
