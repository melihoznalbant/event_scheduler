import 'package:event_scheduler/event_scheduler_flutter.dart';

class SchedulerInitializer {
  static void initializeSchedulerEightPage({
    required String eventKey,
    required Function(bool) onStateUpdate,
    required Function(String) showNotification,
  }) {
    final config = SchedulerConfig(
      eventKey: eventKey,
      triggerType: TriggerType.time,
      triggerTime: DateTime.now(),
      recurrenceInterval: const Duration(seconds: 30),
      recurrenceType: RecurrenceType.time,
      onEvent: () {
        onStateUpdate(true);
        showNotification('First trigger occurred!');
      },
      recurrenceOnEvent: () {
        onStateUpdate(true);
        showNotification('Recurrence occurred!');
      },
      onStateUpdate: onStateUpdate,
    );

    SchedulerCore.register(config);
  }
}
