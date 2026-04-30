import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class LocationService {
  Future<String> getCountry() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return "Unknown";
    }

    try {
      final position = await Geolocator.getCurrentPosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return placemarks.first.country ?? "Unknown";
    } catch (e) {
      return "Unknown";
    }
  }
}