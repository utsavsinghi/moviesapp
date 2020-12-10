import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekDatePicker extends StatefulWidget {
  final List<String> days;
  final List<String> dates;
  final Animation controller;
  final Function(String) onSelected;

  WeekDatePicker({
    @required this.days,
    @required this.dates,
    this.controller,
    this.onSelected,
  })  : assert(days.length == dates.length),
        assert(days.length == 7);

  @override
  _WeekDatePickerState createState() => _WeekDatePickerState();
}

class _WeekDatePickerState extends State<WeekDatePicker>
    with TickerProviderStateMixin {
  int selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        curve: Interval(0.72, 0.94, curve: Curves.easeInOut),
                        parent: widget.controller)),
                child: child,
              );
            },
            child: Row(
              children: [
                for (var i = 0; i < widget.days.length; i++)
                  Text(
                    widget.days[i],
                    style: GoogleFonts.nunito(),
                  ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            children: [
              for (var i = 0; i < widget.days.length; i++)
                GestureDetector(
                  onTap: () {
                    if (i != selected) setState(() => selected = i);
                    if (widget.onSelected != null)
                      widget.onSelected(widget.dates[i]);
                  },
                  child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, child) {
                      var opacity = Tween<double>(begin: 0.0, end: 1.0)
                          .animate(CurvedAnimation(
                        curve: Interval(0.72, 0.94 + i * 0.01,
                            curve: Curves.easeIn),
                        parent: widget.controller,
                      ));

                      var scale = Tween<double>(begin: 0.0, end: 1.0)
                          .animate(CurvedAnimation(
                        curve: Interval(0.72, 0.94 + i * 0.01,
                            curve: Curves.easeOutQuad),
                        parent: widget.controller,
                      ));

                      return FadeTransition(
                        opacity: opacity,
                        child:
                            Transform.scale(scale: scale.value, child: child),
                      );
                    },
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOutBack,
                      switchOutCurve: Curves.easeInOutBack,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Container(
                        key: (i == selected)
                            ? ValueKey('${widget.dates[i]}s')
                            : ValueKey('${widget.dates[i]}u'),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (i == selected)
                                ? Colors.red[700]
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: 4.0,
                                spreadRadius: 2.0,
                                offset: Offset(1.0, 1.0),
                              )
                            ]),
                        child: Text(
                          widget.dates[i],
                          style: GoogleFonts.nunito(
                            fontSize: 15.0,
                            color:
                                (i == selected) ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
