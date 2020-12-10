import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/ui/movie_date_pick_sheet.dart';
import 'package:movies/ui/page_notifier_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static Route<dynamic> route() {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return HomePage();
      },
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _controller;
  ValueNotifier<double> _notifier;
  ValueNotifier<int> _backgroundNotifier;

  Movies get movies => Provider.of<Movies>(context);

  Movies get moviesNL => Provider.of<Movies>(context, listen: false);

  _preloadImages() {
    for (var movie in moviesNL) {
      precacheImage(movie.logo.image, context);
      precacheImage(movie.poster.image, context);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 0.9);
    _notifier = ValueNotifier<double>(0.0);
    _backgroundNotifier = ValueNotifier<int>(0);
    _notifier.addListener(() {
      if (_notifier.value.ceil() < moviesNL.length &&
          _notifier.value.remainder(1.0) > 0.6) {
        _backgroundNotifier.value = _notifier.value.ceil();
      } else if (_notifier.value.floor() >= 0 &&
          _notifier.value.remainder(1.0) < 0.4) {
        _backgroundNotifier.value = _notifier.value.floor();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            // Blurred Background
            ValueListenableBuilder<int>(
              valueListenable: _backgroundNotifier,
              builder: (context, value, _) {
                return Image(
                  image: moviesNL[value].blurHashImage,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                );
              },
            ),
            // Movie Title Logo
            Positioned(
              top: 20.0,
              height: (MediaQuery.of(context).size.height - 500) / 2,
              child: ValueListenableBuilder<double>(
                valueListenable: _notifier,
                builder: (context, value, child) {
                  var scale = 1.0;
                  var img = moviesNL[value.floor()].logo;
                  if (value.ceil() < moviesNL.length &&
                      value.remainder(1.0) > 0.5) {
                    if (value.remainder(1.0) < 0.95) {
                      scale = value.remainder(1.0) * 1.1;
                    } else {
                      scale = (2 - value.remainder(1.0));
                    }
                    img = moviesNL[value.ceil()].logo;
                  } else if (value.floor() >= 0 &&
                      value.remainder(1.0) <= 0.5) {
                    if (value.remainder(1.0) > 0.05)
                      scale = (1 - value.remainder(1.0)) * 1.1;
                    else
                      scale = (1 + value.remainder(1.0) * 1.1);
                  } else {
                    scale = (value.remainder(1.0) - 0.5).abs() + 0.5;
                  }
                  return Transform.scale(
                    scale: scale,
                    child: img,
                    alignment: Alignment.center,
                  );
                },
              ),
              width: MediaQuery.of(context).size.width,
            ),
            // Moving Posters
            PageNotifierView(
              notifier: _notifier,
              scrollDirection: Axis.horizontal,
              controller: _controller,
              physics: BouncingScrollPhysics(),
              children: [
                for (var i = 0; i < movies.length; i++)
                  MoviePoster(i, _notifier)
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _notifier.dispose();
    super.dispose();
  }
}

class MoviePoster extends StatefulWidget {
  final ValueNotifier<double> _controller;
  final int index;

  MoviePoster(this.index, this._controller, {Key key}) : super(key: key);

  @override
  _MoviePosterState createState() => _MoviePosterState();
}

class _MoviePosterState extends State<MoviePoster>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Selector<Movies, Movie>(
            shouldRebuild: (movie1, movie2) => !(movie1 == movie2),
            selector: (context, Movies movies) => movies[widget.index],
            builder: (context, Movie value, child) {
              return AnimatedBuilder(
                animation: widget._controller,
                builder: _rotatedImageBuilder,
                child: GestureDetector(
                  onTap: () {
                    MovieDateTimePickSheet.show(context, widget.index);
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: value.poster),
                ),
              );
            }),
      ),
    );
  }

  Widget _rotatedImageBuilder(BuildContext context, Widget child) {
    if (widget._controller.value.floor() == widget.index) {
      return Transform.rotate(
        angle: -(pi / 36 * (widget._controller.value.remainder(1.0))),
        child: child,
      );
    } else {
      if (widget._controller.value.ceil() == widget.index) {
        return Transform.rotate(
          angle: pi / 36 * (1 - widget._controller.value.remainder(1.0)),
          child: child,
        );
      }
    }
    return Transform.rotate(
      angle: 0.0,
      child: child,
    );
  }
}
