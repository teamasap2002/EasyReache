import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditAddress extends StatefulWidget {
  final String documentId;

  const EditAddress({Key? key, required this.documentId}) : super(key: key);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController houseController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  GoogleMapController? mapController;
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    fetchAddressDetails();
  }

  // Fetch address details from Firestore
  void fetchAddressDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(user?.uid)
          .collection('Addresses')
          .doc(widget.documentId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        setState(() {
          houseController = TextEditingController(text: data['House details']);
          areaController = TextEditingController(text: data['Area details']);
          cityController = TextEditingController(text: data['City']);
          pincodeController = TextEditingController(text: data['Pincode']);
          stateController = TextEditingController(text: data['State']);
        });
      }
    } catch (e) {
      print('Error fetching address details: $e');
    }
  }

  // Fetch current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        // Automatically fill the text fields with the fetched location data
        _fetchAddressFromCoordinates(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _fetchAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks.first;
      // Update text controllers with address details
      setState(() {
        houseController.text = place.name ?? '';
        areaController.text = place.thoroughfare ?? '';
        cityController.text = place.locality ?? '';
        pincodeController.text = place.postalCode ?? '';
        stateController.text = place.administrativeArea ?? '';
      });
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  void updateAddress() async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.uid)
          .collection('Addresses')
          .doc(widget.documentId)
          .update({
        'House details': houseController.text,
        'Area details': areaController.text,
        'City': cityController.text,
        'Pincode': pincodeController.text,
        'State': stateController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address Edited successfully!'),
        ),
      );
    } catch (e) {
      print('Error saving address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save address. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Address'),
        backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: houseController,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 191, 166, 1))),
                    labelText: 'House',
                    labelStyle: TextStyle(
                    color: const Color.fromRGBO(0, 191, 166, 1),
                    fontSize: 20.sp)
                ),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                showCursor: true,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
              ),
              TextFormField(
                controller: areaController,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 191, 166, 1))),
                    labelText: 'Area',
                    labelStyle: TextStyle(
                        color: const Color.fromRGBO(0, 191, 166, 1),
                        fontSize: 20.sp)),
                  style: TextStyle(color: Colors.black, fontSize: 18.sp),
                  textAlign: TextAlign.start,
                  showCursor: true,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 191, 166, 1))),
                    labelText: 'City',
                    labelStyle: TextStyle(
                        color: const Color.fromRGBO(0, 191, 166, 1),
                        fontSize: 20.sp)),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                showCursor: true,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
              ),
              TextFormField(
                controller: pincodeController,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 191, 166, 1))),
                    labelText: 'Pincode',
                    labelStyle: TextStyle(
                        color: const Color.fromRGBO(0, 191, 166, 1),
                        fontSize: 20.sp)),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                showCursor: true,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
              ),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 191, 166, 1))),
                    labelText: 'State',
                    labelStyle: TextStyle(
                        color: const Color.fromRGBO(0, 191, 166, 1),
                        fontSize: 20.sp)),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                showCursor: true,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
              ),
              SizedBox(height: 16.h),
              // Display current location if available
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 191, 166, 1)),
                onPressed: () {
                  updateAddress();
                },
                child:
                    const Text('Update Address', style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 191, 166, 1)),
                onPressed: _getCurrentLocation,
                child: const Text(
                  'Use Current Location',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
