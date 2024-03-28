import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'category_products_screen.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
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

          // Display products under their respective categories
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(108, 99, 255, 1),
              title: Text("Services", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 30.sp),),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categoriesMap.entries.map((entry) {
                  final categoryId = entry.key;
                  final categoryProducts = entry.value.take(2).toList(); // Display only 2 products
                  final remainingProductsCount = entry.value.length - 2;

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
                                      child: Text('View More ($remainingProductsCount)', style: TextStyle(fontSize: 17.sp),),
                                    ),
                                ],
                              ),
                            ),
                            Divider(color: Colors.grey),
                            if (categoryProducts.isNotEmpty) // Check if category has products
                              Column(
                                children: categoryProducts.map((product) {
                                  // Custom widget to display each product with its image
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 35.r,
                                          backgroundImage: NetworkImage(product['image']),
                                        ),
                                        title: Text(product['productName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),),
                                        subtitle: Text(product['productDescription'], style: TextStyle(fontSize: 17.sp),),
                                        // Plus icon button
                                        trailing: IconButton(
                                          onPressed: () {
                                            // Handle adding the product to the cart
                                            // You can add your logic here
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Service Request Placed')),
                                            );
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ),
                                      Divider(color: Colors.grey),
                                    ],
                                  );
                                }).toList(),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('No products in this category'),
                              ),
                          ],
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}
