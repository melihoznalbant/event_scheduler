import 'package:event_scheduler/event_scheduler.dart';
import 'package:flutter/material.dart';
import 'scheduler_initializes.dart';

class ModularSchedulerPage extends StatefulWidget {
  const ModularSchedulerPage({super.key});

  @override
  State<ModularSchedulerPage> createState() => _ModularSchedulerPageState();
}

class _ModularSchedulerPageState extends State<ModularSchedulerPage> {
  bool _isActive = false;
  final String _eventKey = 'modular_scheduler_page_event';
  late final DateTime _openTime;

  @override
  void initState() {
    super.initState();
    _openTime = DateTime.now();
    _initializeScheduler();
  }

  void _initializeScheduler() async {
    SchedulerInitializer.initializeSchedulerEightPage(
      eventKey: _eventKey,
      onStateUpdate: (isActive) {
        setState(() {
          _isActive = isActive;
        });
      },
      showNotification: _showNotification,
    );
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
        title: const Text('Modular Scheduler (Initializer) Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'Scenario: This page uses the SchedulerInitializer class to start the event scheduler. '
              'The event scheduler\'s configuration and behavior are defined in the SchedulerInitializer class. '
              'This approach provides a more modular structure by separating the event scheduler logic from the page.',
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
