
import 'package:event_scheduler/event_scheduler_flutter.dart';
import 'package:flutter/material.dart';

class PageOpenCounterPage extends StatefulWidget {
  const PageOpenCounterPage({super.key});

  @override
  State<PageOpenCounterPage> createState() => _PageOpenCounterPageState();
}

class _PageOpenCounterPageState extends State<PageOpenCounterPage> {
  int _counter = 100;
  bool _isInitialized = false;
  static int _pageOpenCount = 0;
  static const String _eventKey = 'page_open_counter_page_open';

  @override
  void initState() {
    super.initState();
    _pageOpenCount++;
    _initializeScheduler();
  }

  void _initializeScheduler() {
    if (!_isInitialized) {
      setupSecondPageCallback(_showLikeDialog);
      SchedulerCore.track(_eventKey);
      _isInitialized = true;
    }
  }

  void _showLikeDialog() {
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Information'),
          content: const Text('Do you like this page?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Page Open Counter (3 opens) Page'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'Scenario: This page tracks the number of times it has been opened. '
              'A like dialog is shown when the page is opened 3 times. '
              'It also contains a counter that decreases when the button is clicked.',
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
                    'Page Open Count: $_pageOpenCount',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _decrementCounter,
        tooltip: 'Decrement',
        child: const Icon(Icons.remove),
      ),
    );
  }
}

void Function()? _showDialogCallback;
bool _isSchedulerRegistered = false;

void setupSecondPageCallback(void Function() showDialog) {
  _showDialogCallback = showDialog;
  
  if (!_isSchedulerRegistered) {
    SchedulerCore.register(
      SchedulerConfig(
        eventKey: _PageOpenCounterPageState._eventKey,
        triggerType: TriggerType.count,
        triggerCount: 3,
        recurrenceType: RecurrenceType.none,
        onEvent: () {
          if (_showDialogCallback != null) {
            _showDialogCallback!();
          }
        },
      ),
    );
    _isSchedulerRegistered = true;
  }
}
 