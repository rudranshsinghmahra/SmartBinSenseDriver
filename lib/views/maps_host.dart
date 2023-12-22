import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class MapsHost extends StatefulWidget {
  const MapsHost({Key? key}) : super(key: key);

  @override
  State createState() => MapsHostState();
}

class MapsHostState extends State<MapsHost> {
  GoogleMapController? mapController;
  Map<String, double> currentLocation = {};
  double _heading = 0.0;
  StreamSubscription<LocationData>? locationSubscription;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  Location location = Location();
  String? error;
  String? _deviceId;

  Future<void> initDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    if (!mounted) return;
    setState(() {
      _deviceId = deviceId!;
    });
  }

  Future<void> getHeading() async {
    FlutterCompass.events?.listen((CompassEvent event) {
      if (!mounted) return;
      setState(() {
        _heading = event.heading ?? 0;
      });
    });
  }

  void updateDatabase() {
    FirebaseDatabase.instance.ref().child(_deviceId!).update({
      'latitude': currentLocation['latitude'],
      'longitude': currentLocation['longitude'],
      'heading': _heading,
    });
  }

  @override
  void initState() {
    initDeviceId();
    getHeading();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();

    locationSubscription =
        Location().onLocationChanged.listen((LocationData result) {
      if (!mounted) return;
      setState(() {
        currentLocation = {
          'latitude': result.latitude!,
          'longitude': result.longitude!,
        };

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                currentLocation['latitude']!,
                currentLocation['longitude']!,
              ),
              zoom: 17,
            ),
          ),
        );

        updateDatabase();
      });
    });

    _configureBackgroundLocationUpdates();

    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(10, 10)),
      "assets/images/garbage_truck_marker.png",
    ).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void initPlatformState() async {
    LocationData myLocation;
    try {
      myLocation = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission Denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      myLocation = LocationData.fromMap({'latitude': 0.0, 'longitude': 0.0});
    }
    setState(() {
      currentLocation = {
        'latitude': myLocation.latitude!,
        'longitude': myLocation.longitude!,
      };
    });
  }

  void _configureBackgroundLocationUpdates() async {
    if (await Location().requestPermission() != PermissionStatus.granted) {
      return;
    }

    if (await permission_handler.Permission.locationAlways.request() !=
        permission_handler.PermissionStatus.granted) {
      return;
    }

    await Location().enableBackgroundMode(enable: true);
    await Location().changeSettings(interval: 5000);
    await Location().requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Host')),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 350.0,
                child: GoogleMap(
                  markers: <Marker>{
                    Marker(
                      markerId: const MarkerId("currentLocation"),
                      icon: markerIcon,
                      position: LatLng(currentLocation['latitude']!,
                          currentLocation['longitude']!),
                      rotation: _heading,
                      infoWindow: const InfoWindow(title: "Marker Title"),
                    ),
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation['latitude']!,
                        currentLocation['longitude']!),
                    zoom: 17,
                  ),
                  onMapCreated: _onMapCreated,
                ),
              ),
              Text(
                  'Lat/Lng: ${currentLocation['latitude']}/${currentLocation['longitude']}'),
              Text("Device ID: $_deviceId"),
            ],
          ),
        ),
      ),
    );
  }
}
