import 'package:flutter/material.dart';

class NumberWidget extends StatefulWidget {
  final int number;

  NumberWidget(this.number);

  @override
  _NumberWidgetState createState() => _NumberWidgetState();
}

class _NumberWidgetState extends State<NumberWidget> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animationController,
      child: Image.asset("images/${widget.number}.png"),
    );
  }
}
