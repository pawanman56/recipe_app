import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/model/state.dart';
import 'package:recipe_app/state_widget.dart';
import 'package:recipe_app/ui/screens/login.dart';
import 'package:recipe_app/ui/widgets/recipe_card.dart';
import 'package:recipe_app/utils/store.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  
  StateModel appState;

  DefaultTabController _buildTabView({Widget body}) {
    const double _iconSize = 20.0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
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
          child: body,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (appState.isLoading) {
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
      return new LoginScreen();
    } else {
      return _buildTabView(
        body: _buildTabsContent(),
      );
    }
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  TabBarView _buildTabsContent() {
    Padding _buildRecipes({RecipeType recipeType, List<String> ids}) {
      CollectionReference collectionReference = Firestore.instance.collection('recipes');
      Stream<QuerySnapshot> stream;

      if (recipeType != null) {
        stream = collectionReference
          .where('type', isEqualTo: recipeType.index)
          .snapshots(); 
      } else {
        stream = collectionReference.snapshots();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: new StreamBuilder(
                stream: stream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return _buildLoadingIndicator();

                  return new ListView(
                    children: snapshot.data.documents
                      .where((d) => ids == null || ids.contains(d.documentID))
                      .map((document) {
                        return new RecipeCard(
                          recipe: Recipe.fromMap(document.data, document.documentID),
                          inFavorites: appState.favorites.contains(document.documentID),
                          onFavoriteButtonPressed: _handleFavoritesListChanged
                        );
                      }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      children: [
        _buildRecipes(recipeType: RecipeType.food),
        _buildRecipes(recipeType: RecipeType.drink),
        _buildRecipes(ids: appState.favorites),
        Center(child: Icon(Icons.settings)),
      ],
    );
  }

  void _handleFavoritesListChanged(String recipeId) {
    updateFavorites(appState.user.uid, recipeId).then((result) {
      if (result == true) {
        setState(() {
          if (!appState.favorites.contains(recipeId)) {
            appState.favorites.add(recipeId);
          } else {
            appState.favorites.remove(recipeId);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appState =  StateWidget.of(context).state;
    return _buildContent();
  }
}