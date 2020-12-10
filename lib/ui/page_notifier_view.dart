import 'package:flutter/material.dart';

class PageNotifierView extends StatefulWidget {
  final ValueNotifier<double> notifier;
  final Axis scrollDirection;
  final bool reverse;
  final PageController controller;
  final List<Widget> children;
  final ScrollPhysics physics;
  final bool pageSnapping;
  final ValueChanged<int> onPageChanged;

  PageNotifierView({
    Key key,
    @required this.controller,
    @required this.notifier,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.children = const <Widget>[],
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
  }) : super(key: key);

  @override
  _PageNotifierViewState createState() => _PageNotifierViewState();
}

class _PageNotifierViewState extends State<PageNotifierView> {
  _onScroll() {
    widget.notifier?.value = widget.controller.page;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      key: UniqueKey(),
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      children: widget.children,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      onPageChanged: widget.onPageChanged,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }
}
