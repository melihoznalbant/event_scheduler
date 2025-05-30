import 'package:shared_preferences/shared_preferences.dart';

class EventCounter {
  static final EventCounter _instance = EventCounter._internal();
  factory EventCounter() => _instance;
  EventCounter._internal();

  static const String _counterPrefix = 'event_counter_';
  static const String _lastTriggerPrefix = 'last_trigger_';
  static const String _recurrencePrefix = 'recurrence_';
  static const String _firstOpenPrefix = 'first_open_';

  Future<void> incrementCounter(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _counterPrefix + eventKey;
    final currentCount = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCount + 1);
  }

  Future<int> getCounter(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _counterPrefix + eventKey;
    return prefs.getInt(key) ?? 0;
  }

  Future<void> setLastTriggerTime(String eventKey, DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _lastTriggerPrefix + eventKey;
    await prefs.setString(key, time.toIso8601String());
  }

  Future<DateTime?> getLastTriggerTime(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _lastTriggerPrefix + eventKey;
    final timeStr = prefs.getString(key);
    if (timeStr == null) return null;
    return DateTime.parse(timeStr);
  }

  Future<void> incrementRecurrenceCounter(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _recurrencePrefix + eventKey;
    final currentCount = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCount + 1);
  }

  Future<int> getRecurrenceCounter(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _recurrencePrefix + eventKey;
    return prefs.getInt(key) ?? 0;
  }

  Future<void> setFirstOpenTime(String eventKey, DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _firstOpenPrefix + eventKey;
    if (!prefs.containsKey(key)) {
      await prefs.setString(key, time.toIso8601String());
    }
  }

  Future<DateTime?> getFirstOpenTime(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _firstOpenPrefix + eventKey;
    final timeStr = prefs.getString(key);
    if (timeStr == null) return null;
    return DateTime.parse(timeStr);
  }

  Future<void> resetEvent(String eventKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_counterPrefix + eventKey);
    await prefs.remove(_lastTriggerPrefix + eventKey);
    await prefs.remove(_recurrencePrefix + eventKey);
    await prefs.remove(_firstOpenPrefix + eventKey);
  }
} 