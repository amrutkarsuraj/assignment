import 'dart:async';
import 'dart:ui';

class Debouncer {
  Timer? _timer;

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 400), action);
  }
}