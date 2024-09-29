import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/utilities.dart';

class BoardSq extends StatelessWidget {
  final String symbol;
  final VoidCallback onTap;
  final bool left, right, top, bottom;

  const BoardSq({
    super.key,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.top = true,
    required this.symbol,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: symbol.isEmpty ? onTap : null,
      child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border(
              bottom: bottom
                  ? BorderSide(color: kOrange, width: 2)
                  : BorderSide.none,
              left:
                  left ? BorderSide(color: kOrange, width: 2) : BorderSide.none,
              right: right
                  ? BorderSide(color: kOrange, width: 2)
                  : BorderSide.none,
              top: top ? BorderSide(color: kOrange, width: 2) : BorderSide.none,
            ),
          ),
          child: symbolWidget(symbol, 70)),
    );
  }
}
