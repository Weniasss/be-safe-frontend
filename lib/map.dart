// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MapTask extends StatefulWidget {

//   @override
//   State<MapTask> createState() => _MapTaskState();

//   // static final Marker _kGooglePlexMarker = Marker(
//   //   markerId: MarkerId('_kGooglePlex'),
//   //   infoWindow: InfoWindow(title: 'Example Title#2'),
//   //   icon: BitmapDescriptor.defaultMarker,
//   //   position: LatLng(37.42796133580664, -122.085749655962),
//   // );

//   // static final CameraPosition _kLake = CameraPosition(
//   //     bearing: 192.8334901395799,
//   //     target: LatLng(37.43296265331129, -122.08832357078792),
//   //     tilt: 59.440717697143555,
//   //     zoom: 19.151926040649414);

//   // static final Marker _kLakeMarker = Marker(
//   //   markerId: const MarkerId('_kLakePlex'),
//   //   infoWindow: const InfoWindow(title: 'Example Title#1'),
//   //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//   //   position: const LatLng(37.43296265331129, -122.08832357078792),
//   // );
// }

// class _MapTaskState extends State<MapTask> {
//   final Completer<GoogleMapController> _controller = Completer();

//   LocationData? currentLocation;

//   void getCurrentLocation() {
//     Location location = Location();
//     location.getLocation().then((location) {
//       currentLocation = location;
//     });
//   }
//  //cameraposition 
//    static final _camPosition = CameraPosition(
//     target: currentLocation,
//     zoom: 14.5,
//   );

//   @override
//   void initState() {
//     getCurrentLocation();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: currentLocation == null ? const Center(child:Text("Loading"))
//       :GoogleMap(
//         mapType: MapType.normal,
//         markers: {
          
//         },
//         initialCameraPosition: MapTask._camPosition,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(MapTask._kLake));
//   }

//   Future<void> _getCurrentLocation() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//     LocationData _locationData;
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//     _locationData = await location.getLocation();
//   }
// }
