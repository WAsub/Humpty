import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'costomWidget/customTextField.dart';
import 'theme/dynamic_theme.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,//横固定
  ]);
  //runApp
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
  double deviceHeight;
  double deviceWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  LayoutBuilder(builder: (context, constraints) {
        deviceHeight = constraints.maxHeight;
        deviceWidth = constraints.maxWidth;

        return Column(
          children: [
            Container(
              color: Colors.yellowAccent,
              alignment: Alignment.bottomCenter,
              height: deviceHeight * 0.2,
              child: Text("残高"),
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.amber,
              height: deviceHeight * 0.4,
              child: CustomTextField(
                width: deviceWidth * 0.85,
                height: 50,
                labelText: "ニックネーム",
                // focusNode: _namefocusNode,
                // controller: nameController,
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              color: Colors.yellow,
              height: deviceHeight * 0.4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text("入金",),
                    onPressed: () {
                    }
                  ),
                  TextButton(
                    child: Text("出金",),
                    onPressed: () {
                    }
                  )  
                ],
              ),
            )
          ],
        );

      })
    );
  }
}
