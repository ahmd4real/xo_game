import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/player.dart';
import 'package:xo_game/services/services.dart';
import 'package:xo_game/view/widgets/top_players_widget.dart';

class TopRankedPage extends StatefulWidget {
  const TopRankedPage({super.key});

  @override
  State<TopRankedPage> createState() => _TopRankedPageState();
}

class _TopRankedPageState extends State<TopRankedPage> {
  List<Player> topPlayers = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    print('TopRankedPage initialized');
    super.initState();
    loadTopPlayers();
  }

  void loadTopPlayers() async {
    try {
      final players = await getTopPlayers();
      setState(() {
        topPlayers = players;
        isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      print('Failed to load top players: $e');
      setState(() {
        isLoading = false; // Stop loading on error as well
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  'Top Players',
                  style: TextStyle(
                    color: Colors.amber, 
                    fontSize: 24, 
                    fontFamily: font,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ?  const Center( // Show loading indicator while fetching data
                      child: SpinKitCircle(
                            color: Colors.amber,
                      )
                    )
                  : ListView.builder(
                      itemCount: topPlayers.length,
                      itemBuilder: (context, index) {
                        final player = topPlayers[index];
                        return BounceInRight(
                          delay: Duration(milliseconds: 100 * index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TopPlayersWidget(
                              userName: player.userName ?? 'Unknown',
                              points: player.points ?? 0,
                              avatar: player.profilePicture,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
