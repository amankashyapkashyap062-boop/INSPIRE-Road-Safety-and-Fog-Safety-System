import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Widget statusCard({
    required IconData icon,
    required String title,
    required String status,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        leading: Icon(icon, size: 35),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Text('$status\n$description'),
        isThreeLine: true,
      ),
    );
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
              status: 'PERMISSION STATUS',
              description:
                  'Location का उपयोग केवल आवश्यक safety functions और आपकी consent के अनुसार किया जाएगा।',
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
