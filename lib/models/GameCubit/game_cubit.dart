import 'package:bloc/bloc.dart';
import 'package:xo_game/models/GameCubit/game_state.dart';
import 'dart:async';

import 'dart:math';
import 'package:xo_game/models/bot/min_max.dart';

enum GameMode {
  playerVsPlayer,
  playerVsBotEasy,
  playerVsBotMedium,
  playerVsBotHard
}

class GameCubit extends Cubit<GameState> {
  final GameMode gameMode;
  final Minimax minimax=Minimax(botSymbol: 'X'); // Minimax instance
  Random random = Random();

  GameCubit({this.gameMode = GameMode.playerVsBotHard,

  
  
  })
      : super(GameState.initial());

  /// Player or bot makes a move
  void makeMove(int index) {
    if (state.board[index].isEmpty &&
        state.winner == null &&
        !state.isDraw &&
        !state.isBotTurn) {
      final newBoard = List<String>.from(state.board);
      newBoard[index] = state.isXturn ? 'X' : 'O';

      final xMoves =
          state.isXturn ? List<int>.from(state.xMoves) : state.xMoves;
      if (state.isXturn) {
        xMoves.add(index);
      }

      final oMoves =
          !state.isXturn ? List<int>.from(state.oMoves) : state.oMoves;
      if (!state.isXturn) {
        oMoves.add(index);
      }

      emit(state.copyWith(
        board: newBoard,
        isXturn: !state.isXturn,
        xMoves: xMoves,
        oMoves: oMoves,
      ));

      _checkWinOrDraw(newBoard);

      // If it's a bot game, let the bot make a move after a short delay
      if (gameMode != GameMode.playerVsPlayer &&
          !state.isXturn &&
          state.winner == null &&
          !state.isDraw) {
        emit(state.copyWith(isBotTurn: true)); // Set bot's turn
        Future.delayed(const Duration(milliseconds: 200), () {
          _botMakeMove();
        });
      }
    }
  }

  /// Bot makes its move
  void _botMakeMove() {
    int botMove;
    if (gameMode == GameMode.playerVsBotEasy) {
      botMove = _getRandomMove(); // Easy: Random move
    } else if (gameMode == GameMode.playerVsBotMedium) {
      botMove = _getMinimaxMove('O'); // Medium: Minimax as 'O'
    } else {
      botMove = _getMinimaxMove('X'); // Hard: Minimax as 'X'
    }

    emit(state.copyWith(isBotTurn: false)); // Reset bot's turn
    makeMove(botMove);
  }

  /// Get a random available move for the bot (easy difficulty)
  int _getRandomMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < state.board.length; i++) {
      if (state.board[i].isEmpty) {
        availableMoves.add(i);
      }
    }
    return availableMoves[random.nextInt(availableMoves.length)];
  }

  /// Minimax move calculation for medium and hard difficulties
  int _getMinimaxMove(String botSymbol) {
    List<List<String>> boardMatrix = [
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

    return _getRandomMove(); // Fallback to random move if minimax fails
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
        _clearNonWinningMoves(combo); // Clear non-winning moves
        emit(state.copyWith(winner: board[combo[0]], winningCombo: combo));

        Future.delayed(const Duration(milliseconds: 400), () {
          resetGame(); // Reset game after short delay
        });
        return;
      }
    }

    if (!board.contains('')) {
      emit(state.copyWith(isDraw: true));

      Future.delayed(const Duration(milliseconds: 200), () {
        resetGame(); // Reset game after short delay on draw
      });
    }
  }

  /// Clear non-winning moves on the board, highlight only winning moves
  void _clearNonWinningMoves(List<int> winningCombo) {
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
}
