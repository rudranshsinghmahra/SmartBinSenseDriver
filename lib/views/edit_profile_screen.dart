import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../services/firebase_services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  TextEditingController truckController = TextEditingController();
  TextStyle style = GoogleFonts.nunito();
  FirebaseServices firebaseServices = FirebaseServices();
  XFile? _image;
  String? networkImageUrl;
  String? deviceId;
  bool isUploadingData = false;

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

  Future getTruckerData(String deviceId) async {
    firebaseServices.getTruckDriverDetails(deviceId).then((dataSnapshot) {
      if (dataSnapshot.value != null) {
        // Data found based on deviceId filter
        Map<dynamic, dynamic>? values =
            dataSnapshot.value as Map<dynamic, dynamic>?;
        if (values != null) {
          values.forEach((key, values) {
            setState(() {
              nameController.text = values['name'];
              emailController.text = values['email'];
              phoneController.text = values['phoneNumber'];
              plateController.text = values['plateNumber'];
              truckController.text = values['truckModel'];
              networkImageUrl = values['imageUrl'];
            });
          });
          print(_image);
        }
      } else {
        // No data found based on plateNumber filter
        showCustomToast("No existing data found");
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _image = pickedImage;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _image = pickedImage;
                    });
                  }
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  void initState() {
    initDeviceId().then((deviceId) {
      print("This is my device: $deviceId");
      getTruckerData(deviceId.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 5),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.6,
                            offset: Offset(-0.2, 0.2),
                            blurRadius: 3)
                      ]),
                  child: GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: _image == null
                        ? (networkImageUrl?.isNotEmpty ??
                                false) // Check if networkImageUrl is not null and not empty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  networkImageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                size: 80,
                              )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              TextField(
                controller: nameController,
                style: style,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: style,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: style,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: style,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: style,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: style,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: style,
                controller: plateController,
                decoration: InputDecoration(
                  labelStyle: style,
                  labelText: 'Truck Plate Number',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                style: style,
                controller: truckController,
                decoration: InputDecoration(
                  labelStyle: style,
                  labelText: 'Truck Model',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isUploadingData = true;
                        });
                        try {
                          if (nameController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  phoneController.text.isNotEmpty &&
                                  plateController.text.isNotEmpty &&
                                  truckController.text.isNotEmpty &&
                                  _image != null ||
                              networkImageUrl != null) {
                            if (_image == null) {
                              firebaseServices
                                  .addTruckDriverDetailsToDatabase(
                                      name: nameController.text,
                                      email: emailController.text.trim(),
                                      phoneNumber: phoneController.text.trim(),
                                      plateNumber: plateController.text.trim(),
                                      imageUrl: networkImageUrl.toString(),
                                      truckModel: truckController.text.trim(),
                                      deviceId: deviceId.toString())
                                  .then((value) {
                                setState(() {
                                  isUploadingData = false;
                                });
                                showCustomToast(
                                    "Details uploaded successfully...");
                              });
                            } else {
                              firebaseServices
                                  .uploadImageToStorage(_image)
                                  .then((imageUrl) {
                                if (imageUrl != null) {
                                  firebaseServices
                                      .addTruckDriverDetailsToDatabase(
                                          name: nameController.text,
                                          email: emailController.text.trim(),
                                          phoneNumber:
                                              phoneController.text.trim(),
                                          plateNumber:
                                              plateController.text.trim(),
                                          imageUrl: imageUrl.toString(),
                                          truckModel:
                                              truckController.text.trim(),
                                          deviceId: deviceId.toString())
                                      .then((value) {
                                    setState(() {
                                      isUploadingData = false;
                                    });
                                    showCustomToast(
                                        "Details uploaded successfully...");
                                  });
                                } else {
                                  showCustomToast("Failed to upload image");
                                }
                              });
                            }
                          } else {
                            showCustomToast(
                                "Please enter the required field(s)");
                          }
                        } catch (e) {
                          print("Error occurred ${e.toString()}");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 12),
                        child: isUploadingData
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Text(
                                  'Submit',
                                  style: style,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
