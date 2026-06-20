import 'package:geolocator/geolocator.dart';

class GeolocationException implements Exception {
  final String message;
  GeolocationException(this.message);
  @override
  String toString() => message;
}

class GeolocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw GeolocationException("Geolocation is not available, please enable it in your App settings");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw GeolocationException("Geolocation is not available, please enable it in your App settings");
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw GeolocationException("Geolocation is not available, please enable it in your App settings");
    } 

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low)
      );
    } catch (e) {
      throw GeolocationException("Geolocation is not available, please enable it in your App settings");
    }
  }
}
