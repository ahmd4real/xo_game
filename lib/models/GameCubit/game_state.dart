class GameState {
  final List<String> board;
  final bool isXturn;
  final List<int> xMoves;
  final List<int> oMoves;
  final String? winner;
  final bool isDraw;
  final List<int>? winningCombo; // Add this line

  GameState({
    required this.board,
    required this.isXturn,
    required this.xMoves,
    required this.oMoves,
    this.winner,
    this.isDraw = false,
    this.winningCombo, // Add this line
  });

  factory GameState.initial() {
    return GameState(
      board: List.filled(9, ''),
      isXturn: true,
      xMoves: [],
      oMoves: [],
    );
  }

  GameState copyWith({
    List<String>? board,
    bool? isXturn,
    List<int>? xMoves,
    List<int>? oMoves,
    String? winner,
    bool? isDraw,
    List<int>? winningCombo, // Add this line
  }) {
    return GameState(
      board: board ?? this.board,
      isXturn: isXturn ?? this.isXturn,
      xMoves: xMoves ?? this.xMoves,
      oMoves: oMoves ?? this.oMoves,
      winner: winner,
      isDraw: isDraw ?? this.isDraw,
      winningCombo: winningCombo ?? this.winningCombo, // Add this line
    );
  }

  factory GameState.win({required String winner, required List<int> winningCombo}) {
    return GameState(
      board: List.filled(9, ''),
      isXturn: true,
      xMoves: [],
      oMoves: [],
      winner: winner,
      winningCombo: winningCombo, // Add this line
    );
  }

  factory GameState.draw() {
    return GameState(
      board: List.filled(9, ''),
      isXturn: true,
      xMoves: [],
      oMoves: [],
      isDraw: true,
    );
  }
}
