import 'scheduler_config.dart';
import 'event_counter.dart';
import 'dart:async';

/// Core class that manages event scheduling and triggering.
///
/// This class provides static methods to register, track, and manage events.
/// It handles all the scheduling logic and ensures events are triggered
/// according to their configuration.
///
/// The class maintains several internal maps to track:
/// * Event configurations
/// * Active timers
/// * Last trigger times
/// * Time update timers
class SchedulerCore {
  static final Map<String, SchedulerConfig> _configs = {};
  static final EventCounter _eventCounter = EventCounter();
  static final Map<String, Timer> _timers = {};
  static final Map<String, DateTime> _lastTriggerTimes = {};
  static final Map<String, Timer> _timeUpdateTimers = {};

  /// Registers a new event configuration.
  ///
  /// This method sets up the event with the provided configuration and
  /// starts tracking it according to its trigger type.
  ///
  /// For time-based triggers, it will start the time tracking immediately.
  ///
  /// Throws an exception if the configuration is invalid.
  static void register(SchedulerConfig config) {
    _configs[config.eventKey] = config;

    if (config.triggerType == TriggerType.time) {
      _startTimeTracking(config);
    }
  }

  /// Unregisters an event and cleans up its resources.
  ///
  /// This method should be called when you no longer need to track an event.
  /// It cancels any active timers and removes the event from tracking.
  static void unregister(String eventKey) {
    _configs.remove(eventKey);
    _timers[eventKey]?.cancel();
    _timers.remove(eventKey);
    _lastTriggerTimes.remove(eventKey);
    _timeUpdateTimers[eventKey]?.cancel();
    _timeUpdateTimers.remove(eventKey);
  }

  /// Starts tracking time-based events.
  ///
  /// This method handles the initial setup for time-based triggers,
  /// including first open time tracking and recurring timer setup.
  static void _startTimeTracking(SchedulerConfig config) async {
    final firstOpenTime = await _eventCounter.getFirstOpenTime(config.eventKey);
    final lastTriggerTime = await _eventCounter.getLastTriggerTime(
      config.eventKey,
    );
    final now = DateTime.now();

    if (firstOpenTime == null) {
      await _eventCounter.setFirstOpenTime(config.eventKey, now);
    }

    if (lastTriggerTime == null) {
      if (DateTime.now().isAfter(config.triggerTime!)) {
        _triggerEvent(config, isRecurrence: false);
      }
      _startRecurringTimer(config);
    } else {
      final timeSinceLastTrigger = now.difference(lastTriggerTime);

      if (timeSinceLastTrigger >= config.recurrenceInterval!) {
        _triggerEvent(config, isRecurrence: true);
        _startRecurringTimer(config);
      } else {
        final remainingTime = config.recurrenceInterval! - timeSinceLastTrigger;

        Timer(remainingTime, () {
          if (_configs.containsKey(config.eventKey)) {
            _triggerEvent(config, isRecurrence: true);
            _startRecurringTimer(config);
          }
        });
      }
    }
  }

  /// Starts a recurring timer for time-based events.
  ///
  /// This method sets up a periodic timer that triggers the event
  /// at the specified interval.
  static void _startRecurringTimer(SchedulerConfig config) {
    _timers[config.eventKey]?.cancel();
    _timers[config.eventKey] = Timer.periodic(config.recurrenceInterval!, (
      timer,
    ) {
      if (_configs.containsKey(config.eventKey)) {
        if (config.endTime != null && DateTime.now().isAfter(config.endTime!)) {
          timer.cancel();
          _configs[config.eventKey]?.onStateUpdate?.call(false);
          return;
        }
        _triggerEvent(config, isRecurrence: true);
      } else {
        timer.cancel();
      }
    });
  }

  /// Triggers an event and updates its state.
  ///
  /// This method handles the actual event triggering, including:
  /// * Calling the appropriate callback
  /// * Updating last trigger time
  /// * Incrementing recurrence counter
  /// * Updating state
  static void _triggerEvent(
    SchedulerConfig config, {
    required bool isRecurrence,
  }) {
    if (isRecurrence && config.recurrenceType != RecurrenceType.none) {
      (config.recurrenceOnEvent ?? config.onEvent)();
    } else {
      config.onEvent();
    }

    _lastTriggerTimes[config.eventKey] = DateTime.now();
    _eventCounter.setLastTriggerTime(config.eventKey, DateTime.now());
    _eventCounter.incrementRecurrenceCounter(config.eventKey);
    config.onStateUpdate?.call(true);
  }

  /// Tracks an event occurrence.
  ///
  /// For count-based triggers, this method should be called each time
  /// the event occurs. It will trigger the event when the count reaches
  /// the configured threshold.
  ///
  /// This method also handles:
  /// * End time checks
  /// * Maximum recurrence checks
  /// * Count-based recurrence
  ///
  /// Returns a Future that completes when the tracking is done.
  static Future<void> track(String eventKey) async {
    final config = _configs[eventKey];
    if (config == null) return;

    if (config.endTime != null && DateTime.now().isAfter(config.endTime!)) {
      config.onStateUpdate?.call(false);
      return;
    }

    await _eventCounter.incrementCounter(eventKey);
    final count = await _eventCounter.getCounter(eventKey);
    final recurrenceCount = await _eventCounter.getRecurrenceCounter(eventKey);

    if (config.maxRecurrences != null &&
        recurrenceCount >= config.maxRecurrences! + 1) {
      config.onStateUpdate?.call(false);
      return;
    }

    if (config.triggerType == TriggerType.count &&
        count >= config.triggerCount! &&
        recurrenceCount == 0) {
      _triggerEvent(config, isRecurrence: false);
      return;
    }

    if (config.triggerType == TriggerType.time &&
        DateTime.now().isAfter(config.triggerTime!) &&
        recurrenceCount == 0) {
      _triggerEvent(config, isRecurrence: false);
      return;
    }

    if (config.recurrenceType == RecurrenceType.count && recurrenceCount > 0) {
      if (config.maxRecurrences != null &&
          recurrenceCount >= config.maxRecurrences! + 1) {
        config.onStateUpdate?.call(false);
        return;
      }

      final remainingCount = count - config.triggerCount!;
      if (remainingCount > 0 && remainingCount % config.recurrenceCount! == 0) {
        _triggerEvent(config, isRecurrence: true);
      }
    }
  }

  /// Gets the last time an event was triggered.
  ///
  /// Returns a Future that completes with the DateTime of the last trigger,
  /// or null if the event has never been triggered.
  static Future<DateTime?> getLastTriggerTime(String eventKey) async {
    return await _eventCounter.getLastTriggerTime(eventKey);
  }

  /// Resets an event's state.
  ///
  /// This method clears all tracking data for the event and cancels
  /// any active timers. The event will start fresh the next time it's tracked.
  ///
  /// It handles:
  /// * Resetting event counter
  /// * Canceling active timers
  /// * Clearing last trigger times
  /// * Updating state
  ///
  /// Returns a Future that completes when the reset is done.
  static Future<void> reset(String eventKey) async {
    await _eventCounter.resetEvent(eventKey);
    _timers[eventKey]?.cancel();
    _timers.remove(eventKey);
    _lastTriggerTimes.remove(eventKey);
    _timeUpdateTimers[eventKey]?.cancel();
    _timeUpdateTimers.remove(eventKey);
    final config = _configs[eventKey];
    if (config != null) {
      config.onStateUpdate?.call(false);
    }
  }
}
