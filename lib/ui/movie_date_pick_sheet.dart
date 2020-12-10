import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/seats.dart';
import 'package:movies/pages/seats.dart';
import 'package:movies/ui/showtime_picker.dart';
import 'package:movies/ui/transitions.dart';
import 'package:movies/ui/week_date_picker.dart';
import 'package:provider/provider.dart';

class MovieDateTimePickSheet extends StatefulWidget {
  final index;

  static show(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListenableProvider.value(
          value: Provider.of<Movies>(context),
          child: MovieDateTimePickSheet(index),
        );
      },
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      isScrollControlled: true,
      useRootNavigator: true,
      isDismissible: true,
      enableDrag: true,
    );
  }

  MovieDateTimePickSheet(this.index);

  @override
  _MovieDateTimePickSheetState createState() => _MovieDateTimePickSheetState();
}

class _MovieDateTimePickSheetState extends State<MovieDateTimePickSheet>
    with TickerProviderStateMixin {
  AnimationController _controller;

  Movie get movie => Provider.of<Movies>(context)[widget.index];

  Movie get movieNL =>
      Provider.of<Movies>(context, listen: false)[widget.index];

  var selectedDate;
  var selectedShowTime;

  get titleStyle => GoogleFonts.nunito(
      color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold);

  get descriptionStyle =>
      GoogleFonts.nunito(color: Colors.black87, fontSize: 11.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        color: Colors.grey[50],
      ),
      padding: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              height: 20,
              indent: MediaQuery.of(context).size.width / 2 - 80,
              endIndent: MediaQuery.of(context).size.width / 2 - 80,
              color: Colors.black,
              thickness: 2.0,
            ),
            Container(
              height: 160,
              child: AnimatedChildrenBuilder(
                animation: _controller,
                builder: _slidingPosterDetailsBuilder,
                children: [
                  ClipRRect(
                    child: Image(
                        image: movie.poster.image, width: 105, height: 140),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  Text(movie.name, style: titleStyle),
                  Text.rich(
                    TextSpan(
                        text: '${movie.genres}    ${movie.duration}',
                        style: descriptionStyle),
                  ),
                  Text('IMDb: ${movie.imdb}\n', style: descriptionStyle),
                  Text(
                    movie.description,
                    style: descriptionStyle,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
            // Week Date Picker
            WeekDatePicker(
              days: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
              dates: ['15', '16', '17', '18', '19', '20', '21'],
              controller: _controller,
              onSelected: (date) => setState(() => selectedDate = date),
            ),
            ShowtimePicker(
              date: selectedDate,
              onSelected: (showtime) =>
                  setState(() => selectedShowTime = showtime),
              showtime: [
                '10:35 AM',
                '11:15 AM',
                '1:35 PM',
                '3:15 PM',
                '4:35 PM',
                '05:15 PM'
              ],
            ),
            OpenContainer(
              openBuilder: (_, __) {
                return ChangeNotifierProvider<SeatArrangement>(
                    create: (_) {
                      return SeatArrangement(
                        ['A', '', 'B', 'C', 'D', 'E', '', 'F', 'G', 'H'],
                        Map.fromIterable(
                            ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'],
                            value: (_) => 8),
                      );
                    },
                    child: SeatsPage());
              },
              transitionType: ContainerTransitionType.fade,
              closedBuilder: (_, open) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                              curve:
                                  Interval(0.75, 1, curve: Curves.elasticOut),
                              parent: _controller)),
                      child: child,
                    );
                  },
                  child: RaisedButton(
                    child: Text(
                      'TAKE SEAT',
                      style: GoogleFonts.nunito(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (selectedDate != null && selectedShowTime != null) {
                        open();
                      }
                    },
                    color: Colors.red[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  ),
                );
              },
              closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0)),
              closedColor: Colors.grey[50],
              closedElevation: 0,
              tappable: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _slidingPosterDetailsBuilder(context, List<Widget> children) {
    var detailTween = Tween<Offset>(begin: Offset(300, 0), end: Offset.zero);
    var curve = ElasticOutCurve(0.5);

    var posterOffset = Tween<Offset>(begin: Offset(-200, 0), end: Offset.zero)
        .animate(CurvedAnimation(
            curve: Interval(0, 0.3, curve: Curves.easeInOutBack),
            parent: _controller));

    var headingOffset = detailTween.animate(CurvedAnimation(
        curve: Interval(0.2, 0.6, curve: curve), parent: _controller));

    var detailOffset = detailTween.animate(CurvedAnimation(
        curve: Interval(0.24, 0.64, curve: curve), parent: _controller));

    var detail2Offset = detailTween.animate(CurvedAnimation(
        curve: Interval(0.28, 0.68, curve: curve), parent: _controller));

    var descriptionOffset = detailTween.animate(CurvedAnimation(
        curve: Interval(0.32, 0.72, curve: curve), parent: _controller));

    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          child: Container(
            width: MediaQuery.of(context).size.width - 180,
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Transform.translate(
                    offset: headingOffset.value, child: children[1]),
                Transform.translate(
                    offset: detailOffset.value, child: children[2]),
                Transform.translate(
                    offset: detail2Offset.value, child: children[3]),
                Transform.translate(
                    offset: descriptionOffset.value, child: children[4]),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: Transform.translate(
              offset: posterOffset.value, child: children[0]),
        ),
      ],
    );
  }
}
