import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static void launchMapFromSourceToDestination(
      sourceLat, sourceLng, destinationLat, destinationLng) async {
    String mapOptions = [
      'saddr=$sourceLat,$sourceLng',
      'daddr=$destinationLat,$destinationLng',
      'dir_action=navigate'
    ].join('&');

    final String mapUrl = 'https://www.google.com/maps/?$mapOptions';

    try {
      await launchUrl(Uri.parse(mapUrl));
    } catch (e) {
      throw "Could not open the map. ";
    }
  }
}
