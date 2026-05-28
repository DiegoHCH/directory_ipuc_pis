import 'dart:async';
import 'package:flutter/foundation.dart';

class VerificationViewModel extends ChangeNotifier {
  static const _codeLength = 6;
  static const _resendSeconds = 42;

  final List<String> _digits = List.filled(_codeLength, '');
  int _countdown = _resendSeconds;
  bool _isVerifying = false;
  Timer? _timer;

  VerificationViewModel() {
    _startCountdown();
  }

  List<String> get digits => List.unmodifiable(_digits);
  int get countdown => _countdown;
  bool get isVerifying => _isVerifying;
  bool get canResend => _countdown == 0;
  bool get isComplete => _digits.every((d) => d.isNotEmpty);

  String get code => _digits.join();

  void setDigit(int index, String value) {
    if (index < 0 || index >= _codeLength) return;
    _digits[index] = value.isEmpty ? '' : value[value.length - 1];
    notifyListeners();
  }

  void resend() {
    if (!canResend) return;
    _countdown = _resendSeconds;
    _digits.fillRange(0, _codeLength, '');
    notifyListeners();
    _startCountdown();
  }

  Future<void> verify() async {
    if (!isComplete) return;
    _isVerifying = true;
    notifyListeners();

    // TODO: validar código contra backend
    await Future.delayed(const Duration(seconds: 1));

    _isVerifying = false;
    notifyListeners();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_countdown > 0) {
        _countdown--;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
