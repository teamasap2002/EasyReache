import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 191,166, 1),
        title: Text(
          "Orders",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 30.sp,
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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: \Rs. ${data['productPrice'].toString()}',
                          style: TextStyle(fontSize: 17.sp),
                        ),
                        Text(
                          'Vendor: ${data['vendorName']}',
                          style: TextStyle(fontSize: 17.sp),
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
                            return ReviewPage(
                                vendorID: data['vendorId'],
                                documentId: document.id,
                                productId : data['productId'],
                              );
                          },
                        );
                      },
                      icon: Icon(Icons.check, color: Colors.white),
                      label: Text(''),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                        padding: EdgeInsets.all(16.0.r),
                      ),
                    ),
                    onTap: () {
                      // Handle tapping on an order to view details
                      // You can navigate to a new page to display more details here
                    },
                  ),
                  const Divider(color: Colors.grey),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

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
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Rate Service",
            style: TextStyle(
              color: const Color.fromRGBO(0, 191, 166, 1),
              fontSize: 24.sp,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
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
          SizedBox(height: 20.h),
          TextFormField(
            controller: _reviewController,
            decoration: InputDecoration(
              labelText: 'Write your review',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
            textStyle: const TextStyle(color: Colors.white),
          ),
          onPressed: () {
            submitReview(_rating, _reviewController.text, _currentUser.uid,
                widget.vendorID, widget.documentId, widget.productId);
            Navigator.pop(context);
          },
          child: Text('Submit Review', style: TextStyle(color: Colors.black, fontSize: 17.sp),),
        ),

      ],
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