import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      throw const LocationServicesOffException();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw const LocationPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw const LocationPermissionDeniedForeverException();
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

sealed class LocationException {
  final String message;

  const LocationException(this.message);
}

class LocationServicesOffException extends LocationException {
  const LocationServicesOffException()
      : super('Location services are disabled.');
}

class LocationPermissionDeniedException extends LocationException {
  const LocationPermissionDeniedException()
      : super('Location permissions are denied');
}

class LocationPermissionDeniedForeverException extends LocationException {
  const LocationPermissionDeniedForeverException()
      : super(
            'Location permissions are permanently denied, we cannot request permissions.');
}
