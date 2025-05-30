import 'scheduler_config.dart';
import 'event_counter.dart';
import 'dart:async';

class SchedulerCore {
  static final Map<String, SchedulerConfig> _configs = {};
  static final EventCounter _eventCounter = EventCounter();
  static final Map<String, Timer> _timers = {};
  static final Map<String, DateTime> _lastTriggerTimes = {};
  static final Map<String, Timer> _timeUpdateTimers = {};

  static void register(SchedulerConfig config) {
    _configs[config.eventKey] = config;
    
    if (config.triggerType == TriggerType.time) {
      _startTimeTracking(config);
    }
  }

  static void unregister(String eventKey) {
    _configs.remove(eventKey);
    _timers[eventKey]?.cancel();
    _timers.remove(eventKey);
    _lastTriggerTimes.remove(eventKey);
    _timeUpdateTimers[eventKey]?.cancel();
    _timeUpdateTimers.remove(eventKey);
  }

  static void _startTimeTracking(SchedulerConfig config) async {
    final firstOpenTime = await _eventCounter.getFirstOpenTime(config.eventKey);
    final lastTriggerTime = await _eventCounter.getLastTriggerTime(config.eventKey);
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

  static void _startRecurringTimer(SchedulerConfig config) {
    _timers[config.eventKey]?.cancel();
    _timers[config.eventKey] = Timer.periodic(config.recurrenceInterval!, (timer) {
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

  static void _triggerEvent(SchedulerConfig config, {required bool isRecurrence}) {
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

    if (config.maxRecurrences != null && recurrenceCount >= config.maxRecurrences! + 1) {
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

    if (config.recurrenceType == RecurrenceType.count && 
        recurrenceCount > 0) {
      if (config.maxRecurrences != null && recurrenceCount >= config.maxRecurrences! + 1) {
        config.onStateUpdate?.call(false);
        return;
      }

      final remainingCount = count - config.triggerCount!;
      if (remainingCount > 0 && remainingCount % config.recurrenceCount! == 0) {
        _triggerEvent(config, isRecurrence: true);
      }
    }
  }

  static Future<DateTime?> getLastTriggerTime(String eventKey) async {
    return await _eventCounter.getLastTriggerTime(eventKey);
  }

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