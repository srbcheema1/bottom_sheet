import 'dart:async';

import 'package:rxdart/rxdart.dart';

class StateBloc {
  var _sheetup = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get sheetup => _sheetup.stream;

  void toggleAnimation() {
    _sheetup.sink.add(!_sheetup.value);
  }

  void dispose() {
    _sheetup.close();
  }
}

final stateBloc = StateBloc();
