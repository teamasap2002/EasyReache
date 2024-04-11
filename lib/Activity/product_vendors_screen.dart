// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ProductVendorsScreen extends StatelessWidget {
//   final String productId;
//
//   const ProductVendorsScreen({required this.productId, Key? key})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Vendors'),
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
//                 return ListTile(
//                   title: Text(vendor['businessName']),
//                   // Add more details about the vendor if needed
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../widgets/vendor_details_popup_widget.dart';
//
//
// class ProductVendorsScreen extends StatelessWidget {
//   final String productId;
//
//   const ProductVendorsScreen({required this.productId, Key? key})
//       : super(key: key);
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
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ListTile(
//                       leading: CircleAvatar(
//                         radius: 30.r,
//                         // Assuming you have a 'vendorImage' field in your vendor document
//                         backgroundImage: NetworkImage(vendor['image']),
//                       ),
//                       title: Text(
//                         vendor['businessName'],
//                         style: TextStyle(
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.w500,
//                           color: const Color.fromRGBO(108, 99, 255, 1),
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.star, color: Colors.amber, size: 20.sp),
//                               SizedBox(width: 5.w),
//                               Text('${vendor['rating']}', style: TextStyle(fontSize: 16.sp)),
//                             ],
//                           ),
//                           SizedBox(height: 5.h),
//                           Text(
//                             'City: ${vendor['vendorCity']}',
//                             style: TextStyle(fontSize: 16.sp),
//                           ),
//                           SizedBox(height: 5.h),
//                           Text(
//                             'State: ${vendor['vendorState']}',
//                             style: TextStyle(fontSize: 16.sp),
//                           ),
//                         ],
//                       ),
//                       trailing: GestureDetector(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => ProductVendorDetailsPopup(
//                               vendorProductId: vendor['productId'],
//                               vendorName: vendor['businessName'],
//                               rating: vendor['rating'],
//                               vendorCity: vendor['vendorCity'],
//                               vendorState: vendor['vendorState'],
//                             ),
//                           );
//                         },
//                         child: Icon(Icons.arrow_forward_ios),
//                       ),
//                     ),
//                     Divider(color: Colors.grey),
//                   ],
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
import '../widgets/vendor_details_popup_widget.dart';

class ProductVendorsScreen extends StatelessWidget {
  final String productId;

  const ProductVendorsScreen({required this.productId, Key? key}) : super(key: key);

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
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('vendors')
            .where('productId', isEqualTo: productId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final vendors = snapshot.data!.docs;
            if (vendors.isEmpty) {
              return Center(
                child: Text('No vendors found for this product'),
              );
            }
            return ListView.builder(
              itemCount: vendors.length,
              itemBuilder: (context, index) {
                final vendor = vendors[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (productSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${productSnapshot.error}'),
                      );
                    } else {
                      final productData = productSnapshot.data!.data() as Map<String, dynamic>;
                      final productPrice = productData['productPrice'];

                      return Column(
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
                                    Text('${vendor['rating']}', style: TextStyle(fontSize: 16.sp)),
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
                            trailing: GestureDetector(
                              onTap: () {
                                // Ensure that you pass the rating and productPrice parameters when creating ProductVendorDetailsPopup widget
                                showDialog(
                                  context: context,
                                  builder: (context) => ProductVendorDetailsPopup(
                                    vendorProductId: vendor['productId'],
                                    vendorId: vendor.id,
                                    productId: productId,
                                    vendorName: vendor['businessName'],
                                    rating: vendor['rating'], // Pass rating parameter
                                    vendorCity: vendor['vendorCity'],
                                    vendorState: vendor['vendorState'],
                                    productPrice: productPrice ?? 'Price not available', // Pass productPrice parameter with placeholder text
                                    time: Timestamp.now(), // Pass time parameter
                                  ),
                                );
                              },
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(color: Colors.grey),
                        ],
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
