import 'package:bloc/bloc.dart';
import 'package:xo_game/models/GameCubit/game_state.dart';
import 'dart:async';

// class GameCubit extends Cubit<GameState> {
//   GameCubit() : super(GameState.initial());

//   void makeMove(int index) {
//     if (state.board[index].isEmpty && state.winner == null && !state.isDraw) {
//       final newBoard = List<String>.from(state.board);
//       newBoard[index] = state.isXturn ? 'X' : 'O';

//       final xMoves =
//           state.isXturn ? List<int>.from(state.xMoves) : state.xMoves;
//       if (state.isXturn) {
//         xMoves.add(index);
//       }

//       final oMoves =
//           !state.isXturn ? List<int>.from(state.oMoves) : state.oMoves;
//       if (!state.isXturn) {
//         oMoves.add(index);
//       }

//       emit(state.copyWith(
//         board: newBoard,
//         isXturn: !state.isXturn,
//         xMoves: xMoves,
//         oMoves: oMoves,
//       ));

//       _checkWinOrDraw(newBoard);
//     }
//   }

//   void resetGame() {
//     emit(GameState.initial());
//   }

//   void _checkWinOrDraw(List<String> board) {
//     const winningCombinations = [
//       [0, 1, 2],
//       [3, 4, 5],
//       [6, 7, 8],
//       [0, 3, 6],
//       [1, 4, 7],
//       [2, 5, 8],
//       [0, 4, 8],
//       [2, 4, 6],
//     ];

//     for (var combo in winningCombinations) {
//       if (board[combo[0]] == board[combo[1]] &&
//           board[combo[1]] == board[combo[2]] &&
//           board[combo[0]].isNotEmpty) {
//         // Clear all moves except the winning moves
//         final clearedBoard = List<String>.filled(9, '');
//         clearedBoard[combo[0]] = board[combo[0]];
//         clearedBoard[combo[1]] = board[combo[1]];
//         clearedBoard[combo[2]] = board[combo[2]];

//         Future.delayed(const Duration(milliseconds: 200), () {
//           emit(state.copyWith(board: clearedBoard, winner: board[combo[0]]));
//         });

//         return;
//       }
//     }

//     if (!board.contains('')) {
//       emit(state.copyWith(isDraw: true));
//     }
//   }
// }


// ////////////////////////////////////////////////////////////////////////////////

import 'dart:math';
import 'package:xo_game/models/bot/min_max.dart';
 // Assuming Minimax class is in this file

enum Difficulty { easy, medium, hard }

// Ensure you have the Minimax class

enum GameMode { playerVsPlayer, playerVsBotEasy, playerVsBotMedium, playerVsBotHard }

class GameCubit extends Cubit<GameState> {
  final GameMode gameMode;
  final Minimax minimax = Minimax(); // Create an instance of Minimax class
  Random random = Random();

  GameCubit({ this.gameMode=GameMode.playerVsBotHard}) : super(GameState.initial());

  void makeMove(int index) {
    if (state.board[index].isEmpty && state.winner == null && !state.isDraw) {
      final newBoard = List<String>.from(state.board);
      newBoard[index] = state.isXturn ? 'X' : 'O';

      final xMoves = state.isXturn ? List<int>.from(state.xMoves) : state.xMoves;
      if (state.isXturn) {
        xMoves.add(index);
      }

      final oMoves = !state.isXturn ? List<int>.from(state.oMoves) : state.oMoves;
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

      // If playing against a bot, let the bot make a move
      if (gameMode != GameMode.playerVsPlayer && !state.isXturn && state.winner == null && !state.isDraw) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _botMakeMove();
        });
      }
    }
  }

  // Bot makes its move based on the selected difficulty level
  void _botMakeMove() {
    int botMove;
    if (gameMode == GameMode.playerVsBotEasy) {
      botMove = _getRandomMove(); // Easy: Random move
    } else if (gameMode == GameMode.playerVsBotMedium) {
      botMove = _getMinimaxMove('O'); // Medium: Minimax playing as 'O'
    } else {
      botMove = _getMinimaxMove('X'); // Hard: Minimax playing as 'X'
    }

    // Make the bot's move
    makeMove(botMove);
  }

  // Easy mode: random available move
  int _getRandomMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < state.board.length; i++) {
      if (state.board[i].isEmpty) {
        availableMoves.add(i);
      }
    }
    return availableMoves[random.nextInt(availableMoves.length)];
  }

  // Minimax-based move (medium and hard)
  int _getMinimaxMove(String botSymbol) {
    List<List<String>> boardMatrix = [
      [state.board[0], state.board[1], state.board[2]],
      [state.board[3], state.board[4], state.board[5]],
      [state.board[6], state.board[7], state.board[8]]
    ];

    minimax.minimax(boardMatrix, 0, botSymbol == 'X', true); // Depth can be adjusted if needed

    // Convert the boardMatrix back to linear form and find the bot's move
    for (int i = 0; i < 9; i++) {
      if (state.board[i] != boardMatrix[i ~/ 3][i % 3]) {
        return i;
      }
    }

    return _getRandomMove(); // Fallback in case of unexpected failure
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
        Future.delayed(const Duration(milliseconds: 200), () {
          emit(state.copyWith(winner: board[combo[0]]));
        });
        return;
      }
    }

    if (!board.contains('')) {
      emit(state.copyWith(isDraw: true));
    }
  }
}
