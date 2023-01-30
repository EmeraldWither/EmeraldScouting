import 'package:flutter/material.dart';

class MaterialBox extends StatelessWidget {
  final Widget child;
  EdgeInsetsGeometry? padding;
  bool isExpanded;
  MaterialBox(
      {Key? key, required this.child, this.padding, this.isExpanded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    padding ??= const EdgeInsets.fromLTRB(16.0, 8, 16, 8);
    return Padding(
        padding: padding!,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              color: Colors.black12,
              child: child,
            )));
  }
}
