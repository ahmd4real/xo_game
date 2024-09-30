import 'package:bloc/bloc.dart';
import 'package:xo_game/models/GameCubit/game_state.dart';
import 'dart:async';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.initial());
  
  void makeMove(int index) {
    if (state.board[index].isEmpty && state.winner == null && !state.isDraw) {
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
    }
  }

  void resetGame() {
    emit(GameState.initial());
  }

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
        // Clear all moves except the winning moves
        final clearedBoard = List<String>.filled(9, '');
        clearedBoard[combo[0]] = board[combo[0]];
        clearedBoard[combo[1]] = board[combo[1]];
        clearedBoard[combo[2]] = board[combo[2]];

        emit(state.copyWith(board: clearedBoard, winner: board[combo[0]]));

        // Delay the reset by 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          resetGame();
        });
        return;
      }
    }

    if (!board.contains('')) {
      emit(state.copyWith(isDraw: true));

      // Delay the reset by 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        resetGame();
      });
    }
  }
}
