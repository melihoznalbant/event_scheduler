import 'package:event_scheduler/event_scheduler.dart';
import 'package:flutter/material.dart';

class ClickBasedSchedulerPage extends StatefulWidget {
  const ClickBasedSchedulerPage({super.key});

  @override
  State<ClickBasedSchedulerPage> createState() => _ClickBasedSchedulerPageState();
}

class _ClickBasedSchedulerPageState extends State<ClickBasedSchedulerPage> {
  int _counter = 0;
  bool _isActive = false;
  final String _eventKey = 'click_based_scheduler_page_event';
  late final DateTime _openTime;
  int _triggerCount = 0;

  @override
  void initState() {
    super.initState();
    _openTime = DateTime.now();
    _initializeScheduler();
  }

  void _initializeScheduler() async {
    
    final config = SchedulerConfig(
      eventKey: _eventKey,
      triggerType: TriggerType.count,
      triggerCount: 5, 
      recurrenceType: RecurrenceType.count,
      recurrenceCount: 2,  
      maxRecurrences: 4, 
      onEvent: () {
        _triggerCount++;
        setState(() {
          _isActive = true;
        });
        _showNotification('First trigger occurred!');
      },
      recurrenceOnEvent: () {
        _triggerCount++;
        setState(() {
          _isActive = true;
        });
        _showNotification('Recurrence occurred!');
      },
      onStateUpdate: (isActive) {
        setState(() {
          _isActive = isActive;
        });
      },
    );

    SchedulerCore.register(config);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    SchedulerCore.track(_eventKey);
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
        title: const Text('Click-based Scheduler (5 clicks, 5 triggers) Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'Scenario: This page demonstrates an event scheduler based on click count. '
              'The first event triggers after 5 clicks. '
              'After that, it repeats every 2 clicks. '
              'The event ends after a total of 5 triggers (1 initial + 4 recurrences). '
              'A notification is shown for each trigger.',
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
                    'Click Count: $_counter',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Trigger Count: $_triggerCount',
                    style: const TextStyle(fontSize: 18),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
} 