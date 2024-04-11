//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ProductVendorDetailsPopup extends StatelessWidget {
//   final String vendorProductId;
//   final String vendorId; // New field for vendor ID
//   final String productId; // New field for product ID
//   final String vendorName;
//   final String vendorCity;
//   final String vendorState;
//   final double productPrice;
//   final double rating; // New field for rating
//   final Timestamp time; // New field for time
//
//   const ProductVendorDetailsPopup({
//     required this.vendorProductId,
//     required this.vendorId,
//     required this.productId,
//     required this.vendorName,
//     required this.vendorCity,
//     required this.vendorState,
//     required this.productPrice,
//     required this.rating, // Added rating parameter
//     required this.time, // Added time parameter
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//
//     return FutureBuilder<DocumentSnapshot>(
//       future: FirebaseFirestore.instance.collection('products').doc(vendorProductId).get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else if (!snapshot.hasData || snapshot.data == null) {
//           return Center(
//             child: Text('Product details not found'),
//           );
//         } else {
//           final productData = snapshot.data!.data() as Map<String, dynamic>;
//           final productName = productData['productName'] ?? 'Product Name';
//
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Product Details',
//                               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.close),
//                               onPressed: () {
//                                 Navigator.of(context).pop(); // Close the dialog
//                               },
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Name: $productName',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           'Vendor Details',
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Name: $vendorName',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Text(
//                           'City: $vendorCity',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         Text(
//                           'State: $vendorState',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (user != null) {
//                           String userId = user.uid;
//                           String userName = user.displayName ?? 'Unknown User';
//                           // Create order and store it in Firebase
//                           FirebaseFirestore.instance.collection('orders').add({
//                             'userId': userId,
//                             'userName': userName,
//                             'productId': productId, // Store product ID
//                             'vendorId': vendorId, // Store vendor ID
//                             'productName': productName,
//                             'vendorName': vendorName,
//                             'vendorCity': vendorCity,
//                             'vendorState': vendorState,
//                             'productPrice': productPrice, // Store product price
//                             'rating': rating, // Store rating
//                             'time': time, // Store current time
//                             // Add more fields as needed
//                           }).then((value) {
//                             // Handle success
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Text('Success'),
//                                   content: Text('Request sent successfully !'),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop(); // Close alert dialog
//                                         Navigator.of(context).pop(); // Close popup screen
//                                       },
//                                       child: Text('OK'),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           }).catchError((error) {
//                             // Handle error
//                             print('Failed to place order: $error');
//                           });
//                         } else {
//                           // User is not logged in
//                           // Handle this case, maybe navigate to login screen
//                           print('User is not logged in');
//                         }
//                       },
//                       child: Text('Request Service'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductVendorDetailsPopup extends StatelessWidget {
  final String vendorProductId;
  final String vendorId; // New field for vendor ID
  final String productId; // New field for product ID
  final String vendorName;
  final String vendorCity;
  final String vendorState;
  final double productPrice;
  final double rating; // New field for rating
  final Timestamp time; // New field for time

  const ProductVendorDetailsPopup({
    required this.vendorProductId,
    required this.vendorId,
    required this.productId,
    required this.vendorName,
    required this.vendorCity,
    required this.vendorState,
    required this.productPrice,
    required this.rating, // Added rating parameter
    required this.time, // Added time parameter
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('products').doc(vendorProductId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text('Product details not found'),
          );
        } else {
          final productData = snapshot.data!.data() as Map<String, dynamic>;
          final productName = productData['productName'] ?? 'Product Name';
          final fetchedProductPrice = double.parse(productData['productPrice'] ?? '0.0');

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Product Details',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Name: $productName',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Price: \$${fetchedProductPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Vendor Details',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Name: $vendorName',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'City: $vendorCity',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'State: $vendorState',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (user != null) {
                          String userId = user.uid;
                          String userName = user.displayName ?? 'Unknown User';
                          // Create order and store it in Firebase
                          FirebaseFirestore.instance.collection('orders').add({
                            'userId': userId,
                            'userName': userName,
                            'productId': productId, // Store product ID
                            'vendorId': vendorId, // Store vendor ID
                            'productName': productName,
                            'vendorName': vendorName,
                            'vendorCity': vendorCity,
                            'vendorState': vendorState,
                            'productPrice': fetchedProductPrice, // Store fetched product price
                            'rating': rating, // Store rating
                            'time': time, // Store current time
                            'status': 'incomplete', // Default status
                            // Add more fields as needed
                          }).then((value) {
                            // Handle success
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Success'),
                                  content: Text('Request sent successfully !'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close alert dialog
                                        Navigator.of(context).pop(); // Close popup screen
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).catchError((error) {
                            // Handle error
                            print('Failed to place order: $error');
                          });
                        } else {
                          // User is not logged in
                          // Handle this case, maybe navigate to login screen
                          print('User is not logged in');
                        }
                      },


                      child: Text('Request Service'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
