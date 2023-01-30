import 'package:flutter/material.dart';

class CheckboxButton extends StatelessWidget {
  final Checkbox checkbox;

  final Widget widget;

  const CheckboxButton({Key? key, required this.checkbox, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        checkbox,
        GestureDetector(
          behavior: HitTestBehavior.translucent,
            onTap: () {
              checkbox.onChanged!(!(checkbox.value as bool));
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
              child: widget,
            )),
      ],
    );
  }
}
