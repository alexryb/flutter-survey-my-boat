import 'package:flutter/cupertino.dart';

abstract class GenericPageState<T> extends State with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1500));
    _animation = new Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn));
    _animation?.addListener(() => setState(() {}));
    _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}