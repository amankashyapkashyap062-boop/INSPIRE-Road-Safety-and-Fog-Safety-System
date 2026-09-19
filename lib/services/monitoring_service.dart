import 'dart:async';
import 'dart:math';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MonitoringTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  double _speedKmh = 0.0;
  double _accelerationMagnitude = 0.0;
  double _rotationMagnitude = 0.0;

  bool _safetyMode = false;
  DateTime? _lowSpeedSince;

  bool _possibleAccident = false;

  @override
  Future<void> onStart(
    DateTime timestamp,
    TaskStarter starter,
  ) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'INSPIRE Safety Monitoring',
      notificationText: 'Monitoring ON',
    );

    _startLocationMonitoring();
    _startSensorMonitoring();
  }

  void _startLocationMonitoring() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
    );

    _locationSubscription =
        Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(
      (Position position) {
        final speed = position.speed >= 0
            ? position.speed * 3.6
            : 0.0;

        _speedKmh = speed;
        _updateSafetyMode();

        FlutterForegroundTask.updateService(
          notificationTitle: 'INSPIRE Safety Monitoring',
          notificationText: _safetyMode
              ? 'Safety Mode ON • ${_speedKmh.toStringAsFixed(1)} km/h'
              : 'Low-Power Monitoring • ${_speedKmh.toStringAsFixed(1)} km/h',
        );

        FlutterForegroundTask.sendDataToMain({
          'type': 'monitoring',
          'speed': _speedKmh,
          'safetyMode': _safetyMode,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
        });
      },
      onError: (_) {},
    );
  }

  void _startSensorMonitoring() {
    _accelerometerSubscription =
        accelerometerEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen(
      (event) {
        _accelerationMagnitude = sqrt(
          event.x * event.x +
              event.y * event.y +
              event.z * event.z,
        );

        _checkAccidentPattern();
      },
      onError: (_) {},
    );

    _gyroscopeSubscription =
        gyroscopeEventStream(
      samplingPeriod: SensorInterval.normalInterval,
    ).listen(
      (event) {
        _rotationMagnitude = sqrt(
          event.x * event.x +
              event.y * event.y +
              event.z * event.z,
        );

        _checkAccidentPattern();
      },
      onError: (_) {},
    );
  }

  void _updateSafetyMode() {
    if (_speedKmh >= 10.0) {
      _lowSpeedSince = null;
      _safetyMode = true;
      return;
    }

    if (_safetyMode && _speedKmh <= 8.0) {
      _lowSpeedSince ??= DateTime.now();

      final elapsed =
          DateTime.now().difference(_lowSpeedSince!);

      if (elapsed.inSeconds >= 10) {
        _safetyMode = false;
        _lowSpeedSince = null;
      }

      return;
    }

    if (_speedKmh > 8.0 && _speedKmh < 10.0) {
      _lowSpeedSince = null;
    }
  }

  void _checkAccidentPattern() {
    if (!_safetyMode) {
      return;
    }

    // Initial conservative pattern.
    // This is NOT a final accident classifier.
    final strongMotion =
        _accelerationMagnitude >= 25.0;

    final strongRotation =
        _rotationMagnitude >= 5.0;

    if (strongMotion || strongRotation) {
      if (!_possibleAccident) {
        _possibleAccident = true;

        FlutterForegroundTask.updateService(
          notificationTitle: 'INSPIRE Safety Warning',
          notificationText:
              'Possible accident detected • Check safety',
        );

        FlutterForegroundTask.sendDataToMain({
          'type': 'possible_accident',
          'speed': _speedKmh,
          'acceleration': _accelerationMagnitude,
          'rotation': _rotationMagnitude,
        });
      }
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    FlutterForegroundTask.sendDataToMain({
      'type': 'heartbeat',
      'speed': _speedKmh,
      'safetyMode': _safetyMode,
    });
  }

  @override
  Future<void> onDestroy(
    DateTime timestamp,
    bool isTimeout,
  ) async {
    await _locationSubscription?.cancel();
    await _accelerometerSubscription?.cancel();
    await _gyroscopeSubscription?.cancel();

    _locationSubscription = null;
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
  }

  @override
  void onReceiveData(Object data) {
    if (data == 'reset_accident') {
      _possibleAccident = false;
    }
  }

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
  }

  @override
  void onNotificationDismissed() {}
}

@pragma('vm:entry-point')
void startMonitoringCallback() {
  FlutterForegroundTask.setTaskHandler(
    MonitoringTaskHandler(),
  );
}
