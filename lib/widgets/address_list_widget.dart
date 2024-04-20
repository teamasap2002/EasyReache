//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:project/Activity/address.dart';
//
// class AddressListWidget extends StatefulWidget {
//   final String vendorId;
//   final String productId;
//   final String productName;
//   final String productPrice;
//   final String vendorName;
//   final String vendorCity;
//   final String vendorState;
//   final double rating;
//   final Function(String) onPlaceOrder;
//
//   const AddressListWidget({
//     required this.vendorId,
//     required this.productId,
//     required this.productName,
//     required this.productPrice,
//     required this.vendorName,
//     required this.vendorCity,
//     required this.vendorState,
//     required this.rating,
//     required this.onPlaceOrder,
//   });
//
//   @override
//   _AddressListWidgetState createState() => _AddressListWidgetState();
// }
//
// class _AddressListWidgetState extends State<AddressListWidget> {
//   String? selectedAddressId;
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       // Handle scenario where user is not authenticated
//       return Container(); // You can return an empty container or show a login screen
//     }
//
//     String userId = user.uid;
//
//     return Scaffold(
//
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('Users')
//             .doc(userId)
//             .collection('Addresses')
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return CircularProgressIndicator(); // Show loading indicator while fetching data
//           }
//
//           List<DocumentSnapshot> documents = snapshot.data!.docs;
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: documents.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     Map<String, dynamic> address =
//                     documents[index].data() as Map<String, dynamic>;
//                     String addressId = documents[index].id;
//                     bool isSelected = addressId == selectedAddressId;
//
//                     return AddressTile(
//                       address: address,
//                       isSelected: isSelected,
//                       onSelect: () {
//                         setState(() {
//                           selectedAddressId = addressId;
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (selectedAddressId != null) {
//                     // Concatenate selected address
//                     String selectedAddress = _concatenateAddress(documents.firstWhere((doc) => doc.id == selectedAddressId).data() as Map<String, dynamic>?);
//                     // Trigger place order callback
//                     widget.onPlaceOrder(selectedAddress);
//                   } else {
//                     // No address selected
//                     print('No address selected');
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Address(),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   String _concatenateAddress(Map<String, dynamic>? addressData) {
//     if (addressData == null) {
//       return 'No address data';
//     }
//
//     // Explicitly cast addressData to Map<String, dynamic>
//     final Map<String, dynamic> data = addressData as Map<String, dynamic>;
//
//     // Concatenate address fields into a single string
//     String houseDetails = data['House details'] ?? 'No house details';
//     String areaDetails = data['Area details'] ?? 'No area details';
//     String city = data['City'] ?? 'Unknown City';
//     String state = data['State'] ?? 'Unknown State';
//     String pincode = data['Pincode'] ?? 'Unknown Pincode';
//     return '$houseDetails, $areaDetails, $city, $state - $pincode';
//   }
//
//
// }
//
// class AddressTile extends StatelessWidget {
//   final Map<String, dynamic> address;
//   final bool isSelected;
//   final VoidCallback onSelect;
//
//   AddressTile({
//     required this.address,
//     required this.isSelected,
//     required this.onSelect,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(address['House details'] ?? 'No house details'),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(address['Area details'] ?? 'No area details'),
//           Text(
//               '${address['City'] ?? 'Unknown City'}, ${address['State'] ?? 'Unknown State'} - ${address['Pincode'] ?? 'Unknown Pincode'}'),
//         ],
//       ),
//       trailing: Radio<bool>(
//         value: isSelected,
//         groupValue: true,
//         onChanged: (_) => onSelect(),
//       ),
//       onTap: onSelect,
//     );
//   }
// }
//


// // ---------- code with proper working of popup box with placing order including address
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:project/Activity/address.dart';
//
// class AddressListWidget extends StatefulWidget {
//   final String vendorId;
//   final String productId;
//   final String productName;
//   final String productPrice;
//   final String vendorName;
//   final String vendorCity;
//   final String vendorState;
//   final double rating;
//   final Function(String) onPlaceOrder;
//
//   const AddressListWidget({
//     required this.vendorId,
//     required this.productId,
//     required this.productName,
//     required this.productPrice,
//     required this.vendorName,
//     required this.vendorCity,
//     required this.vendorState,
//     required this.rating,
//     required this.onPlaceOrder,
//   });
//
//   @override
//   _AddressListWidgetState createState() => _AddressListWidgetState();
// }
//
// class _AddressListWidgetState extends State<AddressListWidget> {
//   String? selectedAddressId;
//
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       // Handle scenario where user is not authenticated
//       return Container(); // You can return an empty container or show a login screen
//     }
//
//     String userId = user.uid;
//
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('Users')
//             .doc(userId)
//             .collection('Addresses')
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return CircularProgressIndicator();
//           }
//
//           List<DocumentSnapshot> documents = snapshot.data!.docs;
//           return Column(
//             children: [
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Address(),
//                     ),
//                   );
//                 },
//                 child: Text('Add Address'),
//               ),
//               SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: documents.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     Map<String, dynamic> address =
//                     documents[index].data() as Map<String, dynamic>;
//                     String addressId = documents[index].id;
//                     bool isSelected = addressId == selectedAddressId;
//
//                     return AddressTile(
//                       address: address,
//                       isSelected: isSelected,
//                       onSelect: () {
//                         setState(() {
//                           selectedAddressId = addressId;
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (selectedAddressId != null) {
//                     String selectedAddress = _concatenateAddress(
//                         documents.firstWhere((doc) => doc.id == selectedAddressId)
//                             .data() as Map<String, dynamic>?);
//                     widget.onPlaceOrder(selectedAddress);
//                   } else {
//                     print('No address selected');
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   String _concatenateAddress(Map<String, dynamic>? addressData) {
//     if (addressData == null) {
//       return 'No address data';
//     }
//
//     final Map<String, dynamic> data = addressData;
//
//     String houseDetails = data['House details'] ?? 'No house details';
//     String areaDetails = data['Area details'] ?? 'No area details';
//     String city = data['City'] ?? 'Unknown City';
//     String state = data['State'] ?? 'Unknown State';
//     String pincode = data['Pincode'] ?? 'Unknown Pincode';
//     return '$houseDetails, $areaDetails, $city, $state - $pincode';
//   }
// }
//
// class AddressTile extends StatelessWidget {
//   final Map<String, dynamic> address;
//   final bool isSelected;
//   final VoidCallback onSelect;
//
//   AddressTile({
//     required this.address,
//     required this.isSelected,
//     required this.onSelect,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(address['House details'] ?? 'No house details'),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(address['Area details'] ?? 'No area details'),
//           Text(
//               '${address['City'] ?? 'Unknown City'}, ${address['State'] ?? 'Unknown State'} - ${address['Pincode'] ?? 'Unknown Pincode'}'),
//         ],
//       ),
//       trailing: Radio<bool>(
//         value: isSelected,
//         groupValue: true,
//         onChanged: (_) => onSelect(),
//       ),
//       onTap: onSelect,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/Activity/address.dart';

class AddressListWidget extends StatefulWidget {
  final String vendorId;
  final String productId;
  final String productName;
  final String productPrice;
  final String vendorName;
  final String vendorCity;
  final String vendorState;
  final double rating;
  final Function(String) onPlaceOrder;

  const AddressListWidget({
    required this.vendorId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.vendorName,
    required this.vendorCity,
    required this.vendorState,
    required this.rating,
    required this.onPlaceOrder,
  });

  @override
  _AddressListWidgetState createState() => _AddressListWidgetState();
}

class _AddressListWidgetState extends State<AddressListWidget> {
  String? selectedAddressId;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle scenario where user is not authenticated
      return Container(); // You can return an empty container or show a login screen
    }

    String userId = user.uid;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Addresses')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return Column(
            children: [
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Address(),
                    ),
                  );
                },
                child: Text('Add Address'),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> address =
                    documents[index].data() as Map<String, dynamic>;
                    String addressId = documents[index].id;
                    bool isSelected = addressId == selectedAddressId;

                    return AddressTile(
                      address: address,
                      isSelected: isSelected,
                      onSelect: () {
                        setState(() {
                          selectedAddressId = addressId;
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedAddressId != null) {
                    String selectedAddress = _concatenateAddress(
                        documents.firstWhere((doc) => doc.id == selectedAddressId)
                            .data() as Map<String, dynamic>?);
                    widget.onPlaceOrder(selectedAddress);
                    Navigator.pop(context); // Close the popup box
                    _showSuccessAlert(context);
                  } else {
                    print('No address selected');
                  }
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _concatenateAddress(Map<String, dynamic>? addressData) {
    if (addressData == null) {
      return 'No address data';
    }

    final Map<String, dynamic> data = addressData;

    String houseDetails = data['House details'] ?? 'No house details';
    String areaDetails = data['Area details'] ?? 'No area details';
    String city = data['City'] ?? 'Unknown City';
    String state = data['State'] ?? 'Unknown State';
    String pincode = data['Pincode'] ?? 'Unknown Pincode';
    return '$houseDetails, $areaDetails, $city, $state - $pincode';
  }

  void _showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Service Requested Successfully"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AddressTile extends StatelessWidget {
  final Map<String, dynamic> address;
  final bool isSelected;
  final VoidCallback onSelect;

  AddressTile({
    required this.address,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(address['House details'] ?? 'No house details'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(address['Area details'] ?? 'No area details'),
          Text(
              '${address['City'] ?? 'Unknown City'}, ${address['State'] ?? 'Unknown State'} - ${address['Pincode'] ?? 'Unknown Pincode'}'),
        ],
      ),
      trailing: Radio<bool>(
        value: isSelected,
        groupValue: true,
        onChanged: (_) => onSelect(),
      ),
      onTap: onSelect,
    );
  }
}
