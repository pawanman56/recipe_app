import 'package:flutter/material.dart';

import 'package:recipe_app/app.dart';
import 'package:recipe_app/state_widget.dart';

void main() {
  StateWidget stateWidget = new StateWidget(child: new RecipeApp());
  runApp(stateWidget);
}