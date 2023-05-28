import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../global/global.dart';

class UserLocation {
  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;

    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMarks = placeMarks![0];
    completeAddress =
        '${pMarks.subThoroughfare} ${pMarks.thoroughfare},${pMarks.subLocality} ${pMarks.locality},${pMarks.subAdministrativeArea}, ${pMarks.administrativeArea} ${pMarks.postalCode},${pMarks.country}';
  }
}
