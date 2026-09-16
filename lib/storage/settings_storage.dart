import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class SettingsStorage {
  static const String _profileKey = 'user_profile';

  static const String _locationConsentKey = 'location_consent';
  static const String _locationSharingConsentKey =
      'location_sharing_consent';
  static const String _emergencyAlertConsentKey =
      'emergency_alert_consent';
  static const String _guardianAlertConsentKey =
      'guardian_alert_consent';
  static const String _privacyConsentKey = 'privacy_consent';

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();

    final data = {
      'fullName': profile.fullName,
      'mobileNumber': profile.mobileNumber,
      'age': profile.age,
      'state': profile.state,
      'district': profile.district,
      'guardianName': profile.guardianName,
      'guardianMobile': profile.guardianMobile,
      'emergencyContact': profile.emergencyContact,
      'bloodGroup': profile.bloodGroup,
      'allergy': profile.allergy,
      'medicalInformation': profile.medicalInformation,
    };

    await prefs.setString(_profileKey, jsonEncode(data));
  }

  static Future<UserProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_profileKey);

    if (jsonString == null) {
      return null;
    }

    final Map<String, dynamic> data =
        jsonDecode(jsonString) as Map<String, dynamic>;

    return UserProfile(
      fullName: data['fullName'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      age: data['age'] ?? '',
      state: data['state'] ?? '',
      district: data['district'] ?? '',
      guardianName: data['guardianName'] ?? '',
      guardianMobile: data['guardianMobile'] ?? '',
      emergencyContact: data['emergencyContact'] ?? '',
      bloodGroup: data['bloodGroup'] ?? '',
      allergy: data['allergy'] ?? '',
      medicalInformation: data['medicalInformation'] ?? '',
    );
  }

  static Future<void> saveConsents({
    required bool locationConsent,
    required bool locationSharingConsent,
    required bool emergencyAlertConsent,
    required bool guardianAlertConsent,
    required bool privacyConsent,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_locationConsentKey, locationConsent);
    await prefs.setBool(
      _locationSharingConsentKey,
      locationSharingConsent,
    );
    await prefs.setBool(
      _emergencyAlertConsentKey,
      emergencyAlertConsent,
    );
    await prefs.setBool(
      _guardianAlertConsentKey,
      guardianAlertConsent,
    );
    await prefs.setBool(_privacyConsentKey, privacyConsent);
  }

  static Future<bool> getLocationConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationConsentKey) ?? false;
  }

  static Future<bool> getLocationSharingConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationSharingConsentKey) ?? false;
  }

  static Future<bool> getEmergencyAlertConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_emergencyAlertConsentKey) ?? false;
  }

  static Future<bool> getGuardianAlertConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_guardianAlertConsentKey) ?? false;
  }

  static Future<bool> getPrivacyConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_privacyConsentKey) ?? false;
  }
}
