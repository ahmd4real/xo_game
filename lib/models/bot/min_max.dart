class Minimax {
  // Check if the three values are the same and not empty
  bool haveTheSameValueAndNotEmpty(String x, String y, String z) {
    return x == y && x == z && x != ' ';
  }

  // Check the winner on the board
  int checkWinner(List<List<String>> board) {
    // 2: X winner
    // -2: O winner
    // 0: Tie
    // 1: No winner

    // Check rows
    for (int i = 0; i < 3; i++) {
      if (haveTheSameValueAndNotEmpty(board[i][0], board[i][1], board[i][2])) {
        return board[i][0] == 'X' ? 2 : -2;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (haveTheSameValueAndNotEmpty(board[0][i], board[1][i], board[2][i])) {
        return board[0][i] == 'X' ? 2 : -2;
      }
    }

    // Check diagonals
    if (haveTheSameValueAndNotEmpty(board[0][0], board[1][1], board[2][2])) {
      return board[0][0] == 'X' ? 2 : -2;
    }

    if (haveTheSameValueAndNotEmpty(board[2][0], board[1][1], board[0][2])) {
      return board[2][0] == 'X' ? 2 : -2;
    }

    // Check for tie
    bool tie = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == ' ') {
          tie = false;
          break;
        }
      }
    }

    if (tie) return 0;

    // No winner yet
    return 1;
  }

  // Minimax algorithm
  int minimax(List<List<String>> board, int depth, bool isMaximizing, bool firstTime) {
    int result = checkWinner(board);
    if (result != 1 || depth == 0) return result;

    if (isMaximizing) {
      int finalScore = -10;
      int finalI = 0, finalJ = 0;

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == ' ') {
            board[i][j] = 'X';
            int score = minimax(board, depth - 1, false, false);
            board[i][j] = ' ';
            if (score > finalScore) {
              finalScore = score;
              finalI = i;
              finalJ = j;
            }
          }
        }
      }
      if (firstTime) {
        board[finalI][finalJ] = 'O';
      }
      return finalScore;
    } else {
      int finalScore = 10;
      int finalI = 0, finalJ = 0;

      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == ' ') {
            board[i][j] = 'O';
            int score = minimax(board, depth - 1, true, false);
            board[i][j] = ' ';
            if (score < finalScore) {
              finalScore = score;
              finalI = i;
              finalJ = j;
            }
          }
        }
      }
      if (firstTime) {
        board[finalI][finalJ] = 'O';
      }
      return finalScore;
    }
  }

  // To print the board (for debugging purposes)
  void drawBoard(List<List<String>> board) {
    for (var row in board) {
      print(row.map((e) => "| $e |").join(' '));
      print("\n----------------------\n");
    }
  }
}
