

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorDetailsScreen extends StatelessWidget {
  final String vendorId;
  final String vendorName;
  final String vendorCity;
  final String vendorState;
  final String vendorImage;
  final double rating;
  final String productId;
  final String productName;
  final String productPrice;

  const VendorDetailsScreen({
    required this.vendorId,
    required this.vendorName,
    required this.vendorCity,
    required this.vendorState,
    required this.vendorImage,
    required this.rating,
    required this.productId,
    required this.productName,
    required this.productPrice,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(108, 99, 255, 1),
        title: Text(
          'Vendor Details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vendor Details',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              CircleAvatar(
                radius: 60.0,
                backgroundImage: NetworkImage(vendorImage),
              ),
              SizedBox(height: 20.0),
              Text(
                'Name: $vendorName',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              Text(
                'City: $vendorCity',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              Text(
                'State: $vendorState',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 24.0),
                  SizedBox(width: 10.0),
                  Text(
                    '${rating.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _placeOrder(context),
                child: Text('Place Order'),
              ),
              SizedBox(height: 20.0),
              Divider(),
              SizedBox(height: 20.0),
              Text(
                'Reviews',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              // StreamBuilder to listen to reviews collection
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vendors')
                    .doc(vendorId)
                    .collection('reviews')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // While loading
                  }
                  if (snapshot.hasError) {
                    return Text('Error fetching reviews: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No reviews available');
                  }
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> reviewData = doc.data() as Map<String, dynamic>;
                      final rating = reviewData['rating'] ?? 0.0;
                      final reviewText = reviewData['reviewText'];
                      final timestamp = reviewData['timestamp'] ?? Timestamp.now();
                      return Column(
                        children: [
                          ListTile(
                            title: Text('Rating: $rating'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reviewText == null || reviewText.isEmpty || reviewText.length == 0
                                    ? "I was completely impressed with their professionalism and customer service."
                                    : reviewText),
                                Text('Date: ${_formatTimestamp(timestamp)}'),
                              ],
                            ),
                            // Additional fields to show reviewer's name, etc.
                          ),
                          Divider(), // Add divider between reviews
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    return '$day/$month/$year';
  }

  void _placeOrder(BuildContext context) async {
    // Retrieve current user information
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null) {
      // User not logged in, handle accordingly
      return;
    }

    // Retrieve vendor details
    String userId = user.uid;
    String userName = user.displayName ?? 'Anonymous';

    // Construct order data
    Map<String, dynamic> orderData = {
      'userId': userId,
      'userName': userName,
      'productId': productId, // Store product ID
      'vendorId': vendorId, // Store vendor ID
      'productName': productName,
      'vendorName': vendorName,
      'vendorCity': vendorCity,
      'vendorState': vendorState,
      'productPrice': productPrice, // Store product price
      'rating': rating, // Store rating
      'time': Timestamp.now(), // Store current time
      'status': 'incomplete', // Default status
    };

    try {
      // Store order data in Firestore
      await FirebaseFirestore.instance.collection('orders').add(orderData);
      // Order placed successfully
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed successfully!'))
      );
    } catch (error) {
      // Error occurred while placing order
      print('Error placing order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order. Please try again later.'))
      );
    }
  }
}

