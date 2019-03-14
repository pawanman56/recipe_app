import 'package:flutter/material.dart';

import 'package:recipe_app/model/recipe.dart';

class RecipeTitle extends StatelessWidget {
  final Recipe recipe;
  final double padding;

  RecipeTitle(this.recipe, this.padding);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Icon(Icons.timer, size: 20.0),
              SizedBox(width: 5.0),
              Text(
                recipe.getDurationString,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          )
        ],
      ),
    );
  }
}