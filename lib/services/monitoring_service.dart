import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class MonitoringTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(
    DateTime timestamp,
    TaskStarter starter,
  ) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'INSPIRE Safety Monitoring',
      notificationText: 'Monitoring ON',
    );
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // अभी केवल service को active रख रहे हैं।
    // Background speed monitoring अगले step में जोड़ा जाएगा.
  }

  @override
  Future<void> onDestroy(
    DateTime timestamp,
    bool isTimeout,
  ) async {
    // Service बंद होने पर cleanup अगले चरण में जोड़ा जाएगा.
  }

  @override
  void onReceiveData(Object data) {
    // Main app से आने वाला data बाद में handle करेंगे.
  }

  @override
  void onNotificationButtonPressed(String id) {
    // Notification buttons बाद में जोड़ेंगे.
  }

  @override
  void onNotificationPressed() {
    // Notification दबाने पर app खोलने का behavior बाद में जोड़ेंगे.
  }

  @override
  void onNotificationDismissed() {
    // Notification dismiss handling बाद में जोड़ेंगे.
  }
}

@pragma('vm:entry-point')
void startMonitoringCallback() {
  FlutterForegroundTask.setTaskHandler(
    MonitoringTaskHandler(),
  );
}
