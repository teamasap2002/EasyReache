import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  final Function(double) onRatingChanged;
  final double initialRating;

  const StarRatingWidget({
    Key? key,
    required this.onRatingChanged,
    required this.initialRating,
  }) : super(key: key);

  @override
  _StarRatingWidgetState createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
            widget.onRatingChanged(_rating);
          },
          icon: Icon(
            index < _rating.floor() ? Icons.star : Icons.star_border,
            color: Color.fromRGBO(108, 99, 255, 1),
          ),
        );
      }),
    );
  }
}
