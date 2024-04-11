import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'addAddress.dart';
import 'editAddress.dart';

class Address extends StatefulWidget {
  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  late Stream<QuerySnapshot> _addressStream;
  late String _currentUserUid;

  @override
  void initState() {
    super.initState();
    _currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    _addressStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(_currentUserUid)
        .collection('Addresses')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
        backgroundColor: Color.fromRGBO(0, 191, 166, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _addressStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic>? data =
                    document.data() as Map<String, dynamic>?;
                if (data == null) {
                  return SizedBox(); // If data is null, return an empty widget
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(5).r,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(0, 191, 166, 1), width: 2.0.sp), // Add border
                        borderRadius: BorderRadius.circular(10), // Optional: Add border radius
                      ),
                      child: ListTile(
                        title: Text(
                          document.id,
                          style: TextStyle(
                              color: const Color.fromRGBO(0, 191, 166, 1),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        subtitle: Text(data['House details'] ?? ''),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: Color.fromRGBO(0, 191, 166, 1),),
                          onPressed: () {
                            // Navigate to edit address page with address data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditAddress(
                                  documentId: document.id
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No address found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 191, 166, 1),
        onPressed: () {
          // Navigate to the addAddress page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAddress(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
