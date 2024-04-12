

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/Activity/recommended_product_widget.dart';

class ApiDataFetcher extends StatefulWidget {
  final String apiUrl;
  final String heading;

  const ApiDataFetcher({
    Key? key,
    required this.apiUrl,
    required this.heading,
  }) : super(key: key);

  @override
  _ApiDataFetcherState createState() => _ApiDataFetcherState();
}

class _ApiDataFetcherState extends State<ApiDataFetcher> {
  late Future<List<String>> _data;

  @override
  void initState() {
    super.initState();
    _data = _fetchData();
  }

  Future<List<String>> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(widget.apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<String> parsedData = List<String>.from(responseData);
        return parsedData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for data
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Return an empty container if an error occurs
          return Container();
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // Display the fetched data using RecommendedProductWidget
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.heading,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 176, 255, 1)),
                ),
              ),
              RecommendedProductWidget(productIds: snapshot.data!),
            ],
          );
        } else {
          // Return an empty container by default
          return Container();
        }
      },
    );
  }
}

