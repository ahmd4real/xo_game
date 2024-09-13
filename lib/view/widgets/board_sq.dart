import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class BoardSq extends StatefulWidget {
  BoardSq(
      {this.bottom = true,
      this.left = true,
      this.right = true,
      this.top = true,
      super.key});
  bool left, right, top, bottom;

  @override
  State<BoardSq> createState() => _BoardSqState();
}

class _BoardSqState extends State<BoardSq> {
  String symbol = '';
  bool isXturn = true;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            symbol = isXturn ? 'X' : 'O';
            isXturn = !isXturn;
          });
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border(
              bottom: widget.bottom
                  ? BorderSide(color: kOrange, width: 1)
                  : BorderSide.none,
              left: widget.left
                  ? BorderSide(color: kOrange, width: 1)
                  : BorderSide.none,
              right: widget.right
                  ? BorderSide(color: kOrange, width: 1)
                  : BorderSide.none,
              top: widget.top
                  ? BorderSide(color: kOrange, width: 1)
                  : BorderSide.none,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(),
            child: Center(
              child: Text(
                symbol,
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }
}
