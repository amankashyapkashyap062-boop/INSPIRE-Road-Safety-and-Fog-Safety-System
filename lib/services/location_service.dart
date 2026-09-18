import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Location permission और GPS service check करके
  /// current location प्राप्त करता है।
  static Future<Position?> getCurrentLocation() async {
    // GPS/Location service चालू है या नहीं
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    // पहले से मिली permission check करें
    LocationPermission permission =
        await Geolocator.checkPermission();

    // Permission नहीं मिली है तो request करें
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // User ने permission permanently deny कर दी
    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Permission अभी भी नहीं मिली
    if (permission == LocationPermission.denied) {
      return null;
    }

    // Current GPS location प्राप्त करें
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Location permission की current स्थिति
  static Future<LocationPermission> getPermission() async {
    return await Geolocator.checkPermission();
  }

  /// GPS/Location service चालू है या नहीं
  static Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Location settings खोलने के लिए
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
