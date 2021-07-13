import 'package:flutter/material.dart';

import 'theme/dynamic_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          theme: theme,
          home: CotsumiDisplay(),
        );
      },
    );
  }
}

class CotsumiDisplay extends StatefulWidget {
  CotsumiDisplay({Key key,}) : super(key: key);
  @override
  _CotsumiDisplayState createState() => _CotsumiDisplayState();
}

class _CotsumiDisplayState extends State<CotsumiDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(child: Text("残高"),),
          Container(child: TextField(),),
          Container(
            child: Row(children: [
              FlatButton(
                  height: 29.124,
                  minWidth: 100,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 空白がなくなる
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    
                    Text(
                      "現在高",
                    ),
                  ]),
                  shape: StadiumBorder(),
                  onPressed: () {
                    
                    }
                    )
                  
            ],),
          )
        ],
      ),
    );
  }
}
