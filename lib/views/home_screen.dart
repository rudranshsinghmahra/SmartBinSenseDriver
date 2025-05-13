import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:smart_bin_sense_driver_app/views/driver_profile_screen.dart';
import 'package:smart_bin_sense_driver_app/views/edit_profile_screen.dart';
import '../constants.dart';
import '../services/firebase_services.dart';
import '../widgets/appbar/custom_appbar_location.dart';
import 'maps_host.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextEditingController = TextEditingController();
  int currentPageIndex = 0;
  FirebaseServices firebaseServices = FirebaseServices();
  String? deviceId;
  bool proceedToShareLocation = false;
  Future<void>? _truckerDataFuture;

  Future<void> getTruckerData(String deviceId) async {
    final dataSnapshot = await firebaseServices.getTruckDriverDetails(deviceId);
    if (dataSnapshot.value != null) {
      // Data found based on deviceId filter
      Map<dynamic, dynamic>? values =
          dataSnapshot.value as Map<dynamic, dynamic>?;
      if (values != null) {
        setState(() {
          proceedToShareLocation = true;
        });
      }
    } else {
      setState(() {
        proceedToShareLocation = false;
      });
    }
  }

  Future<String> getUdid() async {
    deviceId = await FlutterUdid.udid;
    return deviceId.toString();
  }

  Future<void> initDeviceId() async {
    deviceId = await getUdid();
    _truckerDataFuture = getTruckerData(deviceId!);
  }

  @override
  void initState() {
    super.initState();
    initDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: CustomAppBarLocation(
              searchTextEditingController: searchTextEditingController),
        ),
        body: [
          FutureBuilder(
            future: _truckerDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (proceedToShareLocation) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapsHost(),
                              ),
                            );
                          } else {
                            // Navigate to DriverProfileScreen and refresh data on return
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DriverProfileScreen(),
                              ),
                            );
                            // Re-fetch trucker data after returning from DriverProfileScreen
                            if (deviceId != null) {
                              await getTruckerData(deviceId!);
                            }
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fire_truck,
                                size: 50,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Share my truck live location\nमेरे ट्रक की लाइव लोकेशन शेयर करें",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const EditProfileScreen()
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: ""),
            NavigationDestination(icon: Icon(Icons.person), label: ""),
          ],
          elevation: 5,
          backgroundColor: Colors.white,
          height: 60,
          animationDuration: const Duration(milliseconds: 1800),
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        ),
      ),
    );
  }
}
