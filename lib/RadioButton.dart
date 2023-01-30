import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  final Radio radio;

  final Widget widget;

  const RadioButton({Key? key, required this.radio, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        radio,
        widget,
      ],
    );
  }
}
