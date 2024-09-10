import 'package:flutter/material.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:smart_bin_sense_driver_app/constants.dart';
import 'package:smart_bin_sense_driver_app/views/driver_profile_screen.dart';
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
  bool  proceedToShareLocation = false;


  Future getTruckerData(String deviceId) async {
    firebaseServices.getTruckDriverDetails(deviceId).then((dataSnapshot) {
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
    });
  }

  Future<String?> initDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    setState(() {
      this.deviceId = deviceId!;
    });
    return deviceId;
  }

  @override
  void initState() {
    initDeviceId().then((deviceId) {
      getTruckerData(deviceId.toString());
    });
    super.initState();
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (proceedToShareLocation) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapsHost(),
                        ),
                      );
                    } else {
                      showCustomToast(
                          "Update your profile in order to share location");
                    }
                  },
                  child: const Text(
                    "Share my location",
                  ),
                ),
              )
            ],
          ),
          const DriverProfileScreen()
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
