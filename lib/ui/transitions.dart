import 'package:flutter/material.dart';

/// Custom Animated Builder which takes a list of widgets
/// as children instead of a single child.
/// Can Simplify a lot of complex animations.
class AnimatedChildrenBuilder extends AnimatedWidget {
  const AnimatedChildrenBuilder({
    Key key,
    @required Listenable animation,
    @required this.builder,
    this.children = const <Widget>[],
  })  : assert(animation != null),
        assert(builder != null),
        super(key: key, listenable: animation);

  final Widget Function(BuildContext context, List<Widget> children) builder;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return builder(context, children);
  }
}

class AnimatedMapChildBuilder extends AnimatedWidget {
  const AnimatedMapChildBuilder({
    Key key,
    @required Listenable animation,
    @required this.builder,
    this.children = const {},
  })  : assert(animation != null),
        assert(builder != null),
        super(key: key, listenable: animation);

  final Widget Function(BuildContext context, Map<String, Widget> children)
      builder;

  final Map<String, Widget> children;

  @override
  Widget build(BuildContext context) {
    return builder(context, children);
  }
}
