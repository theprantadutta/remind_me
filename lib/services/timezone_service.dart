import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

import 'logger_service.dart';

/// Service for managing timezone with auto-detection
class TimezoneService {
  static TimezoneService? _instance;

  TimezoneService._();

  /// Get the singleton instance
  static TimezoneService get instance {
    _instance ??= TimezoneService._();
    return _instance!;
  }

  static const String _timezoneKey = 'user_timezone';
  static const String _tag = 'TimezoneService';

  final LoggerService _logger = LoggerService.instance;

  bool _isInitialized = false;
  String _currentTimezone = 'UTC';

  /// Whether the service is initialized
  bool get isInitialized => _isInitialized;

  /// Current timezone name
  String get currentTimezone => _currentTimezone;

  /// Current timezone location
  tz.Location get currentLocation => tz.local;

  /// Initialize timezone with auto-detection
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.debug('Already initialized', tag: _tag);
      return;
    }

    try {
      // Initialize timezone database
      tz_data.initializeTimeZones();

      // Try to get saved timezone first
      final savedTimezone = await _getSavedTimezone();

      // If no saved timezone, detect from device
      final detectedTimezone = savedTimezone ?? await _detectDeviceTimezone();

      // Set the timezone
      await _setTimezone(detectedTimezone);

      _isInitialized = true;
      _logger.info('Initialized with timezone: $_currentTimezone', tag: _tag);
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to initialize timezone, falling back to UTC',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );

      // Fallback to UTC
      tz.setLocalLocation(tz.UTC);
      _currentTimezone = 'UTC';
      _isInitialized = true;
    }
  }

  /// Detect device timezone
  Future<String> _detectDeviceTimezone() async {
    try {
      final now = DateTime.now();
      final offset = now.timeZoneOffset;

      _logger.debug(
        'Device timezone offset: ${offset.inHours}h ${offset.inMinutes % 60}m',
        tag: _tag,
      );

      // Try to match timezone based on offset
      return _matchTimezoneByOffset(offset);
    } catch (e) {
      _logger.warning('Failed to detect timezone: $e', tag: _tag);
      return 'UTC';
    }
  }

  /// Match timezone by offset
  String _matchTimezoneByOffset(Duration offset) {
    final offsetMinutes = offset.inMinutes;

    // Common timezone mappings based on offset in minutes
    final timezoneMap = {
      // Asia
      330: 'Asia/Kolkata', // UTC+5:30
      345: 'Asia/Kathmandu', // UTC+5:45
      360: 'Asia/Dhaka', // UTC+6
      390: 'Asia/Yangon', // UTC+6:30
      420: 'Asia/Bangkok', // UTC+7
      480: 'Asia/Singapore', // UTC+8
      540: 'Asia/Tokyo', // UTC+9
      570: 'Australia/Adelaide', // UTC+9:30

      // Middle East
      180: 'Asia/Riyadh', // UTC+3
      210: 'Asia/Tehran', // UTC+3:30
      240: 'Asia/Dubai', // UTC+4
      270: 'Asia/Kabul', // UTC+4:30
      300: 'Asia/Karachi', // UTC+5

      // Europe
      0: 'UTC', // UTC+0
      60: 'Europe/Paris', // UTC+1
      120: 'Europe/Athens', // UTC+2

      // Americas
      -300: 'America/New_York', // UTC-5
      -360: 'America/Chicago', // UTC-6
      -420: 'America/Denver', // UTC-7
      -480: 'America/Los_Angeles', // UTC-8
      -540: 'America/Anchorage', // UTC-9
      -600: 'Pacific/Honolulu', // UTC-10

      // Others
      600: 'Australia/Sydney', // UTC+10
      660: 'Pacific/Noumea', // UTC+11
      720: 'Pacific/Auckland', // UTC+12
    };

    final timezone = timezoneMap[offsetMinutes];
    if (timezone != null) {
      _logger.debug('Matched timezone: $timezone for offset $offsetMinutes', tag: _tag);
      return timezone;
    }

    // If no exact match, find closest
    int closestOffset = 0;
    int minDiff = 999999;

    for (final tz in timezoneMap.keys) {
      final diff = (tz - offsetMinutes).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestOffset = tz;
      }
    }

    final fallback = timezoneMap[closestOffset] ?? 'UTC';
    _logger.warning(
      'No exact match for offset $offsetMinutes, using closest: $fallback',
      tag: _tag,
    );
    return fallback;
  }

  /// Set the active timezone
  Future<void> _setTimezone(String timezoneName) async {
    try {
      final location = tz.getLocation(timezoneName);
      tz.setLocalLocation(location);
      _currentTimezone = timezoneName;
      await _saveTimezone(timezoneName);
      _logger.info('Timezone set to: $timezoneName', tag: _tag);
    } catch (e) {
      _logger.warning('Invalid timezone: $timezoneName, falling back to UTC', tag: _tag);
      tz.setLocalLocation(tz.UTC);
      _currentTimezone = 'UTC';
    }
  }

  /// Get saved timezone from preferences
  Future<String?> _getSavedTimezone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_timezoneKey);
    } catch (e) {
      _logger.warning('Failed to get saved timezone: $e', tag: _tag);
      return null;
    }
  }

  /// Save timezone to preferences
  Future<void> _saveTimezone(String timezone) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_timezoneKey, timezone);
    } catch (e) {
      _logger.warning('Failed to save timezone: $e', tag: _tag);
    }
  }

  /// Convert DateTime to TZDateTime
  tz.TZDateTime toTZDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  /// Get current time in local timezone
  tz.TZDateTime now() {
    return tz.TZDateTime.now(tz.local);
  }

  /// Check if timezone has changed (call on app resume)
  Future<bool> checkTimezoneChange() async {
    try {
      final currentOffset = DateTime.now().timeZoneOffset;
      final savedTimezone = await _getSavedTimezone();

      if (savedTimezone != null) {
        final savedLocation = tz.getLocation(savedTimezone);
        final savedOffset = tz.TZDateTime.now(savedLocation).timeZoneOffset;

        if (currentOffset != savedOffset) {
          _logger.info(
            'Timezone change detected: $savedOffset -> $currentOffset',
            tag: _tag,
          );

          // Re-detect and update timezone
          final newTimezone = await _detectDeviceTimezone();
          await _setTimezone(newTimezone);
          return true;
        }
      }
      return false;
    } catch (e) {
      _logger.warning('Error checking timezone change: $e', tag: _tag);
      return false;
    }
  }

  /// Get formatted timezone offset string
  String getOffsetString() {
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final sign = offset.isNegative ? '-' : '+';
    return 'UTC$sign$hours:$minutes';
  }

  /// Get all available timezones
  List<String> getAvailableTimezones() {
    return tz.timeZoneDatabase.locations.keys.toList()..sort();
  }

  /// Manually set timezone (for user preference)
  Future<void> setUserTimezone(String timezone) async {
    await _setTimezone(timezone);
  }
}
