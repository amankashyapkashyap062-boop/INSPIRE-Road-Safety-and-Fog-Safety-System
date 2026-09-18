import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Position? currentPosition;
  bool locationLoading = false;
  String locationStatus = 'NOT CHECKED';

  @override
  void initState() {
    super.initState();
    checkLocation();
  }

  Future<void> checkLocation() async {
    if (!mounted) return;

    setState(() {
      locationLoading = true;
      locationStatus = 'CHECKING...';
    });

    final position = await LocationService.getCurrentLocation();

    if (!mounted) return;

    setState(() {
      locationLoading = false;

      if (position != null) {
        currentPosition = position;
        locationStatus = 'ACTIVE';
      } else {
        locationStatus = 'OFF / PERMISSION NEEDED';
      }
    });
  }

  Widget statusCard({
    required IconData icon,
    required String title,
    required String status,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: Icon(
          icon,
          size: 35,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          '$status\n$description',
        ),
        isThreeLine: true,
      ),
    );
  }

  String getLocationDescription() {
    if (locationLoading) {
      return 'GPS location check की जा रही है...';
    }

    if (currentPosition == null) {
      return 'GPS location उपलब्ध नहीं है। Location permission और GPS service check करें।';
    }

    return 'Latitude: ${currentPosition!.latitude.toStringAsFixed(5)}\n'
        'Longitude: ${currentPosition!.longitude.toStringAsFixed(5)}\n'
        'Accuracy: ${currentPosition!.accuracy.toStringAsFixed(1)} m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INSPIRE Safety Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.shield,
              size: 75,
            ),

            const SizedBox(height: 8),

            const Text(
              'Safety System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Accident Detection + Fog Safety',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            statusCard(
              icon: Icons.speed,
              title: 'Speed Monitoring',
              status: 'LOW-POWER MONITORING',
              description:
                  'Speed threshold के अनुसार Safety Mode सक्रिय होगा।',
            ),

            statusCard(
              icon: Icons.car_crash,
              title: 'Accident Detection',
              status: 'STANDBY',
              description:
                  'Accelerometer, gyroscope और speed data से संभावित दुर्घटना का पता लगाया जाएगा।',
            ),

            statusCard(
              icon: Icons.cloud,
              title: 'Fog Safety',
              status: 'STANDBY',
              description:
                  'उपलब्ध vehicle-to-vehicle signals के आधार पर warning system काम करेगा।',
            ),

            statusCard(
              icon: Icons.location_on,
              title: 'Location',
              status: locationStatus,
              description: getLocationDescription(),
            ),

            if (!locationLoading)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: OutlinedButton.icon(
                  onPressed: checkLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('CHECK LOCATION AGAIN'),
                ),
              ),

            statusCard(
              icon: Icons.warning_amber,
              title: 'Emergency Alert',
              status: 'READY',
              description:
                  'Accident confirmation process के बाद authorized emergency contacts को alert किया जा सकेगा।',
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    Icon(
                      Icons.battery_saver,
                      size: 35,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Low-Power Safety Monitoring',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'कम speed पर low-power monitoring और आवश्यक speed पर Safety Mode का उपयोग किया जाएगा।',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
