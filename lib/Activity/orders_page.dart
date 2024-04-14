// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class OrdersPage extends StatefulWidget {
//   @override
//   _OrdersPageState createState() => _OrdersPageState();
// }
//
// class _OrdersPageState extends State<OrdersPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('orders').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//
//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//               return ListTile(
//                 title: Text(data['productName']),
//                 subtitle: Text('Price: \$${data['productPrice'].toString()}, Rating: ${data['rating'].toString()}'),
//                 onTap: () {
//                   // Handle tapping on an order to view details
//                   // You can navigate to a new page to display more details here
//                 },
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 191, 166, 1),
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
        stream: FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: 'incomplete').snapshots(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            data['productName'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                          ),
                          subtitle: Text(
                            'Price: \$${data['productPrice'].toString()}, Rating: ${data['rating'].toString()}',
                            style: TextStyle(fontSize: 17.sp),
                          ),
                          onTap: () {
                            // Handle tapping on an order to view details
                            // You can navigate to a new page to display more details here
                          },
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              double userRating = 3.5; // Default rating
                              return AlertDialog(
                                title: Text("Rate Vendor"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    StarRatingWidget(
                                      initialRating: userRating,

                                      onRatingChanged: (rating) {
                                        userRating = rating;
                                      },
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Update the status of the order to 'complete'
                                      FirebaseFirestore.instance.collection('orders').doc(document.id).update({'status': 'complete'})
                                          .then((_) {
                                        // Successfully updated the status
                                        print('Order marked as complete successfully');

                                        // Show a success alert for order completion
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Order completed successfully')),
                                        );

                                        // Calculate the new average rating for the vendor
                                        FirebaseFirestore.instance.collection('vendors').where('vendorId', isEqualTo: data['vendorId']).get()
                                            .then((vendorQuerySnapshot) {
                                          if (vendorQuerySnapshot.docs.isNotEmpty) {
                                            // There should be only one document with this vendorId
                                            final vendorDoc = vendorQuerySnapshot.docs.first;
                                            double currentRating = vendorDoc['rating'] ?? 3.5; // Get current rating or default to 0
                                            int numberOfRatings = vendorDoc['numberOfRatings'] ?? 1; // Get current number of ratings or default to 0

                                            // Calculate new average rating
                                            double newRating = ((currentRating * numberOfRatings) + userRating) / (numberOfRatings + 1);

                                            print('Current Rating: $currentRating');
                                            print('Number of Ratings: $numberOfRatings');
                                            print('User Rating: $userRating');
                                            print('New Rating: $newRating');

                                            // Update vendor rating and numberOfRatings in Firestore
                                            FirebaseFirestore.instance.collection('vendors').doc(vendorDoc.id).update({
                                              'rating': newRating,
                                              'numberOfRatings': numberOfRatings + 1,
                                            })
                                                .then((_) {
                                              // Successfully updated the vendor rating
                                              print('Vendor rating updated successfully');
                                            })
                                                .catchError((error) {
                                              // Error handling for updating vendor rating
                                              print('Error updating vendor rating: $error');
                                            });
                                          } else {
                                            // Vendor document not found, add a new document
                                            FirebaseFirestore.instance.collection('vendors').add({
                                              'vendorId': data['vendorId'],
                                              'rating': userRating,
                                              'numberOfRatings': 1,
                                            })
                                                .then((_) {
                                              // Successfully added new vendor document
                                              print('New vendor document added successfully');
                                            })
                                                .catchError((error) {
                                              // Error handling for adding new vendor document
                                              print('Error adding new vendor document: $error');
                                            });
                                          }
                                        })
                                            .catchError((error) {
                                          // Error handling for fetching vendor document
                                          print('Error fetching vendor document: $error');
                                        });
                                      })
                                          .catchError((error) {
                                        // Error handling, if any
                                        // You can show an error message or handle the error as needed
                                        print('Error marking order as complete: $error');
                                      });

                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: Text('Rate'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.check, color: Colors.white),
                        label: Text(''),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Color.fromRGBO(0, 191, 166, 1),
                          padding: EdgeInsets.all(16.0).r,
                        ),
                      ),
                    ],
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

class StarRatingWidget extends StatefulWidget {
  final Function(double) onRatingChanged;
  final double initialRating;

  const StarRatingWidget({
    Key? key,
    required this.onRatingChanged,
    required this.initialRating,
  }) : super(key: key);

  @override
  _StarRatingWidgetState createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
            widget.onRatingChanged(_rating);
          },
          icon: Icon(
            index < _rating.floor() ? Icons.star : Icons.star_border,
            color: Color.fromRGBO(108, 99, 255, 1),
          ),
        );
      }),
    );
  }
}
