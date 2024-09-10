import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

Future<dynamic> currentLocation() async {
  Map Address;
  try {
    await determinePosition().then((valLatLng) async {
      await address(valLatLng).then((valAddress) async{
        print("locationDetail :-" + valAddress.toString());
        Address=valAddress;
      }).catchError((error, stackTrace) {
        print("location error :-" + error.toString());
        showToast(error.toString());
        return Future.error("error");
      });
    }).catchError((error, stackTrace) {
      print("location error :-" + error.toString());
      showToast(error.toString());
      return Future.error("error");
    });
  } catch (e) {
    return Future.error("error");
  }
  return Address;
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

Future<Map> address(Position valLatLng) async {
  var first;
  Map map = Map();
  final coordinates = new Coordinates(valLatLng.latitude, valLatLng.longitude);
  var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
  first = addresses.first;
  if (first == null) {
    return Future.error("Unable to fetch Location.");
  }
  print("${first.featureName} : ${first.addressLine}");
  map = {
    "Address": first.addressLine,
    "Latitude": valLatLng.latitude,
    "Longitude": valLatLng.longitude
  };
  return map;
}
