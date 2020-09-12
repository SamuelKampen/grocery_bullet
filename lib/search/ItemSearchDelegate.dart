import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/utils.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/widgets/CurrentLocationBuilder.dart';
import 'package:grocery_bullet/widgets/GroceryItem.dart';

class ItemSearchDelegate extends SearchDelegate<Item> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return CurrentLocationBuilder(
      asyncWidgetBuilder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.blueGrey,
          );
        }
        Location location = snapshot.data;
        List<GroceryItem> items = [];
        for (Item item in location.grocery) {
          GroceryItem groceryItem = GroceryItem(
            item: item,
          );
          if (item.count <= 0) {
            continue;
          }
          if (item.name.toLowerCase().contains(query.toLowerCase())) {
            items.add(groceryItem);
          } else if (item.category.toLowerCase() == query.toLowerCase()) {
            items.add(groceryItem);
          }
        }
        // Sort search results, first by position of query in the name, then
        // alphabetically.
        items.sort((a, b) {
          String aName = a.item.name.toLowerCase();
          String bName = b.item.name.toLowerCase();
          if (aName.indexOf(query) != bName.indexOf(query)) {
            return aName.indexOf(query).compareTo(bName.indexOf(query));
          }
          return aName.compareTo(bName);
        });
        if (items.length > 0) {
          return ListView(
            children: items,
          );
        }
        return Container(
          child: Center(
            child: Text(
              'No items match your search!',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return CurrentLocationBuilder(
      asyncWidgetBuilder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.blueGrey,
          );
        }
        Location location = snapshot.data;
        List<Card> suggestions = [];
        Set<String> categories = Set();
        for (Item item in location.grocery) {
          if (item.count > 0) {
            categories.add(item.category);
          }
        }
        for (String category in categories) {
          suggestions.add(
            Card(
              child: ListTile(
                title: Text(Utils.titleCase(category)),
                onTap: () {
                  query = category;
                  showResults(context);
                },
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        }
        return ListView(
          children: suggestions,
        );
      },
    );
  }
}
