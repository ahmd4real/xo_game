import 'package:bloc/bloc.dart';
import 'package:xo_game/models/GameCubit/game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.initial());

  void makeMove(int index) {
    if (state.board[index].isEmpty) {
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
        emit(GameState.win(winner: board[combo[0]]));
        return;
      }
    }

    if (!board.contains('')) {
      emit(GameState.draw());
    }
  }
}
