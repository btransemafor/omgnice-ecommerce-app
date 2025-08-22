import 'dart:async';
import 'package:flutter/material.dart';

class OtpCountdownProvider with ChangeNotifier {
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  int get secondsRemaining => _secondsRemaining;
  bool get canResend => _canResend;

  void startCountdown() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _canResend = true;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  void disposeCountdown() {
    _timer?.cancel();
  }
}
