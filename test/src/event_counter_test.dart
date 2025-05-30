import 'package:event_scheduler/src/event_counter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('EventCounter Tests', () {
    const String testEventKey = 'test_event';
    late EventCounter eventCounter;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      eventCounter = EventCounter();
    });

    test('incrementCounter should increase counter by 1', () async {
      // Initial counter should be 0
      expect(await eventCounter.getCounter(testEventKey), 0);

      // Increment counter
      await eventCounter.incrementCounter(testEventKey);
      expect(await eventCounter.getCounter(testEventKey), 1);

      // Increment again
      await eventCounter.incrementCounter(testEventKey);
      expect(await eventCounter.getCounter(testEventKey), 2);
    });

    test('setLastTriggerTime and getLastTriggerTime should work correctly', () async {
      final now = DateTime.now();
      
      // Initially should be null
      expect(await eventCounter.getLastTriggerTime(testEventKey), null);

      // Set trigger time
      await eventCounter.setLastTriggerTime(testEventKey, now);
      final retrievedTime = await eventCounter.getLastTriggerTime(testEventKey);
      
      expect(retrievedTime, isNotNull);
      expect(retrievedTime!.toIso8601String(), now.toIso8601String());
    });

    test('incrementRecurrenceCounter should increase recurrence count by 1', () async {
      // Initial recurrence count should be 0
      expect(await eventCounter.getRecurrenceCounter(testEventKey), 0);

      // Increment recurrence counter
      await eventCounter.incrementRecurrenceCounter(testEventKey);
      expect(await eventCounter.getRecurrenceCounter(testEventKey), 1);

      // Increment again
      await eventCounter.incrementRecurrenceCounter(testEventKey);
      expect(await eventCounter.getRecurrenceCounter(testEventKey), 2);
    });

    test('setFirstOpenTime should only set time if not already set', () async {
      final firstTime = DateTime.now();
      final secondTime = firstTime.add(const Duration(hours: 1));

      // Set first open time
      await eventCounter.setFirstOpenTime(testEventKey, firstTime);
      expect(await eventCounter.getFirstOpenTime(testEventKey), firstTime);

      // Try to set again with different time
      await eventCounter.setFirstOpenTime(testEventKey, secondTime);
      // Should still have the first time
      expect(await eventCounter.getFirstOpenTime(testEventKey), firstTime);
    });

    test('resetEvent should clear all event data', () async {
      // Set up some data
      await eventCounter.incrementCounter(testEventKey);
      await eventCounter.setLastTriggerTime(testEventKey, DateTime.now());
      await eventCounter.incrementRecurrenceCounter(testEventKey);
      await eventCounter.setFirstOpenTime(testEventKey, DateTime.now());

      // Verify data exists
      expect(await eventCounter.getCounter(testEventKey), 1);
      expect(await eventCounter.getLastTriggerTime(testEventKey), isNotNull);
      expect(await eventCounter.getRecurrenceCounter(testEventKey), 1);
      expect(await eventCounter.getFirstOpenTime(testEventKey), isNotNull);

      // Reset event
      await eventCounter.resetEvent(testEventKey);

      // Verify all data is cleared
      expect(await eventCounter.getCounter(testEventKey), 0);
      expect(await eventCounter.getLastTriggerTime(testEventKey), null);
      expect(await eventCounter.getRecurrenceCounter(testEventKey), 0);
      expect(await eventCounter.getFirstOpenTime(testEventKey), null);
    });

    test('EventCounter should be singleton', () {
      final instance1 = EventCounter();
      final instance2 = EventCounter();
      expect(instance1, same(instance2));
    });
  });
}
