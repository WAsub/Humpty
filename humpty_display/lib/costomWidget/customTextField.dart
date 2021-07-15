import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget{
  final double height;
  final double width;
  EdgeInsets margin;
  Color backgroundColor = Colors.white;
  final FocusNode focusNode;
  final TextEditingController controller;
  String labelText;
  String hintText = "";
  double hintFontSize = 17;
  double fontSize = 17;
  TextAlign textAlign = TextAlign.right;
  bool obscureText = false;
  TextInputType keyboardType = TextInputType.visiblePassword;
  
  CustomTextField({
    this.height,
    this.width,
    this.margin,
    this.backgroundColor,
    this.focusNode,
    this.controller,
    this.labelText,
    this.hintText,
    this.hintFontSize,
    this.fontSize,
    this.textAlign,
    this.obscureText,
    this.keyboardType,
  });
  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}


class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    widget.margin = widget.margin == null ? EdgeInsets.only(top: 20) : widget.margin;
    widget.backgroundColor = widget.backgroundColor == null ? Colors.white : widget.backgroundColor;
    widget.obscureText = widget.obscureText == null ? false : widget.obscureText;

    return Container(
      alignment: Alignment.bottomLeft,
      height: 100,
      width: 797.3442,
        child: Stack(alignment: Alignment.center,fit: StackFit.expand,children: [
          Container(alignment: Alignment.bottomLeft,
            color: widget.backgroundColor,
            child: Text("¥",style: TextStyle(fontSize: 57.73),),
          ),
          Container(alignment: Alignment.bottomLeft,
            child:TextField(
              focusNode: widget.focusNode,
              controller: widget.controller,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor,),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87,),
                ),
              ),
              style: TextStyle(fontSize: widget.fontSize,),
              textAlign: TextAlign.right,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
            ),
          )
        ],)
    );
  }
}