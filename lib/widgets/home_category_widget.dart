import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Activity/category_products_screen.dart';
import 'category_widget.dart';

class HomeCategoryWidget extends StatelessWidget {
  const HomeCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
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
          final categories = snapshot.data!.docs;
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemCount: categories.length > 6 ? 6 : categories.length, // Display maximum of 6 categories
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryId = category.id; // Adjust field name according to your Firestore structure
              final categoryName = category['categoryName']; // Adjust field name according to your Firestore structure
              final categoryImageUrl = category['image']; // Adjust field name according to your Firestore structure
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryProductsScreen(categoryId: categoryId),
                    ),
                  );
                },
                child: CategoryWidget(
                  categoryName: categoryName,
                  categoryImageUrl: categoryImageUrl,
                ),
              );
            },
          );
        }
      },
    );
  }
}
