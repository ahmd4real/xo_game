 // Define Player enum

 import 'package:xo_game/constants.dart';


class GameState {
  final List<String> board;
  final bool isXturn;
  final List<int> xMoves;
  final List<int> oMoves;
  final String? winner;
  final bool isDraw;
  final List<int>? winningCombo; // Holds the indices of the winning combination
  final bool isBotTurn; // Track if it’s the bot’s turn
  final int currentPlayer; // Track whose turn it is (Player 1 or Player 2)

  GameState({
    required this.board,
    required this.isXturn,
    required this.xMoves,
    required this.oMoves,
    required this.isBotTurn,
    required this.currentPlayer, // New field for player turns
    this.winner,
    this.isDraw = false,
    this.winningCombo,
  });

  /// Initial state factory constructor
  factory GameState.initial() {
    return GameState(
      board: List.filled(9, ''), // Empty 9-slot board
      isXturn: true,             // X always starts
      xMoves: [],                // No moves for X initially
      oMoves: [],                // No moves for O initially
      isBotTurn: false,          // Not bot's turn initially
      currentPlayer: player1Id, // Player 1 starts the game
    );
  }

  /// CopyWith method to create a new GameState with modified properties
  GameState copyWith({
    List<String>? board,
    bool? isXturn,
    List<int>? xMoves,
    List<int>? oMoves,
    String? winner,
    bool? isDraw,
    List<int>? winningCombo,
    bool? isBotTurn,
    int? currentPlayer, // Allow changing the current player
  }) {
    return GameState(
      board: board ?? this.board,
      isXturn: isXturn ?? this.isXturn,
      xMoves: xMoves ?? this.xMoves,
      oMoves: oMoves ?? this.oMoves,
      winner: winner ?? this.winner,
      isDraw: isDraw ?? this.isDraw,
      winningCombo: winningCombo ?? this.winningCombo,
      isBotTurn: isBotTurn ?? this.isBotTurn,
      currentPlayer: currentPlayer ?? this.currentPlayer,
    );
  }

  /// Factory constructor for a winning state
  factory GameState.win({
    required String winner,
    required List<int> winningCombo,
  }) {
    return GameState(
      board: List.filled(9, ''), // Reset board after a win
      isXturn: true,             // X starts again
      xMoves: [],
      oMoves: [],
      winner: winner,            // Declare the winner
      winningCombo: winningCombo, // Winning combination indices
      isBotTurn: false,          // Reset bot's turn
      currentPlayer: player1Id, // Player 1 starts the new game
    );
  }

  /// Factory constructor for a draw state
  factory GameState.draw() {
    return GameState(
      board: List.filled(9, ''), // Reset board for a new game
      isXturn: true,             // X starts again
      xMoves: [],
      oMoves: [],
      isDraw: true,              // Mark the game as a draw
      isBotTurn: false,          // Reset bot's turn
      currentPlayer: player1Id, // Player 1 starts the new game
    );
  }
}
