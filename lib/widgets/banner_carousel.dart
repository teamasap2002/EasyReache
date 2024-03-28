import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
    await _firestoreInstance.collection("Banners").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["image"],
        );
        print(qn.docs[i]["image"]);
      }
    });

    return qn.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15).r,
          child: CarouselSlider(
            items: _carouselImages
                .map(
                  (item) => Padding(
                padding: const EdgeInsets.only(left: 3, right: 3),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(item),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            )
                .toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1,
              aspectRatio: 2.0,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              onPageChanged: (val, carouselPageChangedReason) {
                setState(() {
                  _dotPosition = val;
                });
              },
            ),
          ),
        ),
        DotsIndicator(
          dotsCount:
          _carouselImages.isEmpty ? 1 : _carouselImages.length,
          position: _dotPosition.toDouble(),
          decorator: const DotsDecorator(
            activeColor:Color.fromRGBO(0, 176, 255, 1),
            color: Colors.grey,
            spacing: EdgeInsets.all(2),
            activeSize: Size(10, 10),
            size: Size(8, 8),
          ),
        ),
      ],
    );
  }
}
