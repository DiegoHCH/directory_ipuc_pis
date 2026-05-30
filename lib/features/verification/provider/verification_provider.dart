import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationState {
  final List<String> digits;
  final int countdown;
  final bool isVerifying;

  const VerificationState({
    this.digits = const ['', '', '', '', '', ''],
    this.countdown = 42,
    this.isVerifying = false,
  });

  bool get isComplete => digits.every((d) => d.isNotEmpty);
  bool get canResend => countdown == 0;

  String get code => digits.join();

  VerificationState copyWith({
    List<String>? digits,
    int? countdown,
    bool? isVerifying,
  }) =>
      VerificationState(
        digits: digits ?? this.digits,
        countdown: countdown ?? this.countdown,
        isVerifying: isVerifying ?? this.isVerifying,
      );
}

class VerificationNotifier extends AutoDisposeNotifier<VerificationState> {
  Timer? _timer;

  @override
  VerificationState build() {
    ref.onDispose(() => _timer?.cancel());
    _startCountdown();
    return const VerificationState();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.countdown > 0) {
        state = state.copyWith(countdown: state.countdown - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  void setDigit(int index, String value) {
    final updated = [...state.digits];
    updated[index] = value.isEmpty ? '' : value[value.length - 1];
    state = state.copyWith(digits: updated);
  }

  void resend() {
    if (!state.canResend) return;
    state = state.copyWith(
      digits: List.filled(6, ''),
      countdown: 42,
    );
    _startCountdown();
  }

  Future<void> verify() async {
    if (!state.isComplete) return;
    state = state.copyWith(isVerifying: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isVerifying: false);
  }
}

final verificationProvider =
    AutoDisposeNotifierProvider<VerificationNotifier, VerificationState>(
        VerificationNotifier.new);
