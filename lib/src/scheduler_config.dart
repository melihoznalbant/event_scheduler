import 'package:flutter/foundation.dart';

enum TriggerType {
  count,
  time,
}

enum RecurrenceType {
  none,
  count,
  time,
}

class SchedulerConfig {
  final String eventKey;
  final TriggerType triggerType;
  final int? triggerCount;
  final DateTime? triggerTime;
  final Duration? recurrenceInterval;
  final int? recurrenceCount;
  final RecurrenceType recurrenceType;
  final int? maxRecurrences;
  final DateTime? endTime;
  final VoidCallback onEvent;
  final VoidCallback? recurrenceOnEvent;
  final Function(bool)? onStateUpdate;

  SchedulerConfig({
    required this.eventKey,
    required this.triggerType,
    this.triggerCount,
    this.triggerTime,
    this.recurrenceInterval,
    this.recurrenceCount,
    this.recurrenceType = RecurrenceType.none,
    this.maxRecurrences,
    this.endTime,
    required this.onEvent,
    this.recurrenceOnEvent,
    this.onStateUpdate,
  }) {
    assert(
      triggerType == TriggerType.count ? triggerCount != null : triggerTime != null,
      'triggerCount must be provided when triggerType is count, triggerTime must be provided when triggerType is time',
    );

    assert(
      recurrenceType == RecurrenceType.none ||
          (recurrenceType == RecurrenceType.count && recurrenceCount != null) ||
          (recurrenceType == RecurrenceType.time && recurrenceInterval != null),
      'recurrenceCount must be provided when recurrenceType is count, recurrenceInterval must be provided when recurrenceType is time',
    );

    assert(
      triggerType == TriggerType.time
          ? (recurrenceInterval != null)
          : (triggerCount != null),
      'Time trigger için recurrenceInterval, count trigger için triggerCount gerekli',
    );
  }
}