//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//
// class RecommendedProductWidget extends StatelessWidget {
//   final List<String> productIds;
//
//   const RecommendedProductWidget({Key? key, required this.productIds}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 250, // Adjusted height to prevent overflow
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('products')
//                 .where(FieldPath.documentId, whereIn: productIds)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               if (snapshot.hasError || !snapshot.hasData) {
//                 return Center(
//                   child: Text('Error fetching data'),
//                 );
//               }
//               final List<DocumentSnapshot> documents = snapshot.data!.docs;
//               if (documents.isEmpty) {
//                 return Center(
//                   child: Text('No recommended products found'),
//                 );
//               }
//               return ListView.builder(
//                 scrollDirection: Axis.horizontal, // Horizontal scroll
//                 itemCount: documents.length,
//                 itemBuilder: (context, index) {
//                   final product = documents[index];
//                   // Assuming your product model has fields like 'name', 'price', 'description', 'image', 'rating', etc.
//                   final productName = product['productName'];
//                   final productPrice = product['productPrice'];
//                   final productDescription = product['productDescription'];
//                   final productImage = product['image'];
//                   final productRating = product['rating'] ?? 0.0;
//
//                   return Container(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: SizedBox(
//                         width: 180, // Width of each card
//                         child: Card(
//                           elevation: 4,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           color: Colors.white,
//                           surfaceTintColor: Color.fromRGBO(0, 176, 255, 1),// Background color
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                                 child: Image.network(
//                                   productImage,
//                                   height: 100,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       productName,
//                                       style: TextStyle(
//                                         fontSize: 16.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                     ),
//                                     SizedBox(height: 4),
//                                     Row(
//                                       children: [
//                                         RatingBarIndicator(
//                                           rating: productRating.toDouble(),
//                                           itemBuilder: (context, index) => Icon(
//                                             Icons.star,
//                                             color: Colors.amber,
//                                           ),
//                                           itemCount: 5,
//                                           itemSize: 20.0,
//                                         ),
//                                         SizedBox(width: 4),
//                                         Text(
//                                           '(${productRating.toStringAsFixed(1)})',
//                                           style: TextStyle(fontSize: 14.0),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       'Price: $productPrice',
//                                       style: TextStyle(fontSize: 14.0),
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       productDescription,
//                                       style: TextStyle(fontSize: 12.0),
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project/Activity/product_vendors_screen.dart';

class RecommendedProductWidget extends StatelessWidget {
  final List<String> productIds;

  const RecommendedProductWidget({Key? key, required this.productIds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250, // Adjusted height to prevent overflow
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .where(FieldPath.documentId, whereIn: productIds)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Text('Error fetching data'),
                );
              }
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return Center(
                  child: Text('No recommended products found'),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal, // Horizontal scroll
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final product = documents[index];
                  final productId = product.id; // Get the product ID

                  // Assuming your product model has fields like 'name', 'price', 'description', 'image', 'rating', etc.
                  final productName = product['productName'];
                  final productPrice = product['productPrice'];
                  final productDescription = product['productDescription'];
                  final productImage = product['image'];
                  final productRating = product['rating'] ?? 0.0;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductVendorsScreen(productId: productId),
                        ),
                      );
                    },
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 180, // Width of each card
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.white,
                            surfaceTintColor: Color.fromRGBO(0, 176, 255, 1),// Background color
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Image.network(
                                    productImage,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          RatingBarIndicator(
                                            rating: productRating.toDouble(),
                                            itemBuilder: (context, index) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '(${productRating.toStringAsFixed(1)})',
                                            style: TextStyle(fontSize: 14.0),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Price: $productPrice',
                                        style: TextStyle(fontSize: 14.0),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        productDescription,
                                        style: TextStyle(fontSize: 12.0),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
