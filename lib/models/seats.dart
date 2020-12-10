import 'dart:math';

import 'package:flutter/cupertino.dart';

class SeatArrangement extends ChangeNotifier {
  List<String> _rows;
  Map<String, int> _columns;

  SeatArrangement(this._rows, this._columns);

  Map<String, int> get columns => _columns;

  set columns(Map<String, int> value) {
    _columns = value;
    notifyListeners();
  }

  List<String> get rows => _rows;

  set rows(List<String> value) {
    _rows = value;
    notifyListeners();
  }

  bool get availability {
    return Random().nextBool();
  }
}
