import 'package:flutter/foundation.dart';
import 'scheduler_config.dart';
import 'scheduler_core.dart';

/// A builder class for creating and configuring event schedulers.
/// 
/// This class provides a fluent interface for configuring events using the builder pattern.
/// It allows for easy and readable configuration of all event parameters.
/// 
/// Example usage:
/// ```dart
/// EventSchedulerBuilder()
///   .setEventKey('my_event')
///   .setTriggerType(TriggerType.time)
///   .setTriggerTime(DateTime.now().add(Duration(minutes: 5)))
///   .setRecurrenceInterval(Duration(minutes: 30))
///   .setOnEvent(() {
///     print('Event triggered!');
///   })
///   .build();
/// ```
class EventSchedulerBuilder {
  /// Unique identifier for the event
  String? _eventKey;

  /// Type of trigger (time or count)
  TriggerType? _triggerType;

  /// Type of recurrence (none, time, or count)
  RecurrenceType _recurrenceType = RecurrenceType.none;
  
  /// Time when time-based triggers should occur
  DateTime? _triggerTime;

  /// Count required for count-based triggers
  int? _triggerCount;
  
  /// Interval between recurring events
  Duration? _recurrenceInterval;

  /// Number of times an event should recur
  int? _recurrenceCount;

  /// Maximum number of times an event can recur
  int? _maxRecurrences;

  /// When the event should stop recurring
  DateTime? _endTime;
  
  /// Callback function when the event is triggered
  VoidCallback? _onEvent;

  /// Optional callback for recurrence events
  VoidCallback? _recurrenceOnEvent;

  /// Optional callback for state changes
  Function(bool)? _onStateUpdate;

  /// Sets the unique identifier for the event.
  /// 
  /// This is a required parameter and must be set before building.
  EventSchedulerBuilder setEventKey(String key) {
    _eventKey = key;
    return this;
  }

  /// Sets the type of trigger for the event.
  /// 
  /// This is a required parameter and must be set before building.
  /// * [TriggerType.time] for time-based triggers
  /// * [TriggerType.count] for count-based triggers
  EventSchedulerBuilder setTriggerType(TriggerType type) {
    _triggerType = type;
    return this;
  }

  /// Sets the type of recurrence for the event.
  /// 
  /// * [RecurrenceType.none] for no recurrence
  /// * [RecurrenceType.time] for time-based recurrence
  /// * [RecurrenceType.count] for count-based recurrence
  EventSchedulerBuilder setRecurrenceType(RecurrenceType type) {
    _recurrenceType = type;
    return this;
  }

  /// Sets the trigger time for time-based triggers.
  /// 
  /// Required when [triggerType] is [TriggerType.time].
  /// Specifies when the event should first trigger.
  EventSchedulerBuilder setTriggerTime(DateTime time) {
    _triggerTime = time;
    return this;
  }

  /// Sets the trigger count for count-based triggers.
  /// 
  /// Required when [triggerType] is [TriggerType.count].
  /// Specifies how many occurrences are needed to trigger the event.
  EventSchedulerBuilder setTriggerCount(int count) {
    _triggerCount = count;
    return this;
  }

  /// Sets the interval between recurring events.
  /// 
  /// Required when [recurrenceType] is [RecurrenceType.time].
  /// Specifies how often the event should recur.
  EventSchedulerBuilder setRecurrenceInterval(Duration interval) {
    _recurrenceInterval = interval;
    return this;
  }

  /// Sets the number of times an event should recur.
  /// 
  /// Required when [recurrenceType] is [RecurrenceType.count].
  /// Specifies how many times the event should recur.
  EventSchedulerBuilder setRecurrenceCount(int count) {
    _recurrenceCount = count;
    return this;
  }

  /// Sets the maximum number of times an event can recur.
  /// 
  /// Optional parameter that limits the total number of recurrences.
  /// If not set, the event can recur indefinitely (until [endTime] if set).
  EventSchedulerBuilder setMaxRecurrences(int count) {
    _maxRecurrences = count;
    return this;
  }

  /// Sets when the event should stop recurring.
  /// 
  /// Optional parameter that specifies when the event should stop recurring.
  /// If not set, the event will continue until [maxRecurrences] if set.
  EventSchedulerBuilder setEndTime(DateTime time) {
    _endTime = time;
    return this;
  }

  /// Sets the callback function for when the event is triggered.
  /// 
  /// This is a required parameter and must be set before building.
  /// The callback will be called when the event triggers.
  EventSchedulerBuilder setOnEvent(VoidCallback callback) {
    _onEvent = callback;
    return this;
  }

  /// Sets the callback function for recurrence events.
  /// 
  /// Optional parameter that specifies a different callback for recurrence events.
  /// If not set, the main [onEvent] callback will be used for recurrences.
  EventSchedulerBuilder setRecurrenceOnEvent(VoidCallback callback) {
    _recurrenceOnEvent = callback;
    return this;
  }

  /// Sets the callback function for state updates.
  /// 
  /// Optional parameter that will be called when the event's state changes.
  /// The callback receives a boolean indicating if the event is active.
  EventSchedulerBuilder setOnStateUpdate(Function(bool) callback) {
    _onStateUpdate = callback;
    return this;
  }

  /// Builds and registers the event configuration.
  /// 
  /// This method validates the configuration and registers the event
  /// with the scheduler core.
  /// 
  /// Throws an exception if required parameters are missing:
  /// * [eventKey]
  /// * [triggerType]
  /// * [onEvent]
  /// 
  /// Also throws if required parameters for the selected trigger type
  /// or recurrence type are missing.
  void build() {
    if (_eventKey == null || _triggerType == null || _onEvent == null) {
      throw Exception('Event key, trigger type, and onEvent must be set.');
    }

    final config = SchedulerConfig(
      eventKey: _eventKey!,
      triggerType: _triggerType!,
      recurrenceType: _recurrenceType,
      onEvent: _onEvent!,
      recurrenceOnEvent: _recurrenceOnEvent,
      onStateUpdate: _onStateUpdate,
      triggerTime: _triggerTime,
      triggerCount: _triggerCount,
      recurrenceInterval: _recurrenceInterval,
      recurrenceCount: _recurrenceCount,
      maxRecurrences: _maxRecurrences,
      endTime: _endTime,
    );

    SchedulerCore.register(config);
  }
}