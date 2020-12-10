import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class Movies extends ChangeNotifier with ListMixin<Movie> {
  List<Movie> _movies;

  Movies(this._movies) {
    for (var movie in _movies) {
      movie.addListener(() => notifyListeners());
    }
  }

  @override
  int get length => _movies.length;

  @override
  set length(value) {
    throw ErrorDescription('Cannot change the length of a List explicitly.');
  }

  @override
  Movie operator [](int index) {
    return _movies[index];
  }

  @override
  void operator []=(int index, Movie value) {
    _movies[index] = value;
    notifyListeners();
  }
}

class Movie extends ChangeNotifier {
  Movie(this._name, this._description, this._genres, this._duration, this._imdb,
      _posterUrl, _logoUrl, this._blurHash) {
    if (_posterUrl != null) {
      this._posterImage = Image.asset(
        _posterUrl,
        alignment: Alignment.center,
        fit: BoxFit.fill,
        width: 300,
        height: 400,
      );
    }
    if (_logoUrl != null) {
      this._logoImage = Image.asset(_logoUrl);
    }
    if (this._blurHash != null && this._blurHash.isNotEmpty) {
      this._blurHashImage = BlurHashImage(
        this.blurHash,
        decodingWidth: 6,
        decodingHeight: 8,
      );
    }
  }

  String _name, _duration, _description;
  List<String> _genres;
  double _imdb;
  Image _posterImage;
  Image _logoImage;
  String _blurHash;
  BlurHashImage _blurHashImage;

  BlurHashImage get blurHashImage => _blurHashImage;

  String get name => _name;

  get duration => _duration;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  Image get poster => _posterImage;

  Image get logo => _logoImage;

  String get blurHash => _blurHash;

  String get description => _description;

  String get imdb => _imdb.toStringAsFixed(2);

  String get genres => _genres.reduce((value, element) => '$value | $element');

  set blurHash(String value) {
    _blurHash = value;
    notifyListeners();
  }

  @override
  bool operator ==(other) {
    if (other is Movie) {
      return this.name == other.name;
    }
    return false;
  }

  @override
  int get hashCode => this.name.hashCode;
}
