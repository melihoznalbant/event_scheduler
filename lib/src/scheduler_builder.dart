import 'package:flutter/foundation.dart';
import 'scheduler_config.dart';
import 'scheduler_core.dart';

class EventSchedulerBuilder {
  String? _eventKey;
  TriggerType? _triggerType;
  RecurrenceType _recurrenceType = RecurrenceType.none;
  
  DateTime? _triggerTime;
  int? _triggerCount;
  
  Duration? _recurrenceInterval;
  int? _recurrenceCount;
  int? _maxRecurrences;
  DateTime? _endTime;
  
  VoidCallback? _onEvent;
  VoidCallback? _recurrenceOnEvent;
  Function(bool)? _onStateUpdate;

  EventSchedulerBuilder setEventKey(String key) {
    _eventKey = key;
    return this;
  }

  EventSchedulerBuilder setTriggerType(TriggerType type) {
    _triggerType = type;
    return this;
  }

  EventSchedulerBuilder setRecurrenceType(RecurrenceType type) {
    _recurrenceType = type;
    return this;
  }

  EventSchedulerBuilder setTriggerTime(DateTime time) {
    _triggerTime = time;
    return this;
  }

  EventSchedulerBuilder setTriggerCount(int count) {
    _triggerCount = count;
    return this;
  }

  EventSchedulerBuilder setRecurrenceInterval(Duration interval) {
    _recurrenceInterval = interval;
    return this;
  }

  EventSchedulerBuilder setRecurrenceCount(int count) {
    _recurrenceCount = count;
    return this;
  }

  EventSchedulerBuilder setMaxRecurrences(int count) {
    _maxRecurrences = count;
    return this;
  }

  EventSchedulerBuilder setEndTime(DateTime time) {
    _endTime = time;
    return this;
  }

  EventSchedulerBuilder setOnEvent(VoidCallback callback) {
    _onEvent = callback;
    return this;
  }

  EventSchedulerBuilder setRecurrenceOnEvent(VoidCallback callback) {
    _recurrenceOnEvent = callback;
    return this;
  }

  EventSchedulerBuilder setOnStateUpdate(Function(bool) callback) {
    _onStateUpdate = callback;
    return this;
  }

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