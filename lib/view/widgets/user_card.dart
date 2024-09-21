import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';
import 'package:xo_game/utilities.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    this.avatar,
    required this.userName,
    required this.symbol,
    required this.isActive, 
  });

  final String? avatar;
  final String userName, symbol;
  final bool isActive; 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 2.5,
      height: MediaQuery.sizeOf(context).height / 4,

      decoration: BoxDecoration(
        color: kDarkPurple,
        border: Border.all(
          color: isActive
              ? Colors.amber.shade200
              : Colors.amber, 
          width: isActive ? 4 : 1, 
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: Colors.purple.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null, 
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(kAvatar),
          ),
          Text(
            userName,
            style: const TextStyle(
                fontFamily: font,
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          symbolWidget(symbol,24),
        ],
      ),
    );
  }
}
