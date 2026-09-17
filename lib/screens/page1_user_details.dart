import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../storage/settings_storage.dart';
import 'page2_permissions.dart';

class Page1UserDetails extends StatefulWidget {
  const Page1UserDetails({super.key});

  @override
  State<Page1UserDetails> createState() => _Page1UserDetailsState();
}

class _Page1UserDetailsState extends State<Page1UserDetails> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final ageController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final guardianNameController = TextEditingController();
  final guardianMobileController = TextEditingController();
  final emergencyController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final allergyController = TextEditingController();
  final medicalController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    mobileController.dispose();
    ageController.dispose();
    stateController.dispose();
    districtController.dispose();
    guardianNameController.dispose();
    guardianMobileController.dispose();
    emergencyController.dispose();
    bloodGroupController.dispose();
    allergyController.dispose();
    medicalController.dispose();
    super.dispose();
  }

  String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'यह जानकारी आवश्यक है';
    }
    return null;
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final profile = UserProfile(
      fullName: fullNameController.text.trim(),
      mobileNumber: mobileController.text.trim(),
      age: ageController.text.trim(),
      state: stateController.text.trim(),
      district: districtController.text.trim(),
      guardianName: guardianNameController.text.trim(),
      guardianMobile: guardianMobileController.text.trim(),
      emergencyContact: emergencyController.text.trim(),
      bloodGroup: bloodGroupController.text.trim(),
      allergy: allergyController.text.trim(),
      medicalInformation: medicalController.text.trim(),
    );

    await SettingsStorage.saveProfile(profile);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Page2Permissions(),
      ),
    );
  }

  Widget buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool required = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: required ? requiredField : null,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Safety Profile'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_pin,
                size: 70,
              ),

              const SizedBox(height: 8),

              const Text(
                'Safety Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'अपनी सुरक्षा से जुड़ी जानकारी दर्ज करें',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              buildField(
                label: 'Full Name',
                controller: fullNameController,
                icon: Icons.person,
              ),

              buildField(
                label: 'Mobile Number',
                controller: mobileController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),

              buildField(
                label: 'Age',
                controller: ageController,
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),

              buildField(
                label: 'State',
                controller: stateController,
                icon: Icons.map,
              ),

              buildField(
                label: 'District',
                controller: districtController,
                icon: Icons.location_city,
              ),

              buildField(
                label: 'Parent/Guardian Name',
                controller: guardianNameController,
                icon: Icons.family_restroom,
              ),

              buildField(
                label: 'Parent/Guardian Mobile',
                controller: guardianMobileController,
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),

              buildField(
                label: 'Emergency Contact',
                controller: emergencyController,
                icon: Icons.contact_phone,
                required: false,
                keyboardType: TextInputType.phone,
              ),

              buildField(
                label: 'Blood Group',
                controller: bloodGroupController,
                icon: Icons.bloodtype,
                required: false,
              ),

              buildField(
                label: 'Allergy',
                controller: allergyController,
                icon: Icons.warning_amber,
                required: false,
              ),

              buildField(
                label: 'Medical Information',
                controller: medicalController,
                icon: Icons.medical_information,
                required: false,
                maxLines: 3,
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'SAVE & CONTINUE',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                '* Required fields',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
