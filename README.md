<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Event Scheduler

A powerful Flutter package that provides flexible event scheduling capabilities based on time or count triggers, with support for recurring events.

## Features

- ⏰ **Time-based Triggers**: Schedule events to occur at specific times or intervals
- 🔢 **Count-based Triggers**: Trigger events after a specific number of occurrences
- 🔄 **Recurring Events**: Support for both time-based and count-based recurrence
- ⚡ **Customizable Intervals**: Set custom intervals for recurring events
- 🎯 **Maximum Recurrence Limits**: Limit how many times an event can recur
- 📅 **End Time Support**: Set when events should stop recurring
- 🔔 **State Management**: Track event states and get notified of changes
- 🏗️ **Builder Pattern**: Easy configuration using a fluent interface

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  event_scheduler: ^1.0.0
```

## Usage

### Time-based Trigger

```dart
EventSchedulerBuilder()
  .setEventKey('my_time_event')
  .setTriggerType(TriggerType.time)
  .setTriggerTime(DateTime.now().add(Duration(minutes: 5)))
  .setRecurrenceInterval(Duration(minutes: 30))
  .setOnEvent(() {
    print('Event triggered!');
  })
  .build();
```

### Count-based Trigger

```dart
EventSchedulerBuilder()
  .setEventKey('my_count_event')
  .setTriggerType(TriggerType.count)
  .setTriggerCount(5)
  .setOnEvent(() {
    print('Event triggered after 5 occurrences!');
  })
  .build();

// Track the event
SchedulerCore.track('my_count_event');
```

### Hybrid Trigger with Recurrence

```dart
EventSchedulerBuilder()
  .setEventKey('my_hybrid_event')
  .setTriggerType(TriggerType.time)
  .setTriggerTime(DateTime.now().add(Duration(minutes: 5)))
  .setRecurrenceType(RecurrenceType.count)
  .setRecurrenceCount(3)
  .setMaxRecurrences(5)
  .setOnEvent(() {
    print('Initial event triggered!');
  })
  .setRecurrenceOnEvent(() {
    print('Recurrence event triggered!');
  })
  .build();
```

## Detailed Features

### Trigger Types

- **Time-based**: Events trigger at specific times or intervals
- **Count-based**: Events trigger after a specific number of occurrences
- **Hybrid**: Combine both time and count-based triggers

### Recurrence Types

- **None**: Event triggers only once
- **Time**: Event recurs at specific time intervals
- **Count**: Event recurs after specific count intervals

### Customization Options

- **Event Key**: Unique identifier for each event
- **Trigger Time**: When time-based events should trigger
- **Trigger Count**: How many occurrences needed for count-based events
- **Recurrence Interval**: Time between recurring events
- **Recurrence Count**: Number of occurrences between recurrences
- **Max Recurrences**: Maximum number of times an event can recur
- **End Time**: When the event should stop recurring
- **Callbacks**: Custom handlers for events and state changes

## Example Applications

The package includes several example applications demonstrating different use cases:

- Basic time-based scheduling
- Count-based event tracking
- Recurring event management
- State management integration
- Builder pattern usage

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Contact

If you have any questions or suggestions, please open an issue in the GitHub repository.
