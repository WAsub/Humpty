import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget{
  final double height;
  final double width;
  EdgeInsets margin;
  Color backgroundColor = Colors.white;
  final FocusNode focusNode;
  final TextEditingController controller;
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
    if(widget.margin == null){
      widget.margin = EdgeInsets.only(top: 20);
    }
    if(widget.backgroundColor == null){
      widget.backgroundColor = Colors.white;
    }
    if(widget.obscureText == null){
      widget.obscureText = false;
    }

    return Container(
      alignment: Alignment.center,
      height: widget.height,
      width: widget.width,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(4),),
      child:TextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        decoration: new InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: widget.hintFontSize,),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide()
          ),
        ),
        style: TextStyle(fontSize: widget.fontSize,),
        textAlign: TextAlign.right,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
      ),
    );
  }
}