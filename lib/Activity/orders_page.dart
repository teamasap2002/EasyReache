//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:project/Activity/store_screen.dart';
//
//
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
//
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
                        // Mark the order as complete in Firebase
                        FirebaseFirestore.instance.collection('orders').doc(document.id).update({'status': 'complete'});
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
