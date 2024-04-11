import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _addresseNameController = TextEditingController();
  late TextEditingController houseDetailsController;
  late TextEditingController areaDetailsController;
  late TextEditingController cityController;
  late TextEditingController pincodeController;
  late TextEditingController stateController;

  GoogleMapController? mapController;
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    houseDetailsController = TextEditingController();
    areaDetailsController = TextEditingController();
    cityController = TextEditingController();
    pincodeController = TextEditingController();
    stateController = TextEditingController();
  }

  @override
  void dispose() {
    houseDetailsController.dispose();
    areaDetailsController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    stateController.dispose();
    super.dispose();
  }

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
        houseDetailsController.text = place.name ?? '';
        areaDetailsController.text = place.thoroughfare ?? '';
        cityController.text = place.locality ?? '';
        pincodeController.text = place.postalCode ?? '';
        stateController.text = place.administrativeArea ?? '';
      });
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  Future<void> saveAddress() async {
    String addresseName = _addresseNameController.text;
    try {
      // Create a new document reference for the user's address
      DocumentReference addressRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(user?.uid) // Use the current user's ID
          .collection('Addresses')
          .doc(addresseName);

      // Create a map with the address details
      Map<String, dynamic> addressData = {
        'House details': houseDetailsController.text,
        'Area details': areaDetailsController.text,
        'City': cityController.text,
        'Pincode': pincodeController.text,
        'State': stateController.text,
      };

      // Set the data to the document reference
      await addressRef.set(addressData);

      // Show success message or navigate to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Address saved successfully!'),
        ),
      );
    } catch (e) {
      // Show error message if saving fails
      print('Error saving address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
        title: const Text('Add Address'),
        backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _addresseNameController,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 191, 166, 1))),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(0, 191, 166, 1),
                        fontSize: 20.sp)),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                showCursor: true,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
              ),
              TextFormField(
                controller: houseDetailsController,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 191, 166, 1))),
                    labelText: 'House Details',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(0, 191, 166, 1),
                        fontSize: 20.sp)),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                showCursor: true,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
              ),
              TextFormField(
                controller: areaDetailsController,
                decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Color.fromRGBO(0, 191, 166, 1))),
                    labelText: 'Area Details',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(0, 191, 166, 1),
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
                        color: Color.fromRGBO(0, 191, 166, 1),
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
                        color: Color.fromRGBO(0, 191, 166, 1),
                        fontSize: 20.sp)),
                keyboardType: TextInputType.number,
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
                        color: Color.fromRGBO(0, 191, 166, 1),
                        fontSize: 20.sp)),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                showCursor: true,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0, 191, 166, 1)),
                onPressed: _getCurrentLocation,
                child: Text(
                  'Use Current Location',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0, 191, 166, 1)),
                onPressed: () {
                  // Add logic to save address details
                  saveAddress();
                },
                child: Text(
                  'Save Address',
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
