import 'package:shared_preferences/shared_preferences.dart';

/// A singleton class that manages event counting and timing using SharedPreferences.
/// 
/// This class provides methods to track:
/// * Event occurrence counts
/// * Last trigger times
/// * Recurrence counts
/// * First open times
/// 
/// All data is persisted using SharedPreferences for app restarts.
class EventCounter {
  static final EventCounter _instance = EventCounter._internal();
  factory EventCounter() => _instance;
  EventCounter._internal();

  static const String _counterPrefix = 'event_counter_';
  static const String _lastTriggerPrefix = 'last_trigger_';
  static const String _recurrencePrefix = 'recurrence_';
  static const String _firstOpenPrefix = 'first_open_';

  /// Increments the counter for a specific event.
  /// 
  /// This method increases the count of occurrences for the given event.
  /// The count is persisted and can be retrieved later.
  Future<void> incrementCounter(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _counterPrefix + eventKey;
    final currentCount = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCount + 1);
  }

  /// Gets the current count for a specific event.
  /// 
  /// Returns the number of times the event has occurred.
  /// Returns 0 if the event has never occurred.
  Future<int> getCounter(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _counterPrefix + eventKey;
    return prefs.getInt(key) ?? 0;
  }

  /// Sets the last trigger time for an event.
  /// 
  /// This method stores the time when an event was last triggered.
  /// The time is stored in ISO 8601 format.
  Future<void> setLastTriggerTime(String eventKey, DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _lastTriggerPrefix + eventKey;
    await prefs.setString(key, time.toIso8601String());
  }

  /// Gets the last trigger time for an event.
  /// 
  /// Returns the DateTime when the event was last triggered.
  /// Returns null if the event has never been triggered.
  Future<DateTime?> getLastTriggerTime(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _lastTriggerPrefix + eventKey;
    final timeStr = prefs.getString(key);
    if (timeStr == null) return null;
    return DateTime.parse(timeStr);
  }

  /// Increments the recurrence counter for an event.
  /// 
  /// This method increases the count of recurrences for the given event.
  /// The count is persisted and can be retrieved later.
  Future<void> incrementRecurrenceCounter(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _recurrencePrefix + eventKey;
    final currentCount = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCount + 1);
  }

  /// Gets the current recurrence count for an event.
  /// 
  /// Returns the number of times the event has recurred.
  /// Returns 0 if the event has never recurred.
  Future<int> getRecurrenceCounter(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _recurrencePrefix + eventKey;
    return prefs.getInt(key) ?? 0;
  }

  /// Sets the first open time for an event.
  /// 
  /// This method stores the time when an event was first opened.
  /// The time is only stored if it hasn't been set before.
  /// The time is stored in ISO 8601 format.
  Future<void> setFirstOpenTime(String eventKey, DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _firstOpenPrefix + eventKey;
    if (!prefs.containsKey(key)) {
      await prefs.setString(key, time.toIso8601String());
    }
  }

  /// Gets the first open time for an event.
  /// 
  /// Returns the DateTime when the event was first opened.
  /// Returns null if the event has never been opened.
  Future<DateTime?> getFirstOpenTime(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _firstOpenPrefix + eventKey;
    final timeStr = prefs.getString(key);
    if (timeStr == null) return null;
    return DateTime.parse(timeStr);
  }

  /// Resets all tracking data for an event.
  /// 
  /// This method clears all stored data for the given event, including:
  /// * Event counter
  /// * Last trigger time
  /// * Recurrence counter
  /// * First open time
  Future<void> resetEvent(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_counterPrefix + eventKey);
    await prefs.remove(_lastTriggerPrefix + eventKey);
    await prefs.remove(_recurrencePrefix + eventKey);
    await prefs.remove(_firstOpenPrefix + eventKey);
  }
} 