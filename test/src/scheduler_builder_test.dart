import 'package:event_scheduler/event_scheduler_flutter.dart';
import 'package:event_scheduler/src/scheduler_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EventSchedulerBuilder Tests', () {
    late EventSchedulerBuilder builder;
    const String testEventKey = 'test_event';

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPreferences.getInstance();
      builder = EventSchedulerBuilder();
    });

    test('Builder should throw exception when required fields are missing', () {
      expect(
        () => builder.build(),
        throwsException,
      );
    });

    test('Builder should set event key correctly', () {
      builder.setEventKey(testEventKey);
      expect(
        () => builder.build(),
        throwsException,
      );
    });

    test('Builder should set trigger type correctly', () {
      builder
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.time)
        ..setOnEvent(() {});

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });

    test('Builder should set recurrence type correctly', () {
      builder
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.time)
        ..setRecurrenceType(RecurrenceType.time)
        ..setOnEvent(() {});

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });

    test('Builder should set trigger time correctly', () {
      final now = DateTime.now();
      builder
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.time)
        ..setTriggerTime(now)
        ..setOnEvent(() {});

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });

    test('Builder should set trigger count correctly', () {
      builder
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.count)
        ..setTriggerCount(5)
        ..setOnEvent(() {});

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });

    test('Builder should set recurrence interval correctly', () {
      builder
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.time)
        ..setRecurrenceType(RecurrenceType.time)
        ..setRecurrenceInterval(const Duration(minutes: 5))
        ..setOnEvent(() {});

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });

    test('Builder should set recurrence count correctly', () {
      builder
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.time)
        ..setRecurrenceType(RecurrenceType.count)
        ..setRecurrenceCount(3)
        ..setOnEvent(() {});

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });

    test('Builder should set max recurrences correctly', () {
      builder
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.time)
        ..setRecurrenceType(RecurrenceType.time)
        ..setMaxRecurrences(5)
        ..setOnEvent(() {});

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });

    test('Builder should set end time correctly', () {
      final endTime = DateTime.now().add(const Duration(hours: 1));
      builder
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.time)
        ..setEndTime(endTime)
        ..setOnEvent(() {});

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });

    test('Builder should support method chaining', () async {
      final builder = EventSchedulerBuilder()
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.time)
        ..setRecurrenceType(RecurrenceType.time)
        ..setTriggerTime(DateTime.now())
        ..setRecurrenceInterval(const Duration(minutes: 5))
        ..setOnEvent(() {});

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });

    test('Builder should create valid SchedulerConfig', () async {
      final now = DateTime.now();
      onEvent() {}
      recurrenceOnEvent() {}
      onStateUpdate(bool state) {}

      builder
        ..setEventKey(testEventKey)
        ..setTriggerType(TriggerType.time)
        ..setRecurrenceType(RecurrenceType.time)
        ..setTriggerTime(now)
        ..setRecurrenceInterval(const Duration(minutes: 5))
        ..setMaxRecurrences(3)
        ..setOnEvent(onEvent)
        ..setRecurrenceOnEvent(recurrenceOnEvent)
        ..setOnStateUpdate(onStateUpdate);

      expect(
        () => builder.build(),
        isNot(throwsException),
      );
    });
  });
}
