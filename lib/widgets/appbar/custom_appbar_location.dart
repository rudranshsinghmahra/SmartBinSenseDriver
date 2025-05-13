import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bin_sense_driver_app/services/firebase_services.dart';

import '../../colors.dart';
import '../../constants.dart';

class CustomAppBarLocation extends StatefulWidget {
  const CustomAppBarLocation(
      {super.key, required this.searchTextEditingController});

  final TextEditingController searchTextEditingController;

  @override
  State<CustomAppBarLocation> createState() => _CustomAppBarLocationState();
}

class _CustomAppBarLocationState extends State<CustomAppBarLocation> {
  FirebaseServices firebaseServices = FirebaseServices();
  String? userAddress = "Fetching address...";
  bool isLoading = false;
  String? deviceId;

  Future<String> getUdid() async {
    deviceId = await FlutterUdid.udid;
    return deviceId.toString();
  }

  Future<String?> initDeviceId() async {
    String? deviceId = await getUdid();
    setState(() {
      this.deviceId = deviceId;
    });
    return deviceId;
  }

  Future getTruckerHomeAddress(String deviceId) async {
    firebaseServices.getTruckDriverDetails(deviceId).then((dataSnapshot) {
      if (dataSnapshot.value != null) {
        // Data found based on deviceId filter
        Map<dynamic, dynamic>? values =
        dataSnapshot.value as Map<dynamic, dynamic>?;

        if (values != null) {
          values.forEach((key, values) {
            if (values['address'] == null) {
              setState(() {
                userAddress = "Address not set";
              });
            }
            else {
              setState(() {
                userAddress = values['address'];
              });
            }
          });
        }
      } else {
        // No data found based on plateNumber filter
        showCustomToast("User address not set");
      }
    });
  }

  @override
  void initState() {
    initDeviceId().then((deviceId) {
      getTruckerHomeAddress(deviceId.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary.shade600,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 27,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        firebaseServices.getUserAddress().then((address) {
                          setState(() {
                            userAddress = address;
                            isLoading = false;
                          });
                          firebaseServices.setTruckerHomeLocationToDatabase(
                              address: address, deviceId: deviceId.toString());
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Row(
                              children: [
                                Text(
                                  "Detect my location",
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          isLoading
                              ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 5,
                              width:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.7,
                              child: const LinearProgressIndicator(
                                color: Colors.yellow,
                              ),
                            ),
                          )
                              : Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              userAddress.toString(),
                              style: GoogleFonts.nunito(
                                  color: Colors.white70, fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 33,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.searchTextEditingController,
                    style: GoogleFonts.nunito(color: Colors.white70),
                    decoration: InputDecoration(
                      fillColor: const Color(0xff80ad72).withOpacity(0.9),
                      filled: true,
                      hintText: "Search",
                      hintStyle: GoogleFonts.nunito(color: Colors.white70),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      prefixIcon: const Icon(
                        Icons.search_outlined,
                        color: Colors.white70,
                      ),
                      suffixIcon: const Icon(
                        Icons.mic_none_outlined,
                        color: Colors.white70,
                      ),
                      contentPadding: EdgeInsets.zero,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
