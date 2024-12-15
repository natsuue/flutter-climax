import 'package:geolocator/geolocator.dart';

class Location {
  double lon = 0, lat = 0;

  // This function now properly handles permissions and returns location data.
  Future<bool> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      // Check if permission is granted
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print('Location permission denied');
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      lon = position.longitude;
      lat = position.latitude;
      return true;
    } catch (e) {
      print('Error fetching location: $e');
      return false;
    }
  }
}
