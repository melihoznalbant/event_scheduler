import 'package:event_scheduler/event_scheduler.dart';
import 'package:flutter/material.dart';

class TimeLimitedSchedulerPage extends StatefulWidget {
  const TimeLimitedSchedulerPage({super.key});

  @override
  State<TimeLimitedSchedulerPage> createState() => _TimeLimitedSchedulerPageState();
}

class _TimeLimitedSchedulerPageState extends State<TimeLimitedSchedulerPage> {
  bool _isActive = false;
  final String _eventKey = 'time_limited_scheduler_page_event';
  late final DateTime _openTime;

  @override
  void initState() {
    super.initState();
    _openTime = DateTime.now();
    _initializeScheduler();
  }

  void _initializeScheduler() async {
    final config = SchedulerConfig(
      eventKey: _eventKey,
      triggerType: TriggerType.time,
      triggerTime: DateTime.now(),
      recurrenceInterval: const Duration(seconds: 30),
      recurrenceType: RecurrenceType.time,
      endTime: DateTime.now().add(const Duration(minutes: 3)),
      onEvent: () {
        setState(() {
          _isActive = true;
        });
        _showNotification('First trigger occurred!');
      },
      recurrenceOnEvent: () {
        setState(() {
          _isActive = true;
        });
        _showNotification('Recurrence occurred!');
      },
      onStateUpdate: (isActive) {
        setState(() {
          _isActive = isActive;
        });
        if (!isActive) {
          _showNotification('3 minutes passed, recurrences stopped!');
        }
      },
    );

    SchedulerCore.register(config);
  }

  void _showNotification(String message) {
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    SchedulerCore.unregister(_eventKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time-limited Scheduler (3 min) Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'Scenario: This page demonstrates an event scheduler that works within a specific time range. '
              'The event starts when the page opens and continues for 3 minutes. '
              'A notification is shown every 30 seconds during this period. '
              'When the time is up, a final notification is shown and recurrences are stopped.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Page Open Time: ${_openTime.hour}:${_openTime.minute}:${_openTime.second}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Status: ${_isActive ? "Active" : "Inactive"}',
                    style: TextStyle(
                      color: _isActive ? Colors.green : Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 