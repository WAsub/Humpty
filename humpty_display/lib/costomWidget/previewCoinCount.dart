import 'package:flutter/material.dart';

import 'previewCount.dart';

class PreviewCoinCount extends StatefulWidget {
  Map<int,int> counts;
  double axisSpacing;
  Function(Map<int,int>) callback;
  PreviewCoinCount({
    Key key, 
    this.counts, 
    this.axisSpacing = 0.0, 
    this.callback
  }) : super(key: key);

  @override
  PreviewCoinCountState createState() => PreviewCoinCountState();
}

class PreviewCoinCountState extends State<PreviewCoinCount> {
  /** コインアイテム */
  final List<int> coin = [500, 100, 50, 10, 5, 1];
  /** 列の数(固定値) */
  final int crossAxisCount = 3;
  /** グリッドアイテムの大きさ */
  Offset gredSize;
  /** アイテムのPosition */
  List<Offset> fixedPosition = [];

  @override
  Widget build(BuildContext context) {
    /** 枚数集計のデフォルト */
    if (widget.counts == null) {
      widget.counts = {500: 0, 100: 0, 50: 0, 10: 0, 5: 0, 1: 0};
    }

    return LayoutBuilder(builder: (context, constraints) {
      gredSize = Offset(
        (constraints.maxWidth - widget.axisSpacing * (crossAxisCount - 1)) / crossAxisCount, 
        ((constraints.maxWidth - widget.axisSpacing * (crossAxisCount - 1)) / crossAxisCount) / 5 * 3
      );
      /** 各アイテムのPositionを設定 */
      fixedPosition = [];
      for (int index = 0; index < coin.length; index++) {
        fixedPosition.add(Offset(
          (index % crossAxisCount * gredSize.dx) + index % crossAxisCount * widget.axisSpacing, 
          (index ~/ crossAxisCount * gredSize.dy) + index ~/ crossAxisCount * widget.axisSpacing)
        );
      }
      /** グリッドビュー */
      return Container(
        child: Stack(
          children: List.generate(coin.length, (index) {
            return Positioned(
                top: fixedPosition[index].dy,
                left: fixedPosition[index].dx,
                child: PreviewCount(
                  width: gredSize.dx,
                  data: coin[index],
                  count: widget.counts[coin[index]],
                  // callback: (data, count) {
                  //   counts[data] = count;
                  //   print("CustomCoinCount::$data:$count");
                  //   widget.callback(counts);
                  // },
                ));
          }),
        ),
      );
    });
  }
}
