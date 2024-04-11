//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CategoryProductsScreen extends StatelessWidget {
//   final String categoryId; // Accept categoryId as parameter
//
//   const CategoryProductsScreen({required this.categoryId, Key? key})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(108, 99, 255, 1),
//         title: Text(
//           'Products',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('products')
//             .where('categoryId', isEqualTo: categoryId) // Filter products by categoryId
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
//             final products = snapshot.data!.docs;
//             if (products.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('No products in this category'),
//                     SizedBox(height: 20.h),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('Explore other'),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: products.length,
//                     itemBuilder: (context, index) {
//                       final product = products[index];
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ListTile(
//                             leading: CircleAvatar(
//                               radius: 30.r,
//                               backgroundImage: NetworkImage(product['image']),
//                             ),
//                             title: Text(
//                               product['productName'],
//                               style: TextStyle(
//                                 fontSize: 20.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: const Color.fromRGBO(108, 99, 255, 1),
//                               ),
//                             ),
//                             subtitle: Text(product['productDescription']),
//                             // You can add more information here such as price, etc.
//                             trailing: IconButton(
//                               icon: Icon(Icons.add),
//                               onPressed: () {
//                                 _showProductDetailsDialog(context, product);
//                               },
//                             ),
//                           ),
//                           Divider(color: Colors.grey),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
//
//
//   void _showProductDetailsDialog(BuildContext context, DocumentSnapshot product) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Text(
//                   product['productName'],
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 // Display product image as profile photo
//                 Center(
//                   child: CircleAvatar(
//                     radius: 50.0,
//                     backgroundImage: NetworkImage(product['image']),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 SizedBox(height: 5),
//                 Text(product['productDescription']),
//                 SizedBox(height: 10),
//                 Text('Price:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 SizedBox(height: 5),
//                 Text(product['productPrice']), // Assuming 'productPrice' is a field in Firestore
//                 // Add more details as needed
//                 SizedBox(height: 20),
//                 Align(
//                   alignment: Alignment.center,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       _placeOrder(product);
//                       Navigator.of(context).pop(); // Close the dialog after placing the order
//                     },
//                     child: Text('Request Service'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _placeOrder(DocumentSnapshot product) {
//     // Get user information, you need to replace it with your own method to get user information
//     String userId = 'user123'; // Replace it with your user ID
//     String userName = 'John Doe'; // Replace it with your user name
//
//     // Add order to Firestore 'orders' collection
//     FirebaseFirestore.instance.collection('orders').add({
//       'userId': userId,
//       'userName': userName,
//       'productId': product.id, // Assuming product ID is used as the identifier
//       'productName': product['productName'],
//       'productDescription': product['productDescription'],
//       'productPrice': product['productPrice'],
//       // Add more fields as needed
//       'timestamp': Timestamp.now(), // Add timestamp for order
//     }).then((value) {
//       // Order placed successfully
//       print('Order placed successfully!');
//     }).catchError((error) {
//       // Error occurred while placing order
//       print('Error placing order: $error');
//     });
//   }
//
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'product_vendors_screen.dart'; // Import the ProductVendorsScreen

class CategoryProductsScreen extends StatelessWidget {
  final String categoryId; // Accept categoryId as parameter

  const CategoryProductsScreen({required this.categoryId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(108, 99, 255, 1),
        title: Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: categoryId) // Filter products by categoryId
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
            final products = snapshot.data!.docs;
            if (products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No products in this category'),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Explore other'),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductVendorsScreen(
                                productId: product.id,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30.r,
                                backgroundImage: NetworkImage(product['image']),
                              ),
                              title: Text(
                                product['productName'],
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(108, 99, 255, 1),
                                ),
                              ),
                              subtitle: Text(product['productDescription']),
                              // You can add more information here such as price, etc.
                            ),
                            Divider(color: Colors.grey),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
