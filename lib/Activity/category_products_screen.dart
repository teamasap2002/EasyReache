//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'product_vendors_screen.dart'; // Import the ProductVendorsScreen
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
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProductVendorsScreen(
//                                 productId: product.id,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ListTile(
//                               leading: CircleAvatar(
//                                 radius: 30.r,
//                                 backgroundImage: NetworkImage(product['image']),
//                               ),
//                               title: Text(
//                                 product['productName'],
//                                 style: TextStyle(
//                                   fontSize: 20.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: const Color.fromRGBO(108, 99, 255, 1),
//                                 ),
//                               ),
//                               subtitle: Text(product['productDescription']),
//                               // You can add more information here such as price, etc.
//                             ),
//                             Divider(color: Colors.grey),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
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
import 'product_vendors_screen.dart'; // Import the ProductVendorsScreen

class CategoryProductsScreen extends StatefulWidget {
  final String categoryId; // Accept categoryId as parameter

  const CategoryProductsScreen({required this.categoryId, Key? key})
      : super(key: key);

  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
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
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
              future: FirebaseFirestore.instance
                  .collection('products')
                  .where('categoryId', isEqualTo: widget.categoryId) // Filter products by categoryId
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

                  // Filter products based on search query
                  final filteredProducts = products.where((product) {
                    final productName = product['productName'].toString().toLowerCase();
                    final searchQuery = _searchController.text.toLowerCase();
                    return productName.contains(searchQuery);
                  }).toList();

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Text('No matching products found'),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
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
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.amber, size: 20.sp),
                                            SizedBox(width: 5.w),
                                            Text('${product['rating']}', style: TextStyle(fontSize: 16.sp)),
                                          ],
                                        ),
                                        Text(product['productDescription']),
                                      ],
                                    ),
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
          ),
        ],
      ),
    );
  }
}
