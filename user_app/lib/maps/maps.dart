import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  MapsUtils._();
  static Future<void> openMapWithPosition(
      String lattitude, String longitude) async {
    String googlMapUrl =
        "https://www.google.com/maps/search/?api=1&query=${lattitude},${longitude}"; // opnen with lattitude and langitude

    try {
      await launchUrl(Uri.parse(googlMapUrl));
    } catch (e) {
      throw "Could not open the map. ";
    }
  }

  static Future<void> openMapWithAddress(String fullAddress) async {
    String query = Uri.encodeComponent(fullAddress);

    String googlMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$query"; // opnen with address

    try {
      await launchUrl(Uri.parse(googlMapUrl));
    } catch (e) {
      throw "Could not open the map. ";
    }
  }
}
