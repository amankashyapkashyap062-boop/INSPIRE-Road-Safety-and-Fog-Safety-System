import 'package:flutter/material.dart';
import 'dashboard.dart';
import '../storage/settings_storage.dart';

class Page2Permissions extends StatefulWidget {
  const Page2Permissions({super.key});

  @override
  State<Page2Permissions> createState() => _Page2PermissionsState();
}

class _Page2PermissionsState extends State<Page2Permissions> {
  bool locationConsent = false;
  bool emergencyAlertConsent = false;
  bool locationSharingConsent = false;
  bool guardianAlertConsent = false;
  bool privacyConsent = false;

  bool get allRequiredConsentGiven {
    return locationConsent &&
        emergencyAlertConsent &&
        locationSharingConsent &&
        guardianAlertConsent &&
        privacyConsent;
  }

  Future<void> continueToApp() async {
    if (!allRequiredConsentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'आगे बढ़ने के लिए सभी आवश्यक consent स्वीकार करें।',
          ),
        ),
      );
      return;
    }

    await SettingsStorage.saveConsents(
      locationConsent: locationConsent,
      locationSharingConsent: locationSharingConsent,
      emergencyAlertConsent: emergencyAlertConsent,
      guardianAlertConsent: guardianAlertConsent,
      privacyConsent: privacyConsent,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ),
    );
  }

  Widget consentTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(description),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions & Consent'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.security,
              size: 70,
            ),

            const SizedBox(height: 10),

            const Text(
              'Safety & Privacy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'App को safety features चलाने के लिए नीचे दी गई permissions और consents की आवश्यकता होगी।',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            consentTile(
              title: 'Location Consent',
              description:
                  'Safety features के लिए उपलब्ध location information का उपयोग करने की अनुमति।',
              value: locationConsent,
              onChanged: (value) {
                setState(() {
                  locationConsent = value;
                });
              },
              icon: Icons.location_on,
            ),

            consentTile(
              title: 'Accident Location Sharing',
              description:
                  'Suspected accident की स्थिति में, आपकी consent के अनुसार location authorized contacts के साथ share की जा सकती है।',
              value: locationSharingConsent,
              onChanged: (value) {
                setState(() {
                  locationSharingConsent = value;
                });
              },
              icon: Icons.share_location,
            ),

            consentTile(
              title: 'Emergency Alert Consent',
              description:
                  'Suspected serious accident पर निर्धारित emergency alert process शुरू करने की अनुमति।',
              value: emergencyAlertConsent,
              onChanged: (value) {
                setState(() {
                  emergencyAlertConsent = value;
                });
              },
              icon: Icons.warning,
            ),

            consentTile(
              title: 'Parent/Guardian Alert',
              description:
                  'Accident confirmation process में Parent/Guardian को alert करने की अनुमति।',
              value: guardianAlertConsent,
              onChanged: (value) {
                setState(() {
                  guardianAlertConsent = value;
                });
              },
              icon: Icons.family_restroom,
            ),

            consentTile(
              title: 'Privacy Consent',
              description:
                  'आप समझते हैं कि app केवल अपने safety functions के लिए आवश्यक information का उपयोग करेगा।',
              value: privacyConsent,
              onChanged: (value) {
                setState(() {
                  privacyConsent = value;
                });
              },
              icon: Icons.privacy_tip,
            ),

            const SizedBox(height: 16),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'महत्वपूर्ण: ये consent switches अभी app की consent state संभालते हैं। '
                  'अगले चरण में इन्हें वास्तविक Android permissions और सुरक्षित local storage से जोड़ा जाएगा।',
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: continueToApp,
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  'ALLOW & CONTINUE',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
