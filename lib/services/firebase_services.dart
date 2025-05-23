import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import '../views/log_in_screen.dart';
import '../views/otp_verify_screen.dart';

class FirebaseServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference bins = FirebaseFirestore.instance.collection("bins");
  CollectionReference helpline =
      FirebaseFirestore.instance.collection("helpline");
  CollectionReference driver = FirebaseFirestore.instance.collection("driver");
  User? user = FirebaseAuth.instance.currentUser;
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+91${phoneNumber.toString().trim()}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          if (kDebugMode) {
            print('The provided phone number is not valid.');
          }
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerifyScreen(
              verificationId: verificationId,
            ),
          ),
        );
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> logOut(BuildContext context) async {
    await firebaseAuth.signOut().then((value) => {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Logout successful. See you again!",
              style: GoogleFonts.nunito(color: Colors.black),
            ),
            backgroundColor: Colors.grey.shade400,
          )),
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LogInScreen()))
        });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<String?> uploadImageToStorage(XFile? image) async {
    try {
      if (image != null) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
              'driver_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
            );

        await storageRef.putFile(File(image.path));

        final String downloadURL = await storageRef.getDownloadURL();

        return downloadURL;
      }
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
    }
    return null;
  }

  Future<void> addTruckDriverDetailsToDatabase({
    required String name,
    required String email,
    required String phoneNumber,
    required String plateNumber,
    required String imageUrl,
    required String truckModel,
    required String deviceId,
  }) async {
    await databaseReference.child(deviceId).update({
      "name": name.trim(),
      "email": email.trim(),
      "phoneNumber": phoneNumber,
      "plateNumber": plateNumber,
      "imageUrl": imageUrl,
      "truckModel": truckModel,
      "deviceId": deviceId.toString(),
      "userId": user?.uid,
    });
  }

  //Method to Fetch Data from Realtime Database based on Specific Condition
  Future<DataSnapshot> getTruckDriverDetails(String deviceID) async {
    DataSnapshot dataSnapshot = await databaseReference
        .orderByChild("deviceId")
        .equalTo(deviceID)
        .get();
    return dataSnapshot;
  }

//Function to get Truck Driver Details from Firebase Realtime Database
// Future<Map<String, dynamic>?> getTruckDriverDetails(String deviceId) async {
//   DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
//
//   try {
//     DatabaseEvent event = await databaseReference.child(deviceId).once();
//
//     if (event.snapshot.value != null) {
//       Map<String, dynamic> data = Map<String, dynamic>.from(
//           event.snapshot.value as Map<dynamic, dynamic>);
//       return data;
//     } else {
//       // Data does not exist
//       return null;
//     }
//   } catch (error) {
//     if (kDebugMode) {
//       print("Error fetching data: $error");
//     }
//     return null;
//   }
// }

  Future<String> getUserAddress() async {
    // Initialize location service and permissions
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return 'Location service is not enabled.';
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return 'Location permissions are not granted.';
      }
    }

    // Get current user location
    LocationData currentLocation = await location.getLocation();

    // Use geocoding to get the address
    List<geocoding.Placemark> placeMarks =
        await geocoding.placemarkFromCoordinates(
            currentLocation.latitude!.toDouble(),
            currentLocation.longitude!.toDouble());

    geocoding.Placemark firstPlaceMarks = placeMarks[0];

    return '${firstPlaceMarks.name}, ${firstPlaceMarks.subLocality}, ${firstPlaceMarks.locality}, ${firstPlaceMarks.administrativeArea} - ${firstPlaceMarks.postalCode}';
  }

  Future<void> setTruckerHomeLocationToDatabase({
    required String address,
    required String deviceId,
  }) async {
    await databaseReference.child(deviceId).update({
      "address": address.trim(),
    });
  }
}
