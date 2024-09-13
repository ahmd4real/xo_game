// import 'package:flutter/material.dart';
// import 'package:xo_game/view/widgets/board_sq.dart';

// class Board extends StatefulWidget {
//   const Board({super.key});
  
//   @override
//   State<Board> createState() => _BoardState();
// }

// class _BoardState extends State<Board> {
//   String symbol = '';
//   bool isXturn = true;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//          children: [
//            Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               BoardSq(
//                 left: false,
//                 top: false,
//                 onTap: () {
//                   setState(() {
//                     symbol = isXturn ? 'X' : 'O';
//                     isXturn = !isXturn;
//                   });
//                 },
//               ),
//               BoardSq(
//                 top: false,
//               ),
//               BoardSq(
//                 top: false,
//                 right: false,
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               for (int i = 0; i < 3; i++) BoardSq(
//                 left: i == 0 ? false : true,
//                 right: i==2?false:true,
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               BoardSq(
//                 left: false,
//                 bottom: false,
//               ),
//               BoardSq(
//                 bottom: false,
//               ),
//               BoardSq(
//                 bottom: false,
//                 right: false,
//               ),
//             ],
//           ),
//          ],
//     );
//   }
// }