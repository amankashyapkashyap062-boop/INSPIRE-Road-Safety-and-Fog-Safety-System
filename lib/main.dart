import 'package:flutter/material.dart';
import 'screens/page1_user_details.dart';

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
      home: const Page1UserDetails(),
    );
  }
}
