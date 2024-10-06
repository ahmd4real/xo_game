import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class SignalRService {
  late HubConnection hubConnection;
  Function()? onSearchForPlayers;

  Future<void> setupSignalR(
    String token, {
    Function()? onSearchForPlayers,
  }) async {
    this.onSearchForPlayers = onSearchForPlayers;

    hubConnection = HubConnectionBuilder()
        .withUrl(
          'https://xogame.runasp.net/xo',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
          ),
        )
        .build();

    await hubConnection.start();
    print('SignalR connection started');

    hubConnection.on('SearchForPlayers', (parameters) {
      print('Hello from onSearchForPlayers: $parameters');
      if (parameters != null && parameters.length == 3) {
        final gameId = parameters[0] as String;
        final player1 = parameters[1] as int;
        final player2 = parameters[2] as int;

        if (onSearchForPlayers != null) {
          onSearchForPlayers();

          print('gameId: $gameId, player1: $player1, player2: $player2');
        }
      }
    });
  }


  Future<void>searchForPlayers() async {
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
