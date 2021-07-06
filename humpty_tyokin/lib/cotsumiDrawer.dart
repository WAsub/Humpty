import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:humpty_tyokin/costomWidget/cotsumi_icons_icons.dart';
import 'package:humpty_tyokin/goalHistory.dart';
import 'package:humpty_tyokin/settingAccount.dart';

class CotsumiDrawer extends StatelessWidget {
  String userName;

  CotsumiDrawer({
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    userName = userName == null ? "non" : userName;
    List<Widget> leadingIcon = [
      Icon(Icons.radio_button_off),
      Icon(CotsumiIcons.osiraseicon),
      Icon(CotsumiIcons.group),
      Icon(CotsumiIcons.group),
    ];
    List<Widget> titleText = [
      Text(this.userName),
      Text("お知らせ"),
      Text("アカウント設定"),
      Text("達成履歴"),
    ];
    var onTap = [
      null,
      null,
      SettingAccount(),
      GoalHistory(),
    ];
    return Drawer(
      child: ListView.builder(
        itemCount: leadingIcon.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Container(
                // color: Colors.blue,
                alignment: Alignment.bottomRight,
                child: ListTile(
                  leading: leadingIcon[index], // 左のアイコン
                  title: titleText[index], // テキスト
                  onTap: () {},
                ),
              ),
            );
          } else {
            return ListTile(
              leading: leadingIcon[index], // 左のアイコン
              title: titleText[index], // テキスト
              onTap: () {
                if (onTap[index] != null)
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      // ログイン画面へ
                      return onTap[index];
                    }),
                  ).then((value) async {
                    // reload();
                  });
              },
            );
          }
        },
      ),
    );
  }
}
