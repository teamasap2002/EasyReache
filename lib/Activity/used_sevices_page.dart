import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsedServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(108, 99, 255, 1),
        title: Text(
          "Used Services",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: 'complete').snapshots(),
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
                      data['productName'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(
                      'Price: \$${data['productPrice'].toString()}, Rating: ${data['rating'].toString()}',
                      style: TextStyle(fontSize: 17),
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
