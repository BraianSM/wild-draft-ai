// lib/models/flash_tracker_state.dart

class SpellState {
  static const int flashDurationSeconds = 300;
  static const int igniteDurationSeconds = 180;

  final bool flashAvailable;
  final DateTime? flashReadyAt;
  final bool igniteAvailable;
  final DateTime? igniteReadyAt;

  const SpellState({
    required this.flashAvailable,
    this.flashReadyAt,
    required this.igniteAvailable,
    this.igniteReadyAt,
  });

  int get flashRemainingSeconds {
    if (!flashAvailable && flashReadyAt != null) {
      final diff = flashReadyAt!.difference(DateTime.now()).inSeconds;
      return diff > 0 ? diff : 0;
    }
    return 0;
  }

  int get igniteRemainingSeconds {
    if (!igniteAvailable && igniteReadyAt != null) {
      final diff = igniteReadyAt!.difference(DateTime.now()).inSeconds;
      return diff > 0 ? diff : 0;
    }
    return 0;
  }

  SpellState copyWith({
    bool? flashAvailable,
    DateTime? flashReadyAt,
    bool clearFlashReadyAt = false,
    bool? igniteAvailable,
    DateTime? igniteReadyAt,
    bool clearIgniteReadyAt = false,
  }) {
    return SpellState(
      flashAvailable: flashAvailable ?? this.flashAvailable,
      flashReadyAt: clearFlashReadyAt ? null : (flashReadyAt ?? this.flashReadyAt),
      igniteAvailable: igniteAvailable ?? this.igniteAvailable,
      igniteReadyAt: clearIgniteReadyAt ? null : (igniteReadyAt ?? this.igniteReadyAt),
    );
  }
}