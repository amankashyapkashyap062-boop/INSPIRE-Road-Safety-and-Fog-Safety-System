import 'package:flutter/material.dart';

void main() {
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
      home: const SafetyDashboard(),
    );
  }
}

class SafetyDashboard extends StatefulWidget {
  const SafetyDashboard({super.key});

  @override
  State<SafetyDashboard> createState() => _SafetyDashboardState();
}

class _SafetyDashboardState extends State<SafetyDashboard> {
  bool monitoring = false;
  bool fogSafety = false;
  bool accidentDetection = false;

  void toggleMonitoring() {
    setState(() {
      monitoring = !monitoring;
      accidentDetection = monitoring;
      fogSafety = monitoring;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INSPIRE Safety System'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 80,
            ),
            const SizedBox(height: 12),
            const Text(
              'Road & Fog Safety',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              monitoring
                  ? 'Safety Monitoring ON'
                  : 'Safety Monitoring OFF',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            Card(
              child: ListTile(
                leading: const Icon(Icons.speed),
                title: const Text('Speed Monitoring'),
                subtitle: const Text(
                  'Low-power monitoring system',
                ),
                trailing: Icon(
                  monitoring
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.car_crash),
                title: const Text('Accident Detection'),
                subtitle: const Text(
                  'Accelerometer + Gyroscope based system',
                ),
                trailing: Icon(
                  accidentDetection
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.foggy),
                title: const Text('Fog Safety'),
                subtitle: const Text(
                  'Nearby-vehicle warning system',
                ),
                trailing: Icon(
                  fogSafety
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: toggleMonitoring,
                icon: Icon(
                  monitoring
                      ? Icons.stop_circle
                      : Icons.play_circle,
                ),
                label: Text(
                  monitoring
                      ? 'STOP MONITORING'
                      : 'START MONITORING',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'System Information',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This prototype will later include '
                      'real speed, sensor, location, accident '
                      'and fog-safety services.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Safety system is an assistance tool and '
              'cannot guarantee accident detection.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
