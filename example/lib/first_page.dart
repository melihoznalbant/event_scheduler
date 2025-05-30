import 'package:example/time_based_scheduler_page.dart';
import 'package:flutter/material.dart';
import 'page_open_counter_page.dart';
import 'persistent_counter_page.dart';
import 'time_limited_scheduler_page.dart';
import 'click_based_scheduler_page.dart';
import 'hybrid_scheduler_page.dart';
import 'modular_scheduler_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _navigateToSecondPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PageOpenCounterPage()),
    );
  }

  void _navigateToThirdPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TimeBasedSchedulerPage()),
    );
  }

  void _navigateToFourthPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PersistentCounterPage()),
    );
  }

  void _navigateToFifthPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TimeLimitedSchedulerPage()),
    );
  }

  void _navigateToSixthPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClickBasedSchedulerPage()),
    );
  }

  void _navigateToSeventhPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HybridSchedulerPage()),
    );
  }

  void _navigateToEighthPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ModularSchedulerPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              'Scenario: This page contains a counter that tracks button clicks. '
              'A dialog is shown when the button is clicked 5 times. '
              'It also contains buttons to navigate to other example pages.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        ElevatedButton(
                          onPressed: _navigateToSecondPage,
                          child: const Text('Page Open Counter (3 opens)'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _navigateToThirdPage,
                          child: const Text('Time-based Scheduler (30s interval)'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _navigateToFourthPage,
                          child: const Text('Persistent Counter (+5, +2 every 30s)'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _navigateToFifthPage,
                          child: const Text('Time-limited Scheduler (3 min)'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _navigateToSixthPage,
                          child: const Text('Click-based Scheduler (5 clicks, 5 triggers)'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _navigateToSeventhPage,
                          child: const Text('Hybrid Scheduler (5 clicks, 1 min)'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _navigateToEighthPage,
                          child: const Text('Modular Scheduler (Initializer)'),
                        ),
                      ],
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
