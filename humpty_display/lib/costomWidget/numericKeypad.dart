// import 'package:flutter/material.dart';
// import "dart:async";

// class NumericKeypad extends StatefulWidget {
//   int crossAxisCount = 3;
//   double axisSpacing = 4.0;
//   NumericKeypad({
//     Key key,
//     this.crossAxisCount,
//     this.axisSpacing,
//   }) : super(key: key);

//   @override
//   NumericKeypadState createState() => NumericKeypadState();
// }
// class NumericKeypadState extends State<NumericKeypad> {
//   /** グリッドビューの高さ */
//   double wigetHeight;
//   /** グリッドアイテムの大きさ */
//   double gredSize;
//   /** アイテムのPosition */
//   List<Offset> fixedPosition = [];
//   /** previewに必要なあれこれ */
//   bool flg = true;
//   Offset startPosition = Offset(0.0,0.0);
//   double top = 0;
//   double left = 0;
//   Color previewItemColor = Colors.transparent;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       gredSize = (constraints.maxWidth - widget.axisSpacing * (widget.crossAxisCount - 1)) / 3;
//       /** 余裕をもってスクロールできるように設定 */
//       wigetHeight = ((widget.children.length ~/ widget.crossAxisCount * gredSize) + widget.children.length ~/ widget.crossAxisCount * widget.axisSpacing) + gredSize*2;
//       /** 各アイテムのPositionを設定
//        ** SetState時に入れ替えが起こるとうまく動かないので増分だけ追加  */
//       if(fixedPosition.length < widget.children.length){
//         for(int index = 0; index < widget.children.length; index++){
//           fixedPosition.add(Offset(
//             (index % widget.crossAxisCount * gredSize) + index % widget.crossAxisCount * widget.axisSpacing,
//             (index ~/ widget.crossAxisCount * gredSize) + index ~/ widget.crossAxisCount * widget.axisSpacing
//           ));
//         }
//       }
//       /** グリッドビュー */
//       return SingleChildScrollView(
//         child: Container(
//           height: wigetHeight,
//           /** プレビュー用アイテムが一番上にするためStackを二重にする */
//           child: Stack(children: [
//             /** アイテム */
//             Stack(children: List.generate(widget.children.length, (index) {
//               return Positioned(
//                 top: fixedPosition[index].dy,
//                 left: fixedPosition[index].dx,
//                 child:GestureDetector(
//                   onLongPress: () {
//                     /** 空のアイテムの時は後の入れ替え処理をしないようにする */
//                     if (widget.children[index] == null) {
//                       setState(() => flg = false);
//                     }
//                   },
//                   onLongPressStart: (LongPressStartDetails details){
//                     setState(() {
//                       startPosition = details.localPosition;
//                       top = fixedPosition[index].dy + details.localPosition.dy - startPosition.dy;
//                       left = fixedPosition[index].dx + details.localPosition.dx - startPosition.dx;
//                       previewItemColor = Colors.black.withOpacity(0.5);
//                     });
//                   },
//                   onLongPressMoveUpdate: (LongPressMoveUpdateDetails details){
//                     setState(() {
//                       top = fixedPosition[index].dy + details.localPosition.dy - startPosition.dy;
//                       left = fixedPosition[index].dx + details.localPosition.dx - startPosition.dx;
//                     });
//                   },
//                   onLongPressEnd: (LongPressEndDetails details) async {
//                     /** アイテムが空じゃなかったら入れ替え */
//                     if (flg) {
//                       /** スタート時からの差分 */
//                       double dx = details.localPosition.dx;
//                       double dy = details.localPosition.dy;
//                       /** なんかマイナスの時は+gredSizeされるっぽいので補正 */
//                       dx -= dx < 0 ? gredSize : 0;
//                       dy -= dy < 0 ? gredSize : 0;
//                       /** 移動先index算出 */
//                       int moved = 3 * (dy ~/ gredSize) + (dx ~/ gredSize); //差分
//                       moved += index; // 移動先index
//                       setState(() {
//                         previewItemColor = Colors.transparent;
//                         /** アイテム配列サイズを超えるならnullを入れて拡張 */
//                         if (moved >= widget.children.length) {
//                           for (int i = widget.children.length; i <= moved; i++) {
//                             widget.children.add(null);
//                             fixedPosition = listAddAt(fixedPosition, i, (i ~/ widget.crossAxisCount * gredSize) + i ~/ widget.crossAxisCount * widget.axisSpacing);
//                             fixedPosition = listAddAt(fixedPosition, i, (i % widget.crossAxisCount * gredSize) + i % widget.crossAxisCount * widget.axisSpacing);
//                           }
//                         }
//                         /** 入れ替え */
//                         var a = widget.children[moved];
//                         widget.children[moved] = widget.children[index];
//                         widget.children[index] = a;
//                         widget.children = endNullDelete(widget.children);
//                       });
//                     }
//                   },
//                   /**  */
//                   child: Container(
//                     width: gredSize,
//                     height: gredSize,
//                     child: widget.children[index]
//                   ),
//                 )
//               );
//             }),),
//             /** プレビュー用アイテム */
//             Positioned(
//               top: top,
//               left: left,
//               child: Container(color:previewItemColor,height: gredSize,width: gredSize,),
//             ),
//           ]),
//         )
//       );
//     });
//   }

//   List<dynamic> listAddAt(List<dynamic> list, int index, dynamic item){
//     /** アイテム配列サイズを超えるならnullを入れて拡張 */
//     if (index >= list.length) {
//       for (int i = list.length; i <= index; i++) {
//         list.add(null);
//       }
//     }
//     list[index] = item;
//     return list;
//   }
//   List<dynamic> endNullDelete(List<dynamic> list) {
//     /** 末尾のnullを削除 */
//     for (int i = list.length - 1; i >= 0; i--) {
//       if (list[i] != null) {
//         break;
//       }
//       list.removeAt(i);
//     }
//     return list;
//   }
// }