//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:project/Activity/store_screen.dart';
//
// class OrdersPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Get the current user
//     User? user = FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(108, 99, 255, 1),
//         title: Text(
//           "Orders",
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//             fontSize: 30,
//           ),
//         ),
//       ),
//       body: StreamBuilder(
//         // Filter orders based on the current user's ID
//         stream: FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: 'incomplete').where('userId', isEqualTo: user?.uid).snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               DocumentSnapshot document = snapshot.data!.docs[index];
//               Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//               return Column(
//                 children: [
//                   ListTile(
//                     title: Text(
//                       '${data['productName']}',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Price: \$${data['productPrice'].toString()}',
//                           style: TextStyle(fontSize: 17),
//                         ),
//                         Text(
//                           'Vendor: ${data['vendorName']}',
//                           style: TextStyle(fontSize: 17),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                     trailing: ElevatedButton.icon(
//                       onPressed: () {
//                         // Mark the order as complete in Firebase
//                         FirebaseFirestore.instance.collection('orders').doc(document.id).update({'status': 'complete'});
//                       },
//                       icon: Icon(Icons.check, color: Colors.white),
//                       label: Text(''),
//                       style: ElevatedButton.styleFrom(
//                         shape: CircleBorder(),
//                         backgroundColor: Color.fromRGBO(108, 99, 255, 1),
//                         padding: EdgeInsets.all(16.0),
//                       ),
//                     ),
//                     onTap: () {
//                       // Handle tapping on an order to view details
//                       // You can navigate to a new page to display more details here
//                     },
//                   ),
//                   Divider(color: Colors.grey),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project/Activity/store_screen.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(108, 99, 255, 1),
        title: Text(
          "Orders",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
      body: StreamBuilder(
        // Filter orders based on the current user's ID
        stream: FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: 'incomplete').where('userId', isEqualTo: user?.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      '${data['productName']}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: \$${data['productPrice'].toString()}',
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          'Vendor: ${data['vendorName']}',
                          style: TextStyle(fontSize: 17),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: ElevatedButton.icon(
                      onPressed: () {
                        // Display rating dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Rate Vendor"),
                              content: ReviewPage(
                                vendorID: data['vendorId'],
                                documentId: document.id,
                                productId : data['productId'],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.check, color: Colors.white),
                      label: Text(''),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Color.fromRGBO(108, 99, 255, 1),
                        padding: EdgeInsets.all(16.0),
                      ),
                    ),
                    onTap: () {
                      // Handle tapping on an order to view details
                      // You can navigate to a new page to display more details here
                    },
                  ),
                  Divider(color: Colors.grey),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// class RateVendorDialog extends StatefulWidget {
//   final String vendorId;
//   final String documentId;
//   final double currentRating;
//   final int currentNumberOfRatings;
//
//   RateVendorDialog({required this.vendorId, required this.documentId, required this.currentRating, required this.currentNumberOfRatings});
//
//   @override
//   _RateVendorDialogState createState() => _RateVendorDialogState();
// }
//
// class _RateVendorDialogState extends State<RateVendorDialog> {
//   double _newRating = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text("Rate the vendor on a scale of 5 stars:"),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(5, (index) {
//             return IconButton(
//               icon: Icon(index < _newRating ? Icons.star : Icons.star_border),
//               onPressed: () {
//                 setState(() {
//                   _newRating = index + 1;
//                 });
//               },
//             );
//           }),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             // Calculate new average rating and number of ratings
//             double newAverageRating = ((_newRating + (widget.currentRating * widget.currentNumberOfRatings)) / (widget.currentNumberOfRatings + 1));
//             int newNumberOfRatings = widget.currentNumberOfRatings + 1;
//
//             // Update vendor rating and number of ratings in Firestore
//             await FirebaseFirestore.instance.collection('vendors').doc(widget.vendorId).update({
//               'rating': newAverageRating,
//               'numberOfRatings': newNumberOfRatings,
//             });
//
//             // Mark order as complete in Firestore
//             await FirebaseFirestore.instance.collection('orders').doc(widget.documentId).update({'status': 'complete'});
//
//             // Print vendor ID, updated rating, and order status
//             print('Vendor ID: ${widget.vendorId}, Updated Rating: $newAverageRating, Number of Ratings: $newNumberOfRatings, Order Status: complete');
//
//             // Close the dialog
//             Navigator.pop(context);
//           },
//           child: Text('Rate'),
//         ),
//       ],
//     );
//   }
// }
class ReviewPage extends StatefulWidget {
  final  vendorID;
  final documentId;
  final productId;
  ReviewPage({required this.vendorID, this.documentId, this.productId});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  TextEditingController _reviewController = TextEditingController();
  double _rating = 0;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave a Review'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                submitReview(_rating, _reviewController.text, _currentUser.uid, widget.vendorID, widget.documentId, widget.productId);
                Navigator.pop(context);
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}

void submitReview(double rating, String reviewText, String userId, String vendorId, String documentId, String productId) async {
  // Add the new review
  await FirebaseFirestore.instance.collection("vendors").doc(vendorId).collection('reviews').add({
    'rating': rating,
    'reviewText': reviewText,
    'userId': userId,
    'vendorId': vendorId,
    'timestamp': DateTime.now(),
  });
  await FirebaseFirestore.instance.collection('orders').doc(documentId).update({'status': 'complete'});

  // Recalculate and update average rating
  double averageRating = await calculateAverageRating(vendorId);
  await FirebaseFirestore.instance.collection('vendors').doc(vendorId).update({
    'rating': averageRating,
  });
  
  double averageProdRating = await calculateProdAverageRating(productId);
  await FirebaseFirestore.instance.collection('products').doc(productId).update(
      {
        'rating': averageProdRating,
      });
}

Future<double> calculateAverageRating(String vendorId) async {
  QuerySnapshot reviews = await FirebaseFirestore.instance
      .collection('vendors').doc(vendorId).collection('reviews')
      .where('vendorId', isEqualTo: vendorId)
      .get();

  if (reviews.docs.isEmpty) {
    return 0;
  }

  double totalRating = 0;
  for (var doc in reviews.docs) {
    totalRating += doc['rating'];
  }

  return totalRating / reviews.docs.length;
}

Future<double> calculateProdAverageRating(String productId) async {
  QuerySnapshot reviews = await FirebaseFirestore.instance
  .collection('vendors')
  .where('productId', isEqualTo: productId)
  .get();
  if (reviews.docs.isEmpty) {
    return 0;
  }

  double totalRating = 0;
  for (var doc in reviews.docs) {
    totalRating += doc['rating'];
  }

  return totalRating / reviews.docs.length;
  
}