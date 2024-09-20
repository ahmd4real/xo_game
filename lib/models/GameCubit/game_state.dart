class GameState {
  final List<String> board;
  final bool isXturn;
  final List<int> xMoves;
  final List<int> oMoves;
  final String? winner;
  final bool isDraw;

  GameState({
    required this.board,
    required this.isXturn,
    required this.xMoves,
    required this.oMoves,
    this.winner,
    this.isDraw = false,
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
  }) {
    return GameState(
      board: board ?? this.board,
      isXturn: isXturn ?? this.isXturn,
      xMoves: xMoves ?? this.xMoves,
      oMoves: oMoves ?? this.oMoves,
      winner: winner,
      isDraw: isDraw ?? this.isDraw,
    );
  }

  factory GameState.win({required String winner}) {
    return GameState(
      board: List.filled(9, ''),
      isXturn: true,
      xMoves: [],
      oMoves: [],
      winner: winner,
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
