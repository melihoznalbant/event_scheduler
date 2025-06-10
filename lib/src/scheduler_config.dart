import 'package:flutter/foundation.dart';

/// Defines the type of trigger for an event.
///
/// * [count] - Event triggers after a specific number of occurrences
/// * [time] - Event triggers at a specific time or interval
enum TriggerType { count, time }

/// Defines how an event should recur.
///
/// * [none] - Event does not recur
/// * [count] - Event recurs after a specific number of occurrences
/// * [time] - Event recurs at specific time intervals
enum RecurrenceType { none, count, time }

/// Configuration class for event scheduling.
///
/// This class defines how an event should be triggered and handled.
/// It supports both time-based and count-based triggers with optional recurrence.
///
/// Required parameters:
/// * [eventKey] - Unique identifier for the event
/// * [triggerType] - Type of trigger (time or count)
/// * [onEvent] - Callback function when event is triggered
///
/// Optional parameters:
/// * [triggerTime] - Required for time-based triggers
/// * [triggerCount] - Required for count-based triggers
/// * [recurrenceType] - Type of recurrence (none, time, or count)
/// * [recurrenceInterval] - Required for time-based recurrence
/// * [recurrenceCount] - Required for count-based recurrence
/// * [maxRecurrences] - Maximum number of times event can recur
/// * [endTime] - When the event should stop recurring
/// * [recurrenceOnEvent] - Optional callback for recurrence events
/// * [onStateUpdate] - Optional callback for state changes
class SchedulerConfig {
  /// Unique identifier for the event
  final String eventKey;

  /// Type of trigger (time or count)
  final TriggerType triggerType;

  /// Count required for count-based triggers
  final int? triggerCount;

  /// Time when time-based triggers should occur
  final DateTime? triggerTime;

  /// Interval between recurring events
  final Duration? recurrenceInterval;

  /// Number of times an event should recur
  final int? recurrenceCount;

  /// Type of recurrence (none, time, or count)
  final RecurrenceType recurrenceType;

  /// Maximum number of times an event can recur
  final int? maxRecurrences;

  /// When the event should stop recurring
  final DateTime? endTime;

  /// Callback function when the event is triggered
  final VoidCallback onEvent;

  /// Optional callback for recurrence events
  final VoidCallback? recurrenceOnEvent;

  /// Optional callback for state changes
  final Function(bool)? onStateUpdate;

  /// Creates a new scheduler configuration.
  ///
  /// Throws assertions if required parameters are missing based on trigger type:
  /// * For count triggers: triggerCount must be provided
  /// * For time triggers: triggerTime must be provided
  /// * For count recurrence: recurrenceCount must be provided
  /// * For time recurrence: recurrenceInterval must be provided
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
      triggerType == TriggerType.count
          ? triggerCount != null
          : triggerTime != null,
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
      'Time trigger requires recurrenceInterval, count trigger requires triggerCount',
    );
  }
}
