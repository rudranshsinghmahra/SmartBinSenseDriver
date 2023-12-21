import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: customAppBarLocation(searchTextEditingController),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapsHost(),
                      ),
                    );
                  },
                  child: const Text("Share my location")),
            )
          ],
        ),
      ),
    );
  }
}
