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

  void deleteAddress(String documentId) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_currentUserUid)
        .collection('Addresses')
        .doc(documentId)
        .delete()
        .then((value) => print("Address deleted successfully"))
        .catchError((error) => print("Failed to delete address: $error"));
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
                return Dismissible(
                  key: Key(document.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    deleteAddress(document.id);
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(5).r,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(0, 191, 166, 1),
                              width: 2.0.sp), // Add border
                          borderRadius: BorderRadius.circular(
                              10), // Optional: Add border radius
                        ),
                        child: ListTile(
                          title: Text(
                            document.id,
                            style: TextStyle(
                                color: const Color.fromRGBO(0, 191, 166, 1),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(data['House details'] ?? ''
                            ,maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,),
                          trailing: SizedBox(
                            width: 110.w,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Color.fromRGBO(0, 191, 166, 1),
                                  ),
                                  onPressed: () {
                                    // Navigate to edit address page with address data
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditAddress(documentId: document.id),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red,),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Delete Address", style: TextStyle(color: Color.fromRGBO(0, 191, 166, 1))),
                                          content: Text("Are you sure you want to delete this address?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context); // Close the dialog
                                              },
                                              child: const Text("Cancel", style: TextStyle(color: Color.fromRGBO(0, 191, 166, 1))),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteAddress(document.id);
                                                Navigator.pop(context); // Close the dialog
                                              },
                                              child: const Text("Delete", style: TextStyle(color: Colors.red),),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),

                              ],
                            ),
                          ),
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
