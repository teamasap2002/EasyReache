import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/widgets/banner_carousel.dart';
import 'package:project/widgets/home_category_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "EasyReaches",
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(0, 176, 255, 1),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.message,
              ),
            )
          ],
          leading: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/logo.png"),
            radius: 15,
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BannerCarousel(),
              SizedBox(
                height: 15,
              ),
              HomeCategoryWidget(),
            ],
          ),
        ),
      );
  }
}
