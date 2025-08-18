import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Professional BlocObserver with advanced debugging capabilities
class ProfessionalBlocObserver extends BlocObserver {
  // Configuration
  final bool enabled;
  final bool showCreateClose;
  final bool showStateChanges;
  final bool showTransitions;
  final bool showPerformanceMetrics;
  final bool useColors;
  final bool logToConsole;
  final bool logToDevTools;

  // Tracking maps
  final Map<String, List<BlocBase>> _activeBlocsByType = {};
  final Map<BlocBase, DateTime> _blocCreationTimes = {};
  final Map<BlocBase, String> _blocIds = {};
  final Map<String, int> _eventCounts = {};
  final Map<String, Duration> _totalProcessingTimes = {};

  // Statistics
  int _totalBlocsCreated = 0;
  int _totalStateChanges = 0;
  int _totalEvents = 0;

  ProfessionalBlocObserver({
    this.enabled = true,
    this.showCreateClose = true,
    this.showStateChanges = true,
    this.showTransitions = true,
    this.showPerformanceMetrics = true,
    this.useColors = true,
    this.logToConsole = false,
    this.logToDevTools = kDebugMode,
  });

  // ANSI Color codes
  static const String _reset = '\x1B[0m';
  static const String _bold = '\x1B[1m';
  static const String _dim = '\x1B[2m';
  static const String _underline = '\x1B[4m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  static const String _white = '\x1B[37m';
  static const String _brightRed = '\x1B[91m';
  static const String _brightGreen = '\x1B[92m';
  static const String _brightYellow = '\x1B[93m';
  static const String _brightBlue = '\x1B[94m';
  static const String _brightCyan = '\x1B[96m';

  @override
  void onCreate(BlocBase bloc) {
    if (!enabled) return;
    super.onCreate(bloc);

    final blocType = bloc.runtimeType.toString();
    final blocId = _generateBlocId(bloc);

    // Track creation
    _activeBlocsByType.putIfAbsent(blocType, () => []).add(bloc);
    _blocCreationTimes[bloc] = DateTime.now();
    _blocIds[bloc] = blocId;
    _totalBlocsCreated++;

    if (showCreateClose) {
      _logBlocCreation(bloc, blocType, blocId);
    }

    _logGlobalStatistics();
  }

  @override
  void onClose(BlocBase bloc) {
    if (!enabled) return;
    super.onClose(bloc);

    final blocType = bloc.runtimeType.toString();
    final blocId = _blocIds[bloc] ?? 'unknown';
    final lifespan = _calculateLifespan(bloc);

    // Remove from tracking
    _activeBlocsByType[blocType]?.remove(bloc);
    if (_activeBlocsByType[blocType]?.isEmpty == true) {
      _activeBlocsByType.remove(blocType);
    }
    _blocCreationTimes.remove(bloc);
    _blocIds.remove(bloc);

    if (showCreateClose) {
      _logBlocClosure(bloc, blocType, blocId, lifespan);
    }

    _logGlobalStatistics();
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (!enabled) return;
    super.onChange(bloc, change);

    _totalStateChanges++;
    final blocType = bloc.runtimeType.toString();

    if (showStateChanges) {
      _logStateChange(bloc, blocType, change);
    }
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition transition) {
    if (!enabled) return;
    super.onTransition(bloc, transition);

    _totalEvents++;
    final eventType = transition.event.runtimeType.toString();
    final blocType = bloc.runtimeType.toString();

    _eventCounts[eventType] = (_eventCounts[eventType] ?? 0) + 1;

    if (showTransitions) {
      final stopwatch = Stopwatch()..start();
      // Log transition
      _logTransition(bloc, blocType, transition);
      stopwatch.stop();

      if (showPerformanceMetrics) {
        _totalProcessingTimes[eventType] =
            (_totalProcessingTimes[eventType] ?? Duration.zero) +
            stopwatch.elapsed;
      }
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    if (!enabled) return;
    super.onEvent(bloc, event);

    if (logToDevTools) {
      developer.log(
        'Event: ${event.runtimeType}',
        name: 'BlocObserver.${bloc.runtimeType}',
        level: 800,
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (!enabled) return;
    super.onError(bloc, error, stackTrace);

    _logError(bloc, error, stackTrace);
  }

  // ══════════════════════════════════════════════════════════════
  // LOGGING METHODS
  // ══════════════════════════════════════════════════════════════

  void _logBlocCreation(BlocBase bloc, String blocType, String blocId) {
    final instanceCount = _activeBlocsByType[blocType]?.length ?? 0;
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);

    final buffer = StringBuffer();

    // Header
    buffer.writeln(
      _colorize(
        '╔══════════════════════════════════════════════════════════════════════════╗',
        _brightGreen,
      ),
    );
    buffer.writeln(
      _colorize('║ ${_pad('🚀 BLOC CREATED', 70)} ║', _brightGreen),
    );
    buffer.writeln(
      _colorize(
        '╠══════════════════════════════════════════════════════════════════════════╣',
        _brightGreen,
      ),
    );

    // Main info
    buffer.writeln(
      _colorize('║ ${_padKeyValue('Type', blocType, 68)} ║', _white),
    );
    buffer.writeln(_colorize('║ ${_padKeyValue('ID', blocId, 68)} ║', _cyan));
    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Instances of this type', instanceCount.toString(), 68)} ║',
        _yellow,
      ),
    );
    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Total Blocs Created', _totalBlocsCreated.toString(), 68)} ║',
        _magenta,
      ),
    );
    buffer.writeln(
      _colorize('║ ${_padKeyValue('Time', timestamp, 68)} ║', _dim),
    );
    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Memory Hash', bloc.hashCode.toString(), 68)} ║',
        _dim,
      ),
    );

    // Current state info
    if (bloc.state != null) {
      final stateInfo = _extractCompleteStateInfo(bloc.state);
      buffer.writeln(
        _colorize(
          '╠──────────────────────── INITIAL STATE ─────────────────────────╢',
          _blue,
        ),
      );

      stateInfo.forEach((key, value) {
        buffer.writeln(
          _colorize('║ ${_padKeyValue(key, value.toString(), 68)} ║', _blue),
        );
      });
    }

    // Active blocs summary
    if (_activeBlocsByType.isNotEmpty) {
      buffer.writeln(
        _colorize(
          '╠────────────────────── ACTIVE BLOCS SUMMARY ───────────────────────╢',
          _brightCyan,
        ),
      );

      _activeBlocsByType.forEach((type, instances) {
        buffer.writeln(
          _colorize(
            '║ ${_padKeyValue(type, '${instances.length} instance(s)', 68)} ║',
            _cyan,
          ),
        );
      });
    }

    buffer.writeln(
      _colorize(
        '╚══════════════════════════════════════════════════════════════════════════╝',
        _brightGreen,
      ),
    );

    _log(buffer.toString());
  }

  void _logBlocClosure(
    BlocBase bloc,
    String blocType,
    String blocId,
    Duration lifespan,
  ) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final remainingInstances = _activeBlocsByType[blocType]?.length ?? 0;

    final buffer = StringBuffer();

    buffer.writeln(
      _colorize(
        '╔══════════════════════════════════════════════════════════════════════════╗',
        _brightRed,
      ),
    );
    buffer.writeln(
      _colorize('║ ${_pad('🗑️  BLOC CLOSED', 70)} ║', _brightRed),
    );
    buffer.writeln(
      _colorize(
        '╠══════════════════════════════════════════════════════════════════════════╣',
        _brightRed,
      ),
    );

    buffer.writeln(
      _colorize('║ ${_padKeyValue('Type', blocType, 68)} ║', _white),
    );
    buffer.writeln(_colorize('║ ${_padKeyValue('ID', blocId, 68)} ║', _cyan));
    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Lifespan', '${lifespan.inMilliseconds}ms', 68)} ║',
        _yellow,
      ),
    );
    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Remaining Instances', remainingInstances.toString(), 68)} ║',
        _magenta,
      ),
    );
    buffer.writeln(
      _colorize('║ ${_padKeyValue('Time', timestamp, 68)} ║', _dim),
    );

    buffer.writeln(
      _colorize(
        '╚══════════════════════════════════════════════════════════════════════════╝',
        _brightRed,
      ),
    );

    _log(buffer.toString());
  }

  void _logStateChange(BlocBase bloc, String blocType, Change change) {
    final blocId = _blocIds[bloc] ?? 'unknown';
    final currentStateInfo = _extractCompleteStateInfo(change.currentState);
    final nextStateInfo = _extractCompleteStateInfo(change.nextState);
    final changes = _detectStateChanges(currentStateInfo, nextStateInfo);

    final buffer = StringBuffer();

    buffer.writeln(
      _colorize(
        '╔══════════════════════════════════════════════════════════════════════════╗',
        _brightBlue,
      ),
    );
    buffer.writeln(
      _colorize(
        '║ ${_pad('🔄 STATE CHANGE - $blocType [$blocId]', 70)} ║',
        _brightBlue,
      ),
    );
    buffer.writeln(
      _colorize(
        '╠══════════════════════════════════════════════════════════════════════════╣',
        _brightBlue,
      ),
    );

    if (changes.isEmpty) {
      buffer.writeln(
        _colorize('║ ${_pad('No property changes detected', 70)} ║', _yellow),
      );
    } else {
      buffer.writeln(
        _colorize(
          '║ Property                    │ Before              │ After               ║',
          _bold,
        ),
      );
      buffer.writeln(
        _colorize(
          '╟─────────────────────────────┼─────────────────────┼─────────────────────╢',
          _dim,
        ),
      );

      changes.forEach((property, changeInfo) {
        final before = changeInfo['before']?.toString() ?? 'null';
        final after = changeInfo['after']?.toString() ?? 'null';

        buffer.writeln(
          '║ ${_colorize(_pad(property, 27), _white)} │ '
          '${_colorize(_pad(before, 19), _red)} │ '
          '${_colorize(_pad(after, 19), _green)} ║',
        );
      });
    }

    buffer.writeln(
      _colorize(
        '╚══════════════════════════════════════════════════════════════════════════╝',
        _brightBlue,
      ),
    );

    _log(buffer.toString());
  }

  void _logTransition(BlocBase bloc, String blocType, Transition transition) {
    final blocId = _blocIds[bloc] ?? 'unknown';
    final eventType = transition.event.runtimeType.toString();
    final eventInfo = _extractCompleteStateInfo(transition.event);

    final buffer = StringBuffer();

    buffer.writeln(
      _colorize(
        '╔══════════════════════════════════════════════════════════════════════════╗',
        _brightYellow,
      ),
    );
    buffer.writeln(
      _colorize(
        '║ ${_pad('⚡ TRANSITION - $blocType [$blocId]', 70)} ║',
        _brightYellow,
      ),
    );
    buffer.writeln(
      _colorize(
        '╠══════════════════════════════════════════════════════════════════════════╣',
        _brightYellow,
      ),
    );

    buffer.writeln(
      _colorize('║ ${_padKeyValue('Event', eventType, 68)} ║', _white),
    );

    // Event properties
    if (eventInfo.isNotEmpty) {
      buffer.writeln(
        _colorize(
          '╠────────────────────────── EVENT DATA ─────────────────────────╢',
          _yellow,
        ),
      );

      eventInfo.forEach((key, value) {
        buffer.writeln(
          _colorize('║ ${_padKeyValue(key, value.toString(), 68)} ║', _yellow),
        );
      });
    }

    buffer.writeln(
      _colorize(
        '╚══════════════════════════════════════════════════════════════════════════╝',
        _brightYellow,
      ),
    );

    _log(buffer.toString());

    // Also log the state change
    _logStateChange(
      bloc,
      blocType,
      Change(
        currentState: transition.currentState,
        nextState: transition.nextState,
      ),
    );
  }

  void _logError(BlocBase bloc, Object error, StackTrace stackTrace) {
    final blocType = bloc.runtimeType.toString();
    final blocId = _blocIds[bloc] ?? 'unknown';

    final buffer = StringBuffer();

    buffer.writeln(
      _colorize(
        '╔══════════════════════════════════════════════════════════════════════════╗',
        _brightRed,
      ),
    );
    buffer.writeln(
      _colorize(
        '║ ${_pad('💥 BLOC ERROR - $blocType [$blocId]', 70)} ║',
        _brightRed,
      ),
    );
    buffer.writeln(
      _colorize(
        '╠══════════════════════════════════════════════════════════════════════════╣',
        _brightRed,
      ),
    );

    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Error Type', error.runtimeType.toString(), 68)} ║',
        _red,
      ),
    );
    buffer.writeln(
      _colorize('║ ${_padKeyValue('Message', error.toString(), 68)} ║', _red),
    );

    // Stack trace (first few lines)
    final stackLines = stackTrace.toString().split('\n').take(5);
    buffer.writeln(
      _colorize(
        '╠─────────────────────── STACK TRACE ──────────────────────╢',
        _red,
      ),
    );

    for (final line in stackLines) {
      if (line.trim().isNotEmpty) {
        buffer.writeln(_colorize('║ ${_pad(line.trim(), 70)} ║', _dim));
      }
    }

    buffer.writeln(
      _colorize(
        '╚══════════════════════════════════════════════════════════════════════════╝',
        _brightRed,
      ),
    );

    _log(buffer.toString());
  }

  void _logGlobalStatistics() {
    if (!showPerformanceMetrics) return;

    final totalActiveBlocs = _activeBlocsByType.values.fold<int>(
      0,
      (sum, list) => sum + list.length,
    );

    final buffer = StringBuffer();

    buffer.writeln(
      _colorize(
        '╔══════════════════════════════════════════════════════════════════════════╗',
        _brightCyan,
      ),
    );
    buffer.writeln(
      _colorize('║ ${_pad('📊 GLOBAL STATISTICS', 70)} ║', _brightCyan),
    );
    buffer.writeln(
      _colorize(
        '╠══════════════════════════════════════════════════════════════════════════╣',
        _brightCyan,
      ),
    );

    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Total Blocs Created', _totalBlocsCreated.toString(), 68)} ║',
        _cyan,
      ),
    );
    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Currently Active', totalActiveBlocs.toString(), 68)} ║',
        _cyan,
      ),
    );
    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Total State Changes', _totalStateChanges.toString(), 68)} ║',
        _cyan,
      ),
    );
    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Total Events', _totalEvents.toString(), 68)} ║',
        _cyan,
      ),
    );

    // Memory usage estimation
    final estimatedMemory = totalActiveBlocs * 1024; // Rough estimate
    buffer.writeln(
      _colorize(
        '║ ${_padKeyValue('Estimated Memory', '~${estimatedMemory}KB', 68)} ║',
        _yellow,
      ),
    );

    buffer.writeln(
      _colorize(
        '╚══════════════════════════════════════════════════════════════════════════╝',
        _brightCyan,
      ),
    );

    _log(buffer.toString());
  }

  // ══════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ══════════════════════════════════════════════════════════════

  String _generateBlocId(BlocBase bloc) {
    final type = bloc.runtimeType.toString();
    final count = (_activeBlocsByType[type]?.length ?? 0) + 1;
    return '${type}_$count';
  }

  Duration _calculateLifespan(BlocBase bloc) {
    final creationTime = _blocCreationTimes[bloc];
    if (creationTime == null) return Duration.zero;
    return DateTime.now().difference(creationTime);
  }

  Map<String, dynamic> _extractCompleteStateInfo(dynamic state) {
    if (state == null) return {'value': 'null'};

    try {
      // Try to use reflection or toJson if available
      if (state is Map) return Map<String, dynamic>.from(state);

      // Check if object has toJson method
      try {
        final json = (state as dynamic).toJson();
        if (json is Map) return Map<String, dynamic>.from(json);
      } catch (_) {}

      // Parse toString representation
      final str = state.toString();

      // Handle common patterns
      if (str.contains('(') && str.contains(')')) {
        final content = str.substring(
          str.indexOf('(') + 1,
          str.lastIndexOf(')'),
        );
        return _parsePropertiesFromString(content);
      }

      if (str.contains('{') && str.contains('}')) {
        final content = str.substring(
          str.indexOf('{') + 1,
          str.lastIndexOf('}'),
        );
        return _parsePropertiesFromString(content);
      }

      return {'value': str};
    } catch (e) {
      return {'value': state.toString(), 'parseError': e.toString()};
    }
  }

  Map<String, dynamic> _parsePropertiesFromString(String content) {
    final result = <String, dynamic>{};

    try {
      final pairs = content.split(',').where((s) => s.trim().isNotEmpty);

      for (final pair in pairs) {
        final colonIndex = pair.indexOf(':');
        if (colonIndex > 0) {
          final key = pair.substring(0, colonIndex).trim();
          final value = pair.substring(colonIndex + 1).trim();
          result[key] = value;
        }
      }
    } catch (_) {}

    return result.isEmpty ? {'content': content} : result;
  }

  Map<String, Map<String, dynamic>> _detectStateChanges(
    Map<String, dynamic> current,
    Map<String, dynamic> next,
  ) {
    final changes = <String, Map<String, dynamic>>{};
    final allKeys = {...current.keys, ...next.keys};

    for (final key in allKeys) {
      final currentValue = current[key];
      final nextValue = next[key];

      if (currentValue != nextValue) {
        changes[key] = {'before': currentValue, 'after': nextValue};
      }
    }

    return changes;
  }

  String _colorize(String text, String color) {
    return useColors ? '$color$text$_reset' : text;
  }

  String _pad(String text, int width) {
    return text.padRight(width).substring(0, width);
  }

  String _padKeyValue(String key, String value, int totalWidth) {
    final separator = ': ';
    final keyWidth = (totalWidth * 0.4).floor();
    final valueWidth = totalWidth - keyWidth - separator.length;

    return '${key.padRight(keyWidth).substring(0, keyWidth)}'
        '$separator'
        '${value.padLeft(valueWidth).substring(0, valueWidth)}';
  }

  void _log(String message) {
    if (logToConsole) {
      print(message);
    }

    if (logToDevTools) {
      developer.log(message, name: 'ProfessionalBlocObserver');
    }
  }

  // ══════════════════════════════════════════════════════════════
  // PUBLIC METHODS FOR MANUAL INSPECTION
  // ══════════════════════════════════════════════════════════════

  /// Get current statistics
  Map<String, dynamic> getStatistics() {
    final totalActive = _activeBlocsByType.values.fold<int>(
      0,
      (sum, list) => sum + list.length,
    );

    return {
      'totalBlocsCreated': _totalBlocsCreated,
      'currentlyActive': totalActive,
      'totalStateChanges': _totalStateChanges,
      'totalEvents': _totalEvents,
      'activeBlocsByType': Map.fromEntries(
        _activeBlocsByType.entries.map((e) => MapEntry(e.key, e.value.length)),
      ),
      'eventCounts': Map.from(_eventCounts),
      'averageProcessingTimes': Map.fromEntries(
        _totalProcessingTimes.entries.map(
          (e) => MapEntry(
            e.key,
            '${(e.value.inMicroseconds / (_eventCounts[e.key] ?? 1)).toStringAsFixed(2)}μs',
          ),
        ),
      ),
    };
  }

  /// Print comprehensive report
  void printReport() {
    final stats = getStatistics();
    final buffer = StringBuffer();

    buffer.writeln(
      _colorize(
        '╔══════════════════════════════════════════════════════════════════════════╗',
        _bold,
      ),
    );
    buffer.writeln(
      _colorize('║ ${_pad('🎯 COMPREHENSIVE BLOC REPORT', 70)} ║', _bold),
    );
    buffer.writeln(
      _colorize(
        '╠══════════════════════════════════════════════════════════════════════════╣',
        _bold,
      ),
    );

    stats.forEach((key, value) {
      if (value is Map) {
        buffer.writeln(_colorize('║ ${_pad(key.toUpperCase(), 70)} ║', _cyan));
        (value as Map).forEach((subKey, subValue) {
          buffer.writeln(
            _colorize(
              '║ ${_padKeyValue('  $subKey', subValue.toString(), 68)} ║',
              _white,
            ),
          );
        });
      } else {
        buffer.writeln(
          _colorize('║ ${_padKeyValue(key, value.toString(), 68)} ║', _white),
        );
      }
    });

    buffer.writeln(
      _colorize(
        '╚══════════════════════════════════════════════════════════════════════════╝',
        _bold,
      ),
    );

    _log(buffer.toString());
  }

  /// Clear all statistics (useful for testing)
  void clearStatistics() {
    _activeBlocsByType.clear();
    _blocCreationTimes.clear();
    _blocIds.clear();
    _eventCounts.clear();
    _totalProcessingTimes.clear();
    _totalBlocsCreated = 0;
    _totalStateChanges = 0;
    _totalEvents = 0;
  }
}
