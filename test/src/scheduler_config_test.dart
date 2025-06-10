import 'package:event_scheduler/event_scheduler_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SchedulerConfig Tests', () {
    const String testEventKey = 'test_event';
    testOnEvent() {}

    test('should create valid config with time trigger', () {
      final now = DateTime.now();
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: now,
        recurrenceInterval: const Duration(minutes: 5),
        onEvent: testOnEvent,
      );

      expect(config.eventKey, testEventKey);
      expect(config.triggerType, TriggerType.time);
      expect(config.triggerTime, now);
      expect(config.recurrenceInterval, const Duration(minutes: 5));
      expect(config.onEvent, testOnEvent);
    });

    test('should create valid config with count trigger', () {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.count,
        triggerCount: 5,
        onEvent: testOnEvent,
      );

      expect(config.eventKey, testEventKey);
      expect(config.triggerType, TriggerType.count);
      expect(config.triggerCount, 5);
      expect(config.onEvent, testOnEvent);
    });

    test(
      'should throw assertion error when time trigger is missing triggerTime',
      () {
        expect(
          () => SchedulerConfig(
            eventKey: testEventKey,
            triggerType: TriggerType.time,
            onEvent: testOnEvent,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      'should throw assertion error when count trigger is missing triggerCount',
      () {
        expect(
          () => SchedulerConfig(
            eventKey: testEventKey,
            triggerType: TriggerType.count,
            onEvent: testOnEvent,
          ),
          throwsAssertionError,
        );
      },
    );

    test('should create valid config with count recurrence', () {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now(),
        recurrenceType: RecurrenceType.count,
        recurrenceCount: 3,
        recurrenceInterval: const Duration(minutes: 5),
        onEvent: testOnEvent,
      );

      expect(config.recurrenceType, RecurrenceType.count);
      expect(config.recurrenceCount, 3);
    });

    test('should create valid config with time recurrence', () {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now(),
        recurrenceType: RecurrenceType.time,
        recurrenceInterval: const Duration(minutes: 5),
        onEvent: testOnEvent,
      );

      expect(config.recurrenceType, RecurrenceType.time);
      expect(config.recurrenceInterval, const Duration(minutes: 5));
    });

    test(
      'should throw assertion error when count recurrence is missing recurrenceCount',
      () {
        expect(
          () => SchedulerConfig(
            eventKey: testEventKey,
            triggerType: TriggerType.time,
            triggerTime: DateTime.now(),
            recurrenceType: RecurrenceType.count,
            recurrenceInterval: const Duration(minutes: 5),
            onEvent: testOnEvent,
          ),
          throwsAssertionError,
        );
      },
    );

    test(
      'should throw assertion error when time recurrence is missing recurrenceInterval',
      () {
        expect(
          () => SchedulerConfig(
            eventKey: testEventKey,
            triggerType: TriggerType.time,
            triggerTime: DateTime.now(),
            recurrenceType: RecurrenceType.time,
            onEvent: testOnEvent,
          ),
          throwsAssertionError,
        );
      },
    );

    test('should create valid config with optional callbacks', () {
      testRecurrenceOnEvent() {}
      testOnStateUpdate(state) {}

      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now(),
        recurrenceInterval: const Duration(minutes: 5),
        onEvent: testOnEvent,
        recurrenceOnEvent: testRecurrenceOnEvent,
        onStateUpdate: testOnStateUpdate,
      );

      expect(config.recurrenceOnEvent, testRecurrenceOnEvent);
      expect(config.onStateUpdate, testOnStateUpdate);
    });

    test('should create valid config with max recurrences', () {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now(),
        recurrenceInterval: const Duration(minutes: 5),
        maxRecurrences: 5,
        onEvent: testOnEvent,
      );

      expect(config.maxRecurrences, 5);
    });

    test('should create valid config with end time', () {
      final endTime = DateTime.now().add(const Duration(hours: 1));
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now(),
        recurrenceInterval: const Duration(minutes: 5),
        endTime: endTime,
        onEvent: testOnEvent,
      );

      expect(config.endTime, endTime);
    });
  });
}
