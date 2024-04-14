// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CategoryWidget extends StatelessWidget {
//   final String categoryName;
//   final String categoryImageUrl;
//
//   const CategoryWidget({
//     required this.categoryName,
//     required this.categoryImageUrl,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(15).r,
//       child: Container(
//         padding: EdgeInsets.only(top: 25),
//         decoration: BoxDecoration(
//
//           borderRadius: BorderRadius.circular(10),
//
//           color: Color.fromRGBO(0, 176, 255, 0.2),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 40.r,
//               backgroundImage: NetworkImage(
//                 categoryImageUrl,
//               ),
//             ),
//
//             SizedBox(height: 10.h),
//             Text(
//               categoryName,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryWidget extends StatelessWidget {
  final String categoryName;
  final String categoryImageUrl;

  const CategoryWidget({
    required this.categoryName,
    required this.categoryImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: categoryBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 25.h),
          CircleAvatar(
            radius: 40.r,
            backgroundImage: NetworkImage(
              categoryImageUrl,
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                categoryName,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 25.h), // Adjust as needed
        ],
      ),
    );
  }
}

// Define color constant
const Color categoryBackgroundColor = Color.fromRGBO(0, 176, 255, 0.2);
