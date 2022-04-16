import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onPressed;
  const RoundedButtonWidget({
    this.buttonText,
    this.buttonColor,
    this.textColor = Colors.white,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: buttonColor,
      shape: StadiumBorder(),
      onPressed: onPressed,
      padding: EdgeInsets.all(12.0),
      child: Text(buttonText, style: TextStyle(color: Colors.white)),
    );
  }
}
