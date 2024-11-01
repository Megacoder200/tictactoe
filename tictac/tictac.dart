import 'dart:io';
import 'dart:math';

void main() {
  choosing();
}

List<String> square_num = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

int movement = 0;
bool winner = false;
bool x_turn = true;

void drawborders() {
  print(" --- --- ---");
  print("| ${square_num[0]} | ${square_num[1]} | ${square_num[2]} |");
  print("|---|---|---|");
  print("| ${square_num[3]} | ${square_num[4]} | ${square_num[5]} |");
  print("|---|---|---|");
  print("| ${square_num[6]} | ${square_num[7]} | ${square_num[8]} |");
  print("|---|---|---|");
}

void get_X_or_O() {
  print("Choose the number you want to play in its square player ${x_turn ? 'X' : 'O'} (or type 'exit' to end): ");
  String? input = stdin.readLineSync();

  if (input == "exit") {
    print("Thank you, sir, for using our game!");
    exit(0);
  }

  try {
    int square_index = int.parse(input!);
    if (square_index >= 1 && square_index <= 9) {
      if (square_num[square_index - 1] != 'X' && square_num[square_index - 1] != 'O') {
        square_num[square_index - 1] = x_turn ? 'X' : 'O';
        x_turn = !x_turn;
        movement++;
      } else {
        print("This square is already taken, please try again.");
      }
    } else {
      print("Please enter a number between 1 and 9.");
    }
  } catch (e) {
    print("Invalid input. Please enter a valid number.");
  }
}

void check_winner() {
  List<List<int>> winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  for (var combination in winningCombinations) {
    if (square_num[combination[0]] == square_num[combination[1]] &&
        square_num[combination[1]] == square_num[combination[2]]) {
      winner = true;
      print("Player ${square_num[combination[0]]} wins!");
      return;
    }
  }

  if (movement == 9 && !winner) {
    print("It's a draw!");
    winner = true;
  }
}

void rematch() {
  print("Would you like a rematch? (yes/no)");
  String? response = stdin.readLineSync();
  if (response?.toLowerCase() == "yes") {
    square_num = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    movement = 0;
    winner = false;
    x_turn = true;
    choosing();
  } else {
    print("Thank you, sir, for using our game!");
    exit(0);
  }
}

void playing() {
  drawborders();
  while (!winner) {
    get_X_or_O();
    check_winner();
    drawborders();
  }
  rematch();
}

void beginner_move() {
  for (int i = 0; i < square_num.length; i++) {
    if (square_num[i] != 'X' && square_num[i] != 'O') {
      print("The Computer plays in square number => ${i + 1}");
      square_num[i] = 'O';
      x_turn = !x_turn;
      movement++;
      break;
    }
  }
}

void beginner_level() {
  drawborders();
  while (!winner) {
    if (x_turn) {
      get_X_or_O();
    } else {
      beginner_move();
    }
    check_winner();
    drawborders();
  }
  rematch();
}

void hard_level() {
  drawborders();
  while (!winner) {
    if (x_turn) {
      get_X_or_O();
    } else {
      hard_move();
    }
    check_winner();
    drawborders();
  }
  rematch();
}

void choosing() {
  print("HELLO SIR, THIS IS TIC TAC TOE\nFOR TWO-PLAYER MODE PRESS 1\nFOR VS COMPUTER MODE PRESS 2");
  String? modeInput = stdin.readLineSync();
  if (modeInput == "exit") {
    print("Thank you, sir, for using our game!");
    exit(0);
  }
  
  try {
    int mood_num = int.parse(modeInput!);
    switch (mood_num) {
      case 1:
        playing();
        break;
      case 2:
        print("For easy mode press 1\nFor hard mode press 2");
        String? levelInput = stdin.readLineSync();
        if (levelInput == "exit") {
          print("Thank you, sir, for using our game!");
          exit(0);
        }
        
        int level_num = int.parse(levelInput!);
        switch (level_num) {
          case 1:
            beginner_level();
            break;
          case 2:
            hard_level();
            break;
        }
        break;
      default:
        print("Invalid choice. Please start over.");
        choosing();
    }
  } catch (e) {
    print("Invalid input. Please enter a number.");
    choosing();
  }
}

int hard_check_winner(List<String> board) {
  List<List<int>> winningCombos = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  for (var combo in winningCombos) {
    if (board[combo[0]] == board[combo[1]] && board[combo[1]] == board[combo[2]]) {
      return board[combo[0]] == 'O' ? 10 : -10;
    }
  }
  return 0;
}

bool isFull(List<String> board) {
  return board.every((element) => element == 'X' || element == 'O');
}

int minimax(List<String> board, bool isMaximizing) {
  int score = hard_check_winner(board);
  if (score != 0) return score;
  if (isFull(board)) return 0;

  if (isMaximizing) {
    int bestScore = -1000;
    for (int i = 0; i < 9; i++) {
      if (board[i] != 'X' && board[i] != 'O') {
        board[i] = 'O';
        bestScore = max(bestScore, minimax(board, false));
        board[i] = (i + 1).toString();
      }
    }
    return bestScore;
  } else {
    int bestScore = 1000;
    for (int i = 0; i < 9; i++) {
      if (board[i] != 'X' && board[i] != 'O') {
        board[i] = 'X';
        bestScore = min(bestScore, minimax(board, true));
        board[i] = (i + 1).toString();
      }
    }
    return bestScore;
  }
}

void hard_move() {
  int bestMove = -1;
  int bestScore = -1000;

  for (int i = 0; i < 9; i++) {
    if (square_num[i] != 'X' && square_num[i] != 'O') {
      square_num[i] = 'O';
      int moveScore = minimax(square_num, false);
      square_num[i] = (i + 1).toString();

      if (moveScore > bestScore) {
        bestMove = i;
        bestScore = moveScore;
      }
    }
  }

  square_num[bestMove] = 'O';
  movement++;
  x_turn = !x_turn;
  print("The computer played in square number ${bestMove + 1}");
}
