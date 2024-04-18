//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../widgets/vendor_details_popup_widget.dart';
//
// class ProductVendorsScreen extends StatelessWidget {
//   final String productId;
//
//   const ProductVendorsScreen({required this.productId, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(108, 99, 255, 1),
//         title: Text(
//           'Vendors',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('vendors')
//             .where('productId', isEqualTo: productId)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             final vendors = snapshot.data!.docs;
//             if (vendors.isEmpty) {
//               return Center(
//                 child: Text('No vendors found for this product'),
//               );
//             }
//             return ListView.builder(
//               itemCount: vendors.length,
//               itemBuilder: (context, index) {
//                 final vendor = vendors[index];
//                 return FutureBuilder<DocumentSnapshot>(
//                   future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
//                   builder: (context, productSnapshot) {
//                     if (productSnapshot.connectionState == ConnectionState.waiting) {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     } else if (productSnapshot.hasError) {
//                       return Center(
//                         child: Text('Error: ${productSnapshot.error}'),
//                       );
//                     } else {
//                       final productData = productSnapshot.data!.data() as Map<String, dynamic>;
//                       final productPrice = productData['productPrice'];
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ListTile(
//                             leading: CircleAvatar(
//                               radius: 30.r,
//                               // Assuming you have a 'vendorImage' field in your vendor document
//                               backgroundImage: NetworkImage(vendor['image']),
//                             ),
//                             title: Text(
//                               vendor['businessName'],
//                               style: TextStyle(
//                                 fontSize: 20.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: const Color.fromRGBO(108, 99, 255, 1),
//                               ),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Icon(Icons.star, color: Colors.amber, size: 20.sp),
//                                     SizedBox(width: 5.w),
//                                     Text('${vendor['rating']}', style: TextStyle(fontSize: 16.sp)),
//                                   ],
//                                 ),
//                                 SizedBox(height: 5.h),
//                                 Text(
//                                   'City: ${vendor['vendorCity']}',
//                                   style: TextStyle(fontSize: 16.sp),
//                                 ),
//                                 SizedBox(height: 5.h),
//                                 Text(
//                                   'State: ${vendor['vendorState']}',
//                                   style: TextStyle(fontSize: 16.sp),
//                                 ),
//                               ],
//                             ),
//                             trailing: GestureDetector(
//                               onTap: () {
//                                 // Ensure that you pass the rating and productPrice parameters when creating ProductVendorDetailsPopup widget
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => ProductVendorDetailsPopup(
//                                     vendorProductId: vendor['productId'],
//                                     vendorId: vendor.id,
//                                     productId: productId,
//                                     vendorName: vendor['businessName'],
//                                     rating: vendor['rating'], // Pass rating parameter
//                                     vendorCity: vendor['vendorCity'],
//                                     vendorState: vendor['vendorState'],
//                                     productPrice: productPrice ?? 'Price not available', // Pass productPrice parameter with placeholder text
//                                     time: Timestamp.now(), // Pass time parameter
//                                   ),
//                                 );
//                               },
//                               child: Icon(Icons.arrow_forward_ios),
//                             ),
//                           ),
//                           Divider(color: Colors.grey),
//                         ],
//                       );
//                     }
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/Activity/vendor_details_screen.dart';
import '../widgets/vendor_details_popup_widget.dart';

class ProductVendorsScreen extends StatefulWidget {
  final String productId;

  const ProductVendorsScreen({required this.productId, Key? key}) : super(key: key);

  @override
  _ProductVendorsScreenState createState() => _ProductVendorsScreenState();
}

class _ProductVendorsScreenState extends State<ProductVendorsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(108, 99, 255, 1),
        title: Text(
          'Vendors',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Color.fromRGBO(108, 99, 255, 1)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Vendors...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {}); // Update the UI when text changes
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('vendors')
                  .where('productId', isEqualTo: widget.productId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final vendors = snapshot.data!.docs;
                  if (vendors.isEmpty) {
                    return Center(child: Text('No vendors found for this product'));
                  }

                  // Filter vendors based on search query
                  final filteredVendors = vendors.where((vendor) {
                    final businessName = vendor['businessName'].toString().toLowerCase();
                    final searchQuery = _searchController.text.toLowerCase();
                    return businessName.contains(searchQuery);
                  }).toList();

                  if (filteredVendors.isEmpty) {
                    return Center(child: Text('No matching vendors found'));
                  }

                  return ListView.builder(
                    itemCount: filteredVendors.length,
                    itemBuilder: (context, index) {
                      final vendor = filteredVendors[index];
                      return GestureDetector(
                        onTap: () async {
                          // Fetch product details from Firestore
                          DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').doc(vendor['productId']).get();
                          if (productSnapshot.exists) {
                            Map<String, dynamic> productData = productSnapshot.data() as Map<String, dynamic>;
                            String productPrice = productData['productPrice'];
                            String productName = productData['productName'];

                            // Navigate to VendorDetailsScreen with vendor and product details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VendorDetailsScreen(
                                  vendorId: vendor['vendorId'],
                                  vendorName: vendor['businessName'],
                                  vendorCity: vendor['vendorCity'],
                                  vendorState: vendor['vendorState'],
                                  vendorImage: vendor['image'],
                                  rating: vendor['rating'],
                                  productId: vendor['productId'],
                                  productName: productName,
                                  productPrice: productPrice,
                                ),
                              ),
                            );
                          } else {
                            // Handle the case where product details are not found
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Product details not found')),
                            );
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30.r,
                                // Assuming you have a 'vendorImage' field in your vendor document
                                backgroundImage: NetworkImage(vendor['image']),
                              ),
                              title: Text(
                                vendor['businessName'],
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(108, 99, 255, 1),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 20.sp),
                                      SizedBox(width: 5.w),
                                      Text(
                                        '${vendor['rating'].toStringAsFixed(1)}', // Display rating with two digits after the decimal point
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'City: ${vendor['vendorCity']}',
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'State: ${vendor['vendorState']}',
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                ],
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                            Divider(color: Colors.grey),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
