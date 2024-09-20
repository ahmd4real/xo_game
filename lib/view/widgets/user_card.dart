import 'package:flutter/material.dart';
import 'package:xo_game/constants.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    this.avatar,
    required this.userName,
    required this.symbol,
    required this.isActive, // Add this property
  });

  final String? avatar;
  final String userName, symbol;
  final bool isActive; // Indicates if it's the current user's turn

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
              : Colors.amber, // Change color based on isActive
          width: isActive ? 4 : 2, // Thicker border if active
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // Add a shadow effect when active
                ),
              ]
            : null, // No shadow if not active
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
            
            style: const TextStyle(color: Colors.amber,fontSize: 18,fontWeight: FontWeight.w600),
          ),
          Text(
            symbol,
            style: const TextStyle(color: Colors.amber),
          ),
        ],
      ),
    );
  }
}
