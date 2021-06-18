import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
 
  // CreateAccount({Key key,}) : super(key: key);
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: _willPopCallback,
      child:
    
    Scaffold(
          // appBar: AppBar(
          //   title: Text('こつみ cotsumi'),
            
          // ),
          /******************************************************* AppBar*/
          
          /******************************************************* Drawer*/
          body: Stack(children: [
              Container(
child: IconButton(icon: Icon(Icons.ac_unit_outlined),
onPressed: (){
  Navigator.pop(context, '戻ります');
},),
          )
          ],)
          
    ));
  }
   Future<bool> _willPopCallback() async {
    return false;
  }
}