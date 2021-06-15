// import 'package:flutter/material.dart';

// class SwipeContainer extends StatelessWidget{
//   final Widget child;
//   SwipeContainer({
//     this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedPositioned(
//         duration: Duration(milliseconds: 200),
//         top: deviceHeight + swipH,
//         child: GestureDetector(
//           onVerticalDragUpdate: (DragUpdateDetails details) {
//             setState(() {
//               if (details.delta.dy < -10) {
//                 var dy = deviceHeight / 5 * 4.5;
//                 swipH = dy - dy - dy;
//               }
//               if (details.delta.dy > 10) {
//                 swipH = -100;
//               }
//             });
//           },
//           /** 履歴画面 */
//           child: child
//           ),
//     );
//   }
// }