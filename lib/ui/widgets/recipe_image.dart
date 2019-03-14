import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageUrl;

  RecipeImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}