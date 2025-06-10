import 'package:event_scheduler/event_scheduler_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SchedulerCore Tests', () {
    const String testEventKey = 'test_event';
    late Completer<void> eventCompleter;
    late Completer<void> recurrenceCompleter;
    late Completer<void> stateUpdateCompleter;
    bool lastStateUpdate = false;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPreferences.getInstance();

      eventCompleter = Completer<void>();
      recurrenceCompleter = Completer<void>();
      stateUpdateCompleter = Completer<void>();
      lastStateUpdate = false;
    });

    tearDown(() async {
      await SchedulerCore.reset(testEventKey);
      SchedulerCore.unregister(testEventKey);
    });

    test('should register and unregister event config', () async {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now().add(const Duration(seconds: 1)),
        recurrenceInterval: const Duration(seconds: 1),
        onEvent: () {},
      );

      SchedulerCore.register(config);
      expect(() => SchedulerCore.unregister(testEventKey), returnsNormally);
    });

    test('should trigger time-based event after delay', () async {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now().add(const Duration(milliseconds: 100)),
        recurrenceInterval: const Duration(seconds: 1),
        onEvent: () {
          eventCompleter.complete();
        },
      );

      SchedulerCore.register(config);
      await eventCompleter.future;
      expect(eventCompleter.isCompleted, true);
    });

    test('should trigger count-based event when count is reached', () async {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.count,
        triggerCount: 2,
        onEvent: () {
          eventCompleter.complete();
        },
      );

      SchedulerCore.register(config);
      await SchedulerCore.track(testEventKey);
      await SchedulerCore.track(testEventKey);
      await eventCompleter.future;
      expect(eventCompleter.isCompleted, true);
    });

    test('should trigger recurrence event after interval', () async {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now().add(const Duration(milliseconds: 100)),
        recurrenceType: RecurrenceType.time,
        recurrenceInterval: const Duration(milliseconds: 100),
        onEvent: () {},
        recurrenceOnEvent: () {
          recurrenceCompleter.complete();
        },
      );

      SchedulerCore.register(config);
      await recurrenceCompleter.future;
      expect(recurrenceCompleter.isCompleted, true);
    });

    test('should update state correctly', () async {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now().add(const Duration(milliseconds: 100)),
        recurrenceInterval: const Duration(seconds: 1),
        onEvent: () {},
        onStateUpdate: (state) {
          if (!stateUpdateCompleter.isCompleted) {
            lastStateUpdate = state;
            stateUpdateCompleter.complete();
          }
        },
      );

      SchedulerCore.register(config);
      await stateUpdateCompleter.future;
      expect(lastStateUpdate, true);
    });

    test('should stop when end time is reached', () async {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now().add(const Duration(milliseconds: 50)),
        recurrenceInterval: const Duration(milliseconds: 50),
        endTime: DateTime.now().add(const Duration(milliseconds: 150)),
        onEvent: () {},
        onStateUpdate: (state) {
          lastStateUpdate = state;
          if (!state && !stateUpdateCompleter.isCompleted) {
            stateUpdateCompleter.complete();
          }
        },
      );

      SchedulerCore.register(config);
      await stateUpdateCompleter.future;
      expect(lastStateUpdate, false);
    });

    test('should get last trigger time', () async {
      final now = DateTime.now();
      final eventCompleter = Completer<void>();

      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: now.add(const Duration(milliseconds: 50)),
        recurrenceInterval: const Duration(seconds: 1),
        onEvent: () {
          eventCompleter.complete();
        },
      );

      SchedulerCore.register(config);
      await eventCompleter.future;
      final lastTriggerTime = await SchedulerCore.getLastTriggerTime(
        testEventKey,
      );
      expect(lastTriggerTime, isNotNull);
      expect(lastTriggerTime!.isAfter(now), true);
    });

    test('should reset event state', () async {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.time,
        triggerTime: DateTime.now().add(const Duration(milliseconds: 50)),
        recurrenceInterval: const Duration(seconds: 1),
        onEvent: () {},
        onStateUpdate: (state) {
          lastStateUpdate = state;
          if (!state && !stateUpdateCompleter.isCompleted) {
            stateUpdateCompleter.complete();
          }
        },
      );

      SchedulerCore.register(config);
      await SchedulerCore.reset(testEventKey);

      try {
        await stateUpdateCompleter.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            fail('Test timed out waiting for state reset');
          },
        );
        expect(lastStateUpdate, false);
      } catch (e) {
        fail('Test failed with error: $e');
      }
    });

    test('should handle count-based recurrence correctly', () async {
      final config = SchedulerConfig(
        eventKey: testEventKey,
        triggerType: TriggerType.count,
        triggerCount: 2,
        recurrenceType: RecurrenceType.count,
        recurrenceCount: 2,
        onEvent: () {},
        recurrenceOnEvent: () {
          recurrenceCompleter.complete();
        },
      );

      SchedulerCore.register(config);
      await SchedulerCore.track(testEventKey);
      await SchedulerCore.track(testEventKey);
      await SchedulerCore.track(testEventKey);
      await SchedulerCore.track(testEventKey);
      await recurrenceCompleter.future;
      expect(recurrenceCompleter.isCompleted, true);
    });
  });
}
