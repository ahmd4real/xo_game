// import 'package:flutter/material.dart';
// import 'package:xo_game/constants.dart';
// import 'package:xo_game/utilities.dart';

// class UserCard extends StatelessWidget {
//   const UserCard(
//       {super.key,
//       this.avatar,
//       required this.userName,
//       required this.symbol,
//       required this.isActive,
//       this.onlineMode = false,
//       this.botMode = false});

//   final String? avatar;
//   final String userName, symbol;
//   final bool isActive, onlineMode, botMode;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.sizeOf(context).width / 2.5,
//       height: MediaQuery.sizeOf(context).height / 4,
//       decoration: BoxDecoration(
//         color: kDarkPurple,
//         border: Border.all(
//           color: isActive ? Colors.amber.shade200 : Colors.amber,
//           width: isActive ? 4 : 1,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: isActive
//             ? [
//                 BoxShadow(
//                   color: Colors.amber.withOpacity(0.5),
//                   spreadRadius: 4,
//                   blurRadius: 10,
//                   offset: const Offset(0, 3),
//                 ),
//                 BoxShadow(
//                   color: Colors.purple.withOpacity(0.5),
//                   spreadRadius: 3,
//                   blurRadius: 10,
//                   offset: const Offset(0, 3),
//                 ),
//               ]
//             : null,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Container(
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.amber, width: 2),
//                   color: Colors.amber),
//               height: MediaQuery.of(context).size.width / 4,
//               width: MediaQuery.of(context).size.width / 4,
//               child: avatar != null && avatar!.isNotEmpty
//                   ? onlineMode
//                       ? CircleAvatar(
//                           backgroundImage: Image.network(
//                             'https://xogame.runasp.net/${avatar!}',
//                           ).image,
//                         )
//                       : Image.asset(kAvatar)
//                   : botMode
//                       ? userName == 'You'
//                           ? CircleAvatar(
//                               backgroundImage: Image.network(
//                                 'https://xogame.runasp.net/${avatar!}',
//                               ).image,
//                             )
//                           : Image.asset(avatar!)
//                       : Image.asset(kAvatar)),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Text(
//               userName,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                   fontFamily: font,
//                   color: Colors.amber,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600),
//             ),
//           ),
//           symbolWidget(symbol, 32),
//         ],
//       ),
//     );
//   }
// }


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
    this.onlineMode = false,
    this.botMode = false,
  });

  final String? avatar;
  final String userName, symbol;
  final bool isActive, onlineMode, botMode;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final avatarSize = size.width / 4;

    return Container(
      width: size.width / 2.5,
      height: size.height / 4,
      decoration: BoxDecoration(
        color: kDarkPurple,
        border: Border.all(
          color: isActive ? Colors.amber.shade200 : Colors.amber,
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
          _buildAvatar(avatarSize),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              userName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: font,
                color: Colors.amber,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          symbolWidget(symbol, 32),
        ],
      ),
    );
  }

  Widget _buildAvatar(double size) {
    if (avatar != null && avatar!.isNotEmpty) {
      if (onlineMode || (botMode && userName == 'You')) {
        return CircleAvatar(
          backgroundColor: Colors.amber,
          radius: size / 2,
          backgroundImage: NetworkImage(
            'https://xogame.runasp.net/${avatar!}',
          ),
          onBackgroundImageError: (_, __) => const Icon(Icons.error, color: Colors.red),
        );
      } else {
        return CircleAvatar(
          radius: size / 2,
          backgroundImage: AssetImage(avatar!),
          backgroundColor: Colors.amber,
        );
      }
    } else {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: const AssetImage(kAvatar),
        backgroundColor: Colors.amber,
      );
    }
  }
}
