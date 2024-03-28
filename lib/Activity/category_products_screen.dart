import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            .where('categoryId',
                isEqualTo: categoryId) // Filter products by categoryId
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
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Column(
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
                            color: const Color.fromRGBO(108, 99, 255, 1)),
                      ),
                      subtitle: Text(product['productDescription']),
                      // You can add more information here such as price, etc.
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          // Add your logic to handle adding the product to cart
                          // For example, you can call a function to add the product to cart
                          // cart.addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Service Request Placed')),
                          );
                        },
                      ),
                    ),
                    Divider(color: Colors.grey),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
