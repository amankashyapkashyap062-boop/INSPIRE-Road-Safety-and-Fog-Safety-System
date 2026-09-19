import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'screens/page1_user_details.dart';

void main() {
  FlutterForegroundTask.initCommunicationPort();

  FlutterForegroundTask.init(
    androidNotificationOptions:
        AndroidNotificationOptions(
      channelId: 'inspire_safety_monitoring',
      channelName: 'INSPIRE Safety Monitoring',
      channelDescription:
          'Shows when safety monitoring is active.',
      onlyAlertOnce: true,
    ),
    iosNotificationOptions:
        const IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions:
        ForegroundTaskOptions(
      eventAction:
          ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: false,
      autoRunOnMyPackageReplaced: false,
      allowWakeLock: true,
      allowWifiLock: false,
    ),
  );

  runApp(const InspireSafetyApp());
}

class InspireSafetyApp extends StatelessWidget {
  const InspireSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'INSPIRE Safety System',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const Page1UserDetails(),
    );
  }
}
