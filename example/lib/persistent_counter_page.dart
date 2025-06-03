import 'dart:async';
import 'package:event_scheduler/event_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistentCounterPage extends StatefulWidget {
  const PersistentCounterPage({super.key});

  @override
  State<PersistentCounterPage> createState() => _PersistentCounterPageState();
}

class _PersistentCounterPageState extends State<PersistentCounterPage> {
  int _counter = 300;
  bool _isInitialized = false;
  static const String _eventKey = 'persistent_counter_page_open';
  static const String _counterKey = 'persistent_counter_page_counter';

  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadState();
    _initializeScheduler();
  }

  Future<void> _loadState() async {
    setState(() {
      _counter = _prefs.getInt(_counterKey) ?? 300;
    });
  }

  Future<void> _saveCounterState() async {
    await _prefs.setInt(_counterKey, _counter);
  }

  void _initializeScheduler() {
    if (!_isInitialized) {
      SchedulerCore.register(
        SchedulerConfig(
          eventKey: _eventKey,
          triggerType: TriggerType.time,
          triggerTime: DateTime.now(),
          recurrenceType: RecurrenceType.time,
          recurrenceInterval: const Duration(seconds: 30),
          onEvent: _handleFirstTrigger,
          recurrenceOnEvent: _handleRecurrenceTrigger,
        ),
      );
      _isInitialized = true;
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _saveCounterState();
  }

  void _handleFirstTrigger() {
    if (!mounted) return;

    setState(() {
      _counter += 5;
    });
    _saveCounterState();
  }

  void _handleRecurrenceTrigger() {
    if (!mounted) return;

    setState(() {
      _counter += 2;
    });
    _saveCounterState();
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Persistent Counter (+5, +2 every 30s) Page'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'Scenario: This page uses SharedPreferences to persistently store the counter value. '
              'An event scheduler is started when the page opens. '
              'The counter increases by 5 on first trigger, then by 2 every 30 seconds. '
              'The counter can also be incremented manually.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Current value:'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Son güncelleme: ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                    style: const TextStyle(fontSize: 14),
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
