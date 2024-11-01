import 'package:bloc/bloc.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/models/GameCubit/game_state.dart';
import 'dart:async';
import 'dart:math';
import 'package:xo_game/models/bot/min_max.dart';

enum GameMode {
  playerVsPlayer,
  playerVsBotEasy,
  playerVsBotMedium,
  playerVsBotHard,
  onlineMode
}

class GameCubit extends Cubit<GameState> {
  final GameMode gameMode;
  final Minimax minimax = Minimax(botSymbol: 'X');
  final Random random = Random();

  GameCubit({this.gameMode = GameMode.playerVsBotHard})
      : super(GameState.initial());

  /// Player or bot makes a move
  
void makeMove(int index) {
    if (state.board[index].isEmpty &&
        state.winner == null &&
        !state.isDraw &&
        !state.isBotTurn) {
      final newBoard = List<String>.from(state.board);
      newBoard[index] = state.isXturn ? 'X' : 'O';

      final xMoves = state.isXturn
          ? (List<int>.from(state.xMoves)..add(index))
          : List<int>.from(state.xMoves);

      final oMoves = !state.isXturn
          ? (List<int>.from(state.oMoves)..add(index))
          : List<int>.from(state.oMoves);

      emit(state.copyWith(
        board: newBoard,
        isXturn: !state.isXturn,
        xMoves: xMoves,
        oMoves: oMoves,
      ));

      _checkWinOrDraw(newBoard);

      // Trigger bot move if applicable
      if (_shouldBotPlay()) {
        emit(state.copyWith(isBotTurn: true));
        Future.delayed(const Duration(milliseconds: 200), _botMakeMove);
      }
    }
  }




  // play online move

  void makeMoveOnline(int index, {bool isRemoteMove = false}) {
    if (state.board[index].isEmpty &&
        state.winner == null &&
        !state.isDraw &&
        (isRemoteMove || state.isXturn == (player1Id == yourId))) {
      final newBoard = List<String>.from(state.board);
      newBoard[index] = state.isXturn ? 'X' : 'O';

      final xMoves = state.isXturn
          ? (List<int>.from(state.xMoves)..add(index))
          : List<int>.from(state.xMoves);

      final oMoves = !state.isXturn
          ? (List<int>.from(state.oMoves)..add(index))
          : List<int>.from(state.oMoves);

      emit(state.copyWith(
        board: newBoard,
        isXturn: !state.isXturn, // Toggle turn after a move
        xMoves: xMoves,
        oMoves: oMoves,
      ));

      _checkWinOrDraw(newBoard);

      // Trigger bot move if applicable
      if (_shouldBotPlay()) {
        emit(state.copyWith(isBotTurn: true));
        Future.delayed(const Duration(milliseconds: 200), _botMakeMove);
      }
    }
  }

  /// Bot makes its move
  void _botMakeMove() {
    int botMove;

    if (gameMode == GameMode.playerVsBotEasy) {
      botMove = _getRandomMove();
    } else if (gameMode == GameMode.playerVsBotMedium) {
      botMove = _getMinimaxMove('O');
    } else {
      botMove = _getMinimaxMove('X');
    }

    emit(state.copyWith(isBotTurn: false)); // Reset bot's turn
    makeMove(botMove);
  }

  /// Get a random available move for the bot (easy difficulty)
  int _getRandomMove() {
    final availableMoves = [
      for (int i = 0; i < state.board.length; i++)
        if (state.board[i].isEmpty) i
    ];
    return availableMoves[random.nextInt(availableMoves.length)];
  }

  /// Minimax move calculation for medium and hard difficulties
  int _getMinimaxMove(String botSymbol) {
    final boardMatrix = [
      [state.board[0], state.board[1], state.board[2]],
      [state.board[3], state.board[4], state.board[5]],
      [state.board[6], state.board[7], state.board[8]]
    ];

    minimax.minimax(botSymbol);

    for (int i = 0; i < 9; i++) {
      if (state.board[i] != boardMatrix[i ~/ 3][i % 3]) {
        return i;
      }
    }

    return _getRandomMove(); // Fallback to random if minimax fails
  }

  /// Reset the game state
  void resetGame() {
    emit(GameState.initial());
  }

  /// Check for win or draw
  void _checkWinOrDraw(List<String> board) {
    const winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combo in winningCombinations) {
      if (board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]] &&
          board[combo[0]].isNotEmpty) {
        _highlightWinningMoves(combo);
        emit(state.copyWith(
          winner: board[combo[0]],
          winningCombo: combo,
        ));

        _scheduleReset(); // Delayed reset after win
        return;
      }
    }

    if (!board.contains('')) {
      emit(state.copyWith(isDraw: true));
      _scheduleReset(); // Delayed reset after draw
    }
  }

  /// Highlight only winning moves on the board
  void _highlightWinningMoves(List<int> winningCombo) {
    final newBoard = List<String>.filled(9, '');
    for (var index in winningCombo) {
      newBoard[index] = state.board[index];
    }

    final newXMoves =
        state.xMoves.where((move) => winningCombo.contains(move)).toList();
    final newOMoves =
        state.oMoves.where((move) => winningCombo.contains(move)).toList();

    emit(state.copyWith(
      board: newBoard,
      xMoves: newXMoves,
      oMoves: newOMoves,
    ));
  }

  /// Schedule a game reset after a short delay
  void _scheduleReset() {
    Future.delayed(const Duration(milliseconds: 400), resetGame);
  }

  /// Determine if the bot should play the next move
  bool _shouldBotPlay() {
    return gameMode != GameMode.playerVsPlayer &&
        gameMode != GameMode.onlineMode &&
        !state.isXturn &&
        state.winner == null &&
        !state.isDraw;
  }
}
