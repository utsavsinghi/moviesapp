import 'dart:math' show max;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowtimePicker extends StatefulWidget {
  final List<String> showtime;
  final String date;
  final Function(String) onSelected;

  const ShowtimePicker(
      {Key key, this.date, this.showtime = const <String>[], this.onSelected})
      : super(key: key);
  @override
  _ShowtimePickerState createState() => _ShowtimePickerState();
}

class _ShowtimePickerState extends State<ShowtimePicker>
    with TickerProviderStateMixin {
  AnimationController _controller;
  int selected;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    if (widget.date != null) _controller.forward();
  }

  @override
  void didUpdateWidget(ShowtimePicker oldWidget) {
    if (widget.date != null && widget.date != oldWidget.date) {
      selected = null;
      _controller.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: 160),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              var opacity = Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                      curve: Interval(0, 0.4, curve: Curves.easeOutCirc),
                      parent: _controller));
              return Opacity(opacity: opacity.value, child: child);
            },
            child: Text(
              'Select Time',
              style:
                  GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(padding: const EdgeInsets.only(top: 18.0)),
          Wrap(
            children: [
              for (var i = 0; i < widget.showtime.length; i++)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    var scale = Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                          curve: Interval(.1 * i, max(1, .4 + .1 * i),
                              curve: ElasticOutCurve(.8)),
                          parent: _controller),
                    );

                    return ScaleTransition(scale: scale, child: child);
                  },
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOutBack,
                    switchOutCurve: Curves.easeInCirc,
                    transitionBuilder: (Widget child, Animation animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: GestureDetector(
                      key: (i == selected) ? ValueKey('s$i') : ValueKey('u$i'),
                      onTap: () {
                        if (widget.onSelected != null)
                          widget.onSelected(widget.showtime[i]);
                        setState((() {
                          selected = i;
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 6.0),
                        child: Text(
                          widget.showtime[i],
                          style: GoogleFonts.nunito(
                              fontSize: 12.5,
                              color: (i == selected)
                                  ? Colors.white
                                  : Colors.black87),
                        ),
                        decoration: BoxDecoration(
                            color: (selected == i)
                                ? Colors.red[700]
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[200],
                                  spreadRadius: 1.0,
                                  blurRadius: 8.0)
                            ]),
                      ),
                    ),
                  ),
                )
            ],
            spacing: 8.0,
            runSpacing: 16.0,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
