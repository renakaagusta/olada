import 'package:flutter/material.dart';
import 'package:olada/constants/colors.dart';

class TextFieldWidget extends StatelessWidget {
  IconData icon;
  String hint;
  String errorText;
  bool isObscure;
  bool isIcon;
  TextInputType inputType;
  TextEditingController textController;
  EdgeInsets padding;
  Color hintColor;
  Color iconColor;
  FocusNode focusNode;
  ValueChanged onFieldSubmitted;
  ValueChanged onChanged;
  bool autoFocus;
  bool enabled;
  TextInputAction inputAction;
  int maxLines;
  int minLines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
          controller: textController,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          autofocus: autoFocus,
          textInputAction: inputAction,
          obscureText: this.isObscure,
          maxLines: maxLines,
          minLines: minLines,
          enabled: enabled,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            hintText: this.hint,
            fillColor: Colors.white,
            enabledBorder: new UnderlineInputBorder(
                borderRadius: new BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: new UnderlineInputBorder(
                borderRadius: new BorderRadius.circular(20.0),
                borderSide: BorderSide(color: AppColors.PrimaryColor, width: 2)),
          )),
    );
  }

  TextFieldWidget({
    this.icon,
    this.errorText,
    this.textController,
    this.inputType,
    this.hint,
    this.isObscure = false,
    this.isIcon = true,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
    this.maxLines = 1,
    this.minLines = 1,
    this.enabled = true
  });
}
