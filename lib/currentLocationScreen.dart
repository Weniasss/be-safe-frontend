import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:search_map_location/utils/google_search/geo_location.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/utils/google_search/place_type.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SearchLocation(
              placeType: PlaceType.address,
              placeholder: 'Enter location',
              apiKey: "AIzaSyBach7FfdD4zVReDCpLx8XJXLDc4e5UuFc",
              onSelected: (Place place) async {
                Geolocation? geolocation = await place.geolocation;
                googleMapController.animateCamera(
                    CameraUpdate.newLatLng(geolocation?.coordinates));
                // googleMapController.animateCamera(
                //     CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
              },
            ),
            SizedBox(
              height: 550.0,
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                zoomControlsEnabled: true,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 130),
        child: FloatingActionButton.extended(
          onPressed: () async {
            Position position = await _determinePosition();

            googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 14)));

            markers.clear();

            markers.add(Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(position.latitude, position.longitude)));

            setState(() {});
          },
          label: const Text("Location"),
          icon: const Icon(Icons.location_history),
          backgroundColor: Color.fromRGBO(0, 86, 91, 1),
          // shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
