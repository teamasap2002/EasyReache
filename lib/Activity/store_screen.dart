//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'category_products_screen.dart';
// import 'product_vendors_screen.dart'; // Import ProductVendorsScreen
//
// class StoreScreen extends StatelessWidget {
//   const StoreScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       // Handle hardware back button presses
//       onWillPop: () async {
//         // Navigate back
//         Navigator.pop(context);
//         // Return false to prevent the default back button behavior
//         return false;
//       },
//       child: FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance.collection('products').get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final products = snapshot.data!.docs;
//             final categoriesMap = <String, List<DocumentSnapshot>>{};
//
//             // Separate products by categoryId
//             products.forEach((product) {
//               final categoryId = product['categoryId'] ?? 'Other';
//               if (!categoriesMap.containsKey(categoryId)) {
//                 categoriesMap[categoryId] = [];
//               }
//               categoriesMap[categoryId]!.add(product);
//             });
//
//             // Display products under their respective categories
//             return Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Color.fromRGBO(108, 99, 255, 1),
//                 title: Text(
//                   "Services",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white,
//                     fontSize: 30.sp,
//                   ),
//                 ),
//                 // Add a back button to navigate back
//                 leading: IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: () {
//                     // Navigate back
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               body: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: categoriesMap.entries.map((entry) {
//                     final categoryId = entry.key;
//                     final categoryProducts = entry.value.take(2).toList(); // Display only 2 products
//                     final remainingProductsCount = entry.value.length - 2;
//
//                     return FutureBuilder<DocumentSnapshot>(
//                       future: FirebaseFirestore.instance.collection('categories').doc(categoryId).get(),
//                       builder: (context, categorySnapshot) {
//                         if (categorySnapshot.connectionState == ConnectionState.waiting) {
//                           return CircularProgressIndicator();
//                         } else if (categorySnapshot.hasError) {
//                           return Text('Error: ${categorySnapshot.error}');
//                         } else {
//                           final categoryName = categorySnapshot.data!['categoryName'];
//
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(15),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       categoryName, // Display category name
//                                       style: TextStyle(
//                                         color: Color.fromRGBO(108, 99, 255, 1),
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     if (remainingProductsCount > 0)
//                                       TextButton(
//                                         onPressed: () {
//                                           // Navigate to CategoryProductsScreen
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) => CategoryProductsScreen(categoryId: categoryId),
//                                             ),
//                                           );
//                                         },
//                                         child: Text(
//                                           'View More ($remainingProductsCount)',
//                                           style: TextStyle(fontSize: 17.sp),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                               Divider(color: Colors.grey),
//                               if (categoryProducts.isNotEmpty) // Check if category has products
//                                 Column(
//                                   children: categoryProducts.map((product) {
//                                     // Custom widget to display each product with its image
//                                     return GestureDetector(
//                                       onTap: () {
//                                         // Navigate to ProductVendorsScreen when product is clicked
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => ProductVendorsScreen(productId: product.id),
//                                           ),
//                                         );
//                                       },
//                                       child: Column(
//                                         children: [
//                                           ListTile(
//                                             leading: CircleAvatar(
//                                               radius: 35.r,
//                                               backgroundImage: NetworkImage(product['image']),
//                                             ),
//                                             title: Text(
//                                               product['productName'],
//                                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
//                                             ),
//                                             subtitle: Text(
//                                               product['productDescription'],
//                                               style: TextStyle(fontSize: 17.sp),
//                                             ),
//                                           ),
//                                           Divider(color: Colors.grey),
//                                         ],
//                                       ),
//                                     );
//                                   }).toList(),
//                                 )
//                               else
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text('No products in this category'),
//                                 ),
//                             ],
//                           );
//                         }
//                       },
//                     );
//                   }).toList(),
//                 ),
//               ),
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

import 'category_products_screen.dart';
import 'product_vendors_screen.dart'; // Import ProductVendorsScreen

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
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
          "Services",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 30.sp,
          ),
        ),
        // Add a back button to navigate back
        leading: IconButton(
          icon: Icon(Icons.arrow_back , color: Colors.white,),
          onPressed: () {
            // Navigate back
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Products...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Color.fromRGBO(108, 99, 255, 1)),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Update the UI when text changes
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('products').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final products = snapshot.data!.docs;
                  final categoriesMap = <String, List<DocumentSnapshot>>{};

                  // Separate products by categoryId
                  products.forEach((product) {
                    final categoryId = product['categoryId'] ?? 'Other';
                    if (!categoriesMap.containsKey(categoryId)) {
                      categoriesMap[categoryId] = [];
                    }
                    categoriesMap[categoryId]!.add(product);
                  });

                  return ListView(
                    children: categoriesMap.entries.map((entry) {
                      final categoryId = entry.key;
                      final categoryProducts = entry.value.take(2).toList(); // Display only 2 products
                      final remainingProductsCount = entry.value.length - 2;

                      // Filter products based on search query
                      List<DocumentSnapshot> filteredProducts = categoryProducts.where((product) {
                        String productName = product['productName'].toString().toLowerCase();
                        return productName.contains(_searchController.text.toLowerCase());
                      }).toList();

                      if (filteredProducts.isNotEmpty) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('categories').doc(categoryId).get(),
                          builder: (context, categorySnapshot) {
                            if (categorySnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (categorySnapshot.hasError) {
                              return Text('Error: ${categorySnapshot.error}');
                            } else {
                              final categoryName = categorySnapshot.data!['categoryName'];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          categoryName, // Display category name
                                          style: TextStyle(
                                            color: Color.fromRGBO(108, 99, 255, 1),
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                        if (remainingProductsCount > 0)
                                          TextButton(
                                            onPressed: () {
                                              // Navigate to CategoryProductsScreen
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CategoryProductsScreen(categoryId: categoryId),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'View More ($remainingProductsCount)',
                                              style: TextStyle(fontSize: 17.sp),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Divider(color: Colors.grey),
                                  Column(
                                    children: filteredProducts.map((product) {
                                      // Custom widget to display each product with its image
                                      return GestureDetector(
                                        onTap: () {
                                          // Navigate to ProductVendorsScreen when product is clicked
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProductVendorsScreen(productId: product.id),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: CircleAvatar(
                                                radius: 35.r,
                                                backgroundImage: NetworkImage(product['image']),
                                              ),
                                              title: Text(
                                                product['productName'],
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star, color: Colors.amber, size: 20.sp),
                                                      SizedBox(width: 5.w),
                                                      // Text('${product['rating']}', style: TextStyle(fontSize: 16.sp)),
                                                      Text(
                                                        '${product['rating'].toStringAsFixed(1)}', // Display rating with two digits after the decimal point
                                                        style: TextStyle(fontSize: 18.0),
                                                      ),

                                                    ],
                                                  ),
                                                  Text(
                                                    product['productDescription'],
                                                    style: TextStyle(fontSize: 17.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(color: Colors.grey),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      } else {
                        return Container(); // Return an empty container if no products match the search query
                      }
                    }).toList(),
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
