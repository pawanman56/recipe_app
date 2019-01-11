import 'package:flutter/material.dart';

import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/utils/store.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  
  List<Recipe> recipes = getRecipes();
  List<String> userFavorites = getFavoritesIds();

  void _handleFavoritesListChanged(String recipeId) {
    setState(() {
      if (userFavorites.contains(recipeId)) {
        userFavorites.remove(recipeId);
      } else {
        userFavorites.add(recipeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    Column _buildRecipes(List<Recipe> recipesList) {
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: recipesList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text(recipesList[index].name),);
              },
            ),
          )
        ],
      );
    }

    double _iconSize = 20.0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme.of(context).indicatorColor,
              tabs: [
                Tab(icon: Icon(Icons.restaurant, size: _iconSize)),
                Tab(icon: Icon(Icons.local_drink, size: _iconSize)),
                Tab(icon: Icon(Icons.favorite, size: _iconSize)),
                Tab(icon: Icon(Icons.settings, size: _iconSize)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: TabBarView(
            children: [
              // Display recipes of type food
              _buildRecipes(recipes
                .where((recipe) => recipe.type == RecipeType.food)
                .toList()
              ),

              // Display recipes of type drink
              _buildRecipes(recipes
                .where((recipe) => recipe.type == RecipeType.drink)
                .toList()
              ),

              // Display favorite recipes
              _buildRecipes(recipes
                .where((recipe) => userFavorites.contains(recipe.id))
                .toList()
              ),
            ],
          ),
        ),
      ),
    );
  }
}