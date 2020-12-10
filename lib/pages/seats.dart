import 'dart:math' show min;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/assets.dart';
import 'package:movies/models/seats.dart';
import 'package:provider/provider.dart';

class SeatsPage extends StatefulWidget {
  static Route<dynamic> route() {
    return PageRouteBuilder(pageBuilder: (BuildContext context,
        Animation<double> animation, Animation<double> secondaryAnimation) {
      return SeatsPage();
    });
  }

  @override
  _SeatsPageState createState() => _SeatsPageState();
}

class _SeatsPageState extends State<SeatsPage> with TickerProviderStateMixin {
  AnimationController controller;
  SeatArrangement get seats => Provider.of<SeatArrangement>(context);
  SeatArrangement get seatsNL =>
      Provider.of<SeatArrangement>(context, listen: false);

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: _generateSeats(),
          ),
          physics: BouncingScrollPhysics(),
        ),
        physics: BouncingScrollPhysics(),
      ),
    );
  }

  _generateSeats() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            "SCREEN",
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        for (var r = 0; r < seats.rows.length; r++)
          if (seats.rows[r].isEmpty)
            Padding(padding: EdgeInsets.only(top: 30.0))
          else
            Row(
              children: [
                for (var i = 0; i < seats.columns[seats.rows[r]]; i++)
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: Tween<double>(begin: 0, end: 1)
                            .animate(CurvedAnimation(
                                curve: Interval(
                                  0.01 * i + 0.05 * r,
                                  min(1.0, 0.5 + 0.01 * i + 0.05 * r),
                                  curve: Curves.easeOutBack,
                                ),
                                parent: controller)),
                        child: child,
                      );
                    },
                    child: Container(
                      key: ValueKey('$r-$i'),
                      margin: EdgeInsets.all(10.0),
                      child: CustomPaint(
                          painter: SeatPainter(
                              color: seatsNL.availability
                                  ? Colors.grey[700]
                                  : Colors.white),
                          size: Size(20, 20)),
                    ),
                  )
              ],
            )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class SeatPainter extends CustomPainter {
  final Color color;

  SeatPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(cinemaSeat, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
