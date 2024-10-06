class Minimax {
  List<String> board;
  String? currentWinner;
  String botSymbol; // Bot's symbol, can be 'X' or 'O'

  Minimax({required this.botSymbol}) 
      : board = List.filled(9, ' '), currentWinner = null;

  // Make a move on the board
  bool makeMove(int square, String letter) {
    if (board[square] == ' ') {
      board[square] = letter;
      if (winner(square, letter)) {
        currentWinner = letter;
      }
      return true;
    }
    return false;
  }

  // Check if the player has won
  bool winner(int square, String letter) {
    int row = square ~/ 3;
    List<String> rowArr = board.sublist(row * 3, (row + 1) * 3);
    if (rowArr.every((s) => s == letter)) {
      return true;
    }

    int col = square % 3;
    List<String> colArr = [board[col], board[col + 3], board[col + 6]];
    if (colArr.every((s) => s == letter)) {
      return true;
    }

    if (square % 2 == 0) {
      List<String> diagonal1 = [board[0], board[4], board[8]];
      if (diagonal1.every((s) => s == letter)) {
        return true;
      }

      List<String> diagonal2 = [board[2], board[4], board[6]];
      if (diagonal2.every((s) => s == letter)) {
        return true;
      }
    }

    return false;
  }

  // Return available moves
  List<int> availableMoves() {
    return [for (int i = 0; i < board.length; i++) if (board[i] == ' ') i];
  }

  // Check if the board has empty squares
  bool emptySquares() {
    return board.contains(' ');
  }

  // Minimax algorithm implementation
  Map<String, dynamic> minimax(String player) {
    String otherPlayer = player == 'X' ? 'O' : 'X';

    // Check if the other player has won
    if (currentWinner == otherPlayer) {
      return {
        'position': null,
        'score': (otherPlayer == botSymbol ? 1 : -1) * (availableMoves().length + 1)
      };
    } else if (!emptySquares()) {
      return {'position': null, 'score': 0};
    }

    Map<String, dynamic> best = (player == botSymbol)
        ? {'position': null, 'score': -double.infinity}
        : {'position': null, 'score': double.infinity};

    for (int move in availableMoves()) {
      board[move] = player;
      Map<String, dynamic> simScore = minimax(otherPlayer);

      board[move] = ' ';
      currentWinner = null;
      simScore['position'] = move;

      if (player == botSymbol) {
        if (simScore['score'] > best['score']) {
          best = simScore;
        }
      } else {
        if (simScore['score'] < best['score']) {
          best = simScore;
        }
      }
    }
    return best;
  }
}
