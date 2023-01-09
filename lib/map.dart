import 'dart:async';

import 'package:besafe/get_data/get_info.dart';
import 'package:besafe/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart' as geoCo;

import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Geocoding',
        home: Homepage1());
  }
}

class Homepage1 extends StatefulWidget {
  late final String address;
  @override
  _HomepageState1 createState() => _HomepageState1();
}

class _HomepageState1 extends State<Homepage1> {
  _HomepageState1() {
    _selectedVal = _productSizedList[0];
  }
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // late Position position;
  //late String address;
  late String country;
  late String code;
  String dropdownValue = list.first;

  late double latitude;

  late double longtude;

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  TextEditingController _searchController = TextEditingController();

  late String Choise = 'Ess';

  final _productSizedList = ["Small", "Medium", "Large"];
  static const List<String> list = <String>[
    'Crime',
    'Car accident',
    'Theft',
    'Fight'
  ];

  Map<String, double> colors = <String, double>{
    "Crime": BitmapDescriptor.hueRed,
    "Fight": BitmapDescriptor.hueOrange,
    "Car accident": BitmapDescriptor.hueRose,
    "Theft": BitmapDescriptor.hueViolet
  };

  bool isChecked1 = true;
  bool isChecked2 = true;
  bool isChecked3 = true;
  bool isChecked4 = true;

  String _selectedVal = "";

  // email: emailController.text.trim(),
  //       password: passwordController.text.trim());

  CollectionReference _referenceList =
      FirebaseFirestore.instance.collection('location');

  String tdata =
      DateFormat("HH:mm:ss").format(DateTime.now().add(Duration(minutes: 30)));

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  Future getDataBase() async {
    await FirebaseFirestore.instance
        .collection("location")
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              final Timestamp timestamp = element.data()["Time"] as Timestamp;
              final DateTime dateTime = timestamp.toDate();

              MarkerId markerId = MarkerId(
                  element.data()["latitude"].toString() +
                      element.data()["longitude"].toString());
              Marker _marker = Marker(
                markerId: markerId,
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  bottom: 5,
                                  right: 20,
                                  top: 5), //apply padding to all four sides
                              child: Text(
                                " Type : " + element.data()["Type"].toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  bottom: 10,
                                  right: 20,
                                  top: 5), //apply padding to all four sides
                              child: Text(
                                  " Description : " +
                                      element.data()["Description"].toString(),
                                  style: TextStyle(fontSize: 18)),
                            ),
                            ListTile(
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          bottom: 5,
                                          right: 20,
                                          top:
                                              5), //apply padding to all four sides
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green[600],
                                            textStyle: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        child: const Text('Up'),
                                        onPressed: () async {
                                          print(element.reference.id +
                                              "_________________________");

                                          FirebaseFirestore.instance
                                              .collection('location')
                                              .doc(element.reference.id)
                                              .update({
                                            'Time': DateTime.now()
                                                .add(Duration(minutes: 30)),
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          bottom: 5,
                                          right: 20,
                                          top:
                                              5), //apply padding to all four sides
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red[600],
                                            textStyle: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        child: const Text('Down'),
                                        onPressed: () async {
                                          MarkerId val = MarkerId(element
                                                  .data()["latitude"]
                                                  .toString() +
                                              element
                                                  .data()["longitude"]
                                                  .toString());

                                          print(markers[val]);
                                          print("__________________________");

                                          FirebaseFirestore.instance
                                              .collection('location')
                                              .doc(element.reference.id)
                                              .delete();

                                          markers.removeWhere(
                                              (key, value) => key == val);
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                              ),
                            )
                          ],
                        );
                      });
                },
                position: LatLng(
                    element.data()["latitude"], element.data()["longitude"]),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    colors[element.data()["Type"]]!),
              );
              if (dateTime.isAfter(DateTime.now())) {
                if (isChecked1 == true &&
                    element.data()["Type"] == "Car accident") {
                  print("_______________" + element.data()["Type"]);
                  setState(() {
                    markers[markerId] = _marker;
                  });
                }
                if (isChecked2 == true && element.data()["Type"] == "Theft") {
                  setState(() {
                    markers[markerId] = _marker;
                  });
                }
                if (isChecked3 == true && element.data()["Type"] == "Fight") {
                  setState(() {
                    markers[markerId] = _marker;
                  });
                }
                if (isChecked4 == true && element.data()["Type"] == "Crime") {
                  setState(() {
                    markers[markerId] = _marker;
                  });
                }
              }

              print(
                  element.data()["Country"] + "-----------------------------");
            }));
  }

  void getMarkers(double lat, double long, String description, String type) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());

    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(snippet: "addres"));
    setState(() {
      markers[markerId] = _marker;
    });
  }

  @override
  void initState() {
    getDataBase();
    super.initState();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.773471313024466, 19.44957934319973),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15,
                                                      bottom: 0,
                                                      right: 0,
                                                      top:
                                                          0),),
                Expanded(
                    child: TextFormField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Search by City'),
                  onChanged: (value) {
                    print(value);
                  },
                )),
                IconButton(
                  onPressed: () async {
                    var place = await LocationService()
                        .getPlace(_searchController.text);
                    _goToPlace(place);
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            SizedBox(
                height: 630.0,
                child: Stack(children: <Widget>[
                  GoogleMap(
                    onTap: (tapped) async {
                      getDataBase();
                      latitude = tapped.latitude;
                      longtude = tapped.longitude;

                      final coordinated = new geoCo.Coordinates(
                          tapped.latitude, tapped.longitude);
                      var adrress = await geoCo.Geocoder.local
                          .findAddressesFromCoordinates(coordinated);
                      var firstAddress = adrress.first;
                      getMarkers(
                          tapped.latitude,
                          tapped.longitude,
                          emailController.text.trim(),
                          passwordController.text.trim());
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    onCameraMove: (position) {
                      _customInfoWindowController.onCameraMove!();
                    },
                    mapType: MapType.normal,
                    compassEnabled: true,
                    trafficEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        _controller.complete(controller);
                      });
                    },
                    initialCameraPosition: _kGooglePlex,
                    markers: Set<Marker>.of(markers.values),
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 200,
                    width: 200,
                    offset: 35,
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      // add your floating action button
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20, bottom: 100, right: 20, top: 5),
                        child: FloatingActionButton(
                          onPressed: () async {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(builder: (BuildContext
                                          context,
                                      StateSetter
                                          setState /*You can rename this!*/) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                        ),
                                        ListTile(
                                          title: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5,
                                                      bottom: 5,
                                                      right: 0,
                                                      top:
                                                          5), //apply padding to all four sides
                                                  child: Text(
                                                    'Car accident',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0,
                                                      bottom: 5,
                                                      right: 20,
                                                      top:
                                                          5), //apply padding to all four sides
                                                  child: Checkbox(
                                                    checkColor: Colors.white,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .disabled)) {
                                                        return Colors.pink;
                                                      }
                                                      return Colors.pink;
                                                    }),
                                                    value: isChecked1,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isChecked1 = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 35,
                                                      bottom: 5,
                                                      right: 0,
                                                      top:
                                                          5), //apply padding to all four sides
                                                  child: Text(
                                                    'Theft',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0,
                                                      bottom: 5,
                                                      right: 20,
                                                      top:
                                                          5), //apply padding to all four sides
                                                  child: Checkbox(
                                                    checkColor: Colors.white,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .disabled)) {
                                                        return Colors
                                                            .purple.shade600;
                                                      }
                                                      return Colors
                                                          .purple.shade600;
                                                    }),
                                                    value: isChecked2,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isChecked2 = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ListTile(
                                          title: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5,
                                                      bottom: 5,
                                                      right: 0,
                                                      top:
                                                          5), //apply padding to all four sides
                                                  child: Text(
                                                    'Fight',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0,
                                                      bottom: 5,
                                                      right: 20,
                                                      top:
                                                          5), //apply padding to all four sides
                                                  child: Checkbox(
                                                    checkColor: Colors.white,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .disabled)) {
                                                        return Colors
                                                            .orange.shade600;
                                                      }
                                                      return Colors
                                                          .orange.shade600;
                                                    }),
                                                    value: isChecked3,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isChecked3 = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 35,
                                                      bottom: 5,
                                                      right: 0,
                                                      top:
                                                          5), //apply padding to all four sides
                                                  child: Text(
                                                    'Crime',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0,
                                                      bottom: 5,
                                                      right: 20,
                                                      top:
                                                          5), //apply padding to all four sides
                                                  child: Checkbox(
                                                    checkColor: Colors.white,
                                                    fillColor:
                                                        MaterialStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    MaterialState>
                                                                states) {
                                                      if (states.contains(
                                                          MaterialState
                                                              .disabled)) {
                                                        return Colors
                                                            .red.shade600;
                                                      }
                                                      return Colors
                                                          .red.shade600;
                                                    }),
                                                    value: isChecked4,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isChecked4 = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 130, // <-- Your width
                                          height: 50, // <-- Your height
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    0, 86, 91, 1),
                                                textStyle: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            child: const Text('Submit'),
                                            onPressed: () async {
                                              setState(() {
                                                markers.clear();
                                              });
                                              getDataBase();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        
                                      ],
                                    );
                                  });
                                });
                          },
                          child: Icon(Icons.info),
                          backgroundColor: Colors.grey,
                        ),
                      )),
                  Align(
                      alignment: Alignment.bottomLeft,
                      // add your floating action button
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20, bottom: 30, right: 20, top: 5),
                        child: FloatingActionButton(
                          onPressed: () async {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(builder: (BuildContext
                                          context,
                                      StateSetter
                                          setState /*You can rename this!*/) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              bottom: 10,
                                              right: 20,
                                              top:
                                                  5), //apply padding to all four sides
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: dropdownValue,
                                            icon: const Icon(
                                                Icons.arrow_downward),
                                            elevation: 16,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                            underline: Container(
                                              height: 2,
                                              width: 300,
                                              color: Colors.grey,
                                            ),
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                dropdownValue = value!;
                                              });
                                            },
                                            items: list
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              bottom: 20,
                                              right: 20,
                                              top:
                                                  5), //apply padding to all four sides
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              labelText: 'Description',
                                            ),
                                            showCursor: false,
                                            controller: emailController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) =>
                                                value != null &&
                                                        value.length < 6
                                                    ? 'Enter min. 6 characters'
                                                    : null,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 130, // <-- Your width
                                          height: 50, // <-- Your height
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    0, 86, 91, 1),
                                                textStyle: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            child: const Text('Add'),
                                            onPressed: () async {
                                              getDataBase();
                                              final coordinated =
                                                  new geoCo.Coordinates(
                                                      latitude, longtude);
                                              var adrress = await geoCo
                                                  .Geocoder.local
                                                  .findAddressesFromCoordinates(
                                                      coordinated);
                                              var firstAddress = adrress.first;

                                              getMarkers(
                                                  latitude,
                                                  longtude,
                                                  emailController.text.trim(),
                                                  passwordController.text
                                                      .trim());

                                              await FirebaseFirestore.instance
                                                  .collection('location')
                                                  .add({
                                                'latitude': latitude,
                                                'longitude': longtude,
                                                'Description':
                                                    emailController.text.trim(),
                                                'Type': dropdownValue,
                                                'Address':
                                                    firstAddress.addressLine,
                                                'Country':
                                                    firstAddress.countryName,
                                                'PostalCode':
                                                    firstAddress.postalCode,
                                                'Time': DateTime.now()
                                                    .add(Duration(minutes: 30)),
                                              });

                                              emailController.text = "";

                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                                });
                          },
                          child: Icon(Icons.add),
                        ),
                      )),
                ])),
          ],
        ),
      ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }

  @override
  void dispone() {
    super.dispose();
  }
}
